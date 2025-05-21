class CommonAncestorQuery

  def self.call(a_node_id, b_node_id)
    new(a_node_id, b_node_id).call
  end

  def initialize(a_node_id, b_node_id)
    @a_node_id = a_node_id
    @b_node_id = b_node_id
  end

  def call
    ApplicationRecord.sanitize_sql([sql_query, {id_a: @a_node_id, id_b: @b_node_id}])
  end

  private 

  def sql_query
    query = <<-SQL
        WITH RECURSIVE parents_a AS (
          SELECT node.id, node.id as p_id, node.parent_id,
          (
            CASE 
            WHEN node.id = :id_a THEN 1
            WHEN node.parent_id IS NULL THEN 3 
            ELSE 2 END
          ) AS rn
          FROM nodes AS node
          UNION
          SELECT child.id, parent.id as p_id, parent.parent_id,
          (
            CASE 
            WHEN parent.id = :id_a THEN 1
            WHEN parent.parent_id IS NULL THEN 3 
            ELSE 2 END
          ) AS rn
          FROM parents_a AS child
          JOIN nodes AS parent ON (child.parent_id = parent.id)
        ),
        parents_b AS (
          SELECT node.id, node.id as p_id, node.parent_id,
          (
            CASE 
            WHEN node.id = :id_b THEN 1
            WHEN node.parent_id IS NULL THEN 3 
            ELSE 2 END
          ) AS rn
          FROM nodes AS node
          UNION
          SELECT child.id, parent.id as p_id, parent.parent_id,
          (
            CASE 
            WHEN parent.id = :id_b THEN 1
            WHEN parent.parent_id IS NULL THEN 3 
            ELSE 2 END
          ) AS rn
          FROM parents_b AS child
          JOIN nodes AS parent ON (child.parent_id = parent.id)
        ),
        ancestors_a AS (
          SELECT p.p_id as id, p.rn
          FROM parents_a as p
          WHERE id = :id_a
          ORDER BY p.rn
        ),
        ancestors_b AS (
          SELECT p.p_id as id, p.rn
          FROM parents_b as p
          WHERE id = :id_b
          ORDER BY p.rn
        ),
        shared AS (
          SELECT a.id, a.rn as arn, b.rn as brn
          FROM ancestors_a AS a
          JOIN ancestors_b AS b ON a.id = b.id
        )
         SELECT
        (SELECT id FROM shared ORDER BY (arn + brn) DESC LIMIT 1) as root_id,
        (SELECT id FROM shared ORDER BY (arn + brn) ASC LIMIT 1) as lowest_common_ancestor,
        COUNT(*) as depth
        FROM shared
      SQL
  end
end