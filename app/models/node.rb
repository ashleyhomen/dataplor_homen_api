require_relative '../services/node/common_ancestors_query'

class Node < ApplicationRecord
    belongs_to :parent, class_name: "Node", optional: true
    has_many :children, class_name: "Node", foreign_key: :parent_id
    has_many :birds, dependent: :destroy

    def ancestors
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

        parents = ActiveRecord::Base.connection.execute(
            ApplicationRecord.sanitize_sql([query, {child_id: id}])
        ).map(&:values).flatten.reverse
    end

    def descendants
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

        descendants = ActiveRecord::Base.connection.execute(
            ApplicationRecord.sanitize_sql([query, {id: id}])
        ).map(&:values).flatten
    end

    def common_ancestors(node)
      return {root_id: nil, lowest_common_ancestor: nil, depth: nil} if node.nil?

      query = CommonAncestorQuery.call(id, node.id)
      result = ActiveRecord::Base.connection.execute(query).first.symbolize_keys

      result[:depth] = nil if result[:depth].zero?
      result
  end
end
