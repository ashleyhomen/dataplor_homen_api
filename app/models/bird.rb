class Bird < ApplicationRecord
    belongs_to :node

    def self.birds_of_node_descendants(node_ids)
        query = <<-SQL
        WITH RECURSIVE descendants AS (
            SELECT node.id, node.parent_id
            FROM nodes AS node
            WHERE id in (:parent_ids)
            UNION ALL
            SELECT  ft.id, ft.parent_id
            FROM nodes AS ft
            JOIN descendants AS d ON ft.parent_id = d.id
        ),
        parents AS (
            SELECT node.id, node.parent_id
            FROM nodes AS node
            WHERE id in (:parent_ids)
        )
        SELECT DISTINCT b.id AS id
        FROM birds AS b
        JOIN descendants AS d ON d.id = b.node_id
        JOIN nodes AS a ON d.parent_id = a.id OR a.id = d.id
        ORDER BY b.id
        SQL

        sql = ApplicationRecord.sanitize_sql_array([query, {parent_ids: node_ids}])

        descendants = ActiveRecord::Base.connection.execute(sql).map(&:values).flatten
    end
end
