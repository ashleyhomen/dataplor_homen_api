module NodeQueries
  extend ActiveSupport::Concern

  included do

    # Query Breakdown
    # Strep 1.
    #   `parents` recursively finds all associations with node
    # Strep 2.
    #    The final select finds all nodes that are parents of the node
    def build_ancestors_query
      query = <<-SQL
        WITH RECURSIVE parents AS (
            SELECT node.id, node.id as p_id, node.parent_id
            FROM nodes AS node
            UNION
            SELECT child.id, parent.id as p_id, parent.parent_id
            FROM parents AS child
            JOIN nodes AS parent ON (child.parent_id = parent.id)
        )
        SELECT p.p_id
        FROM parents as p
        WHERE id = :child_id
      SQL

      ApplicationRecord.sanitize_sql([query, {child_id: id}])
    end

    # Query Breakdown
    # Strep 1.
    #   `descendant` recursively finds all associations with node
    # Strep 2.
    #    The final select finds all nodes that are descendants of the node
    def build_descendants_query
      query = <<-SQL
        WITH RECURSIVE descendant AS (
          SELECT node.id, node.parent_id
          FROM nodes AS node
          WHERE id = :id
          UNION ALL
          SELECT  ft.id, ft.parent_id
          FROM nodes AS ft
          JOIN descendant AS d ON ft.parent_id = d.id
        )
        SELECT  DISTINCT d.id AS id
        FROM descendant AS d
        JOIN nodes AS a ON d.parent_id = a.id OR a.id = d.id
      SQL
  
      ApplicationRecord.sanitize_sql([query, {id: id}])
    end

    # Query Breakdown
    # Strep 1.
    #   `parents_a` & `ancestors_b` 
    #   recursively finds all associations with node A or B
    #   Case statement add placement identity by first, last, or middle
    # Strep 2.
    #   `ancestors_a` & `ancestors_b`
    #    finds all ancestors of node via parents_a & parents_b
    # Step 3.
    #   `shared`
    #   finds all common ancestors between A and B
    # Step 4.
    #   The final select statement retrieves only first, last and count from the shared table
    def build_common_ancestors_query(b_node_id)
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

      ApplicationRecord.sanitize_sql([query, {id_a: id, id_b: b_node_id}])
    end

  end
end