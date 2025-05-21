class Bird < ApplicationRecord
  include BirdQueries 

  belongs_to :node

  def self.birds_of_node_descendants(node_ids)
    query = build_birds_of_node_descendants_query(node_ids)
    descendants = ActiveRecord::Base.connection.execute(query).map(&:values).flatten
  end
end
