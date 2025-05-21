class Bird < ApplicationRecord
  include BirdQueries 

  belongs_to :node

  # Approach considerations:
  # 1. I prioritized minimal DB calls
  # -- Iterating over the results would require multiple calls to the DB
  # -- Loops would be slow for large datasets
  # 2. How I broke down the prolem:
  # -- 1. Get all node ancestors for multiple nodes
  # -- 2. Join birds and descendants
  def self.birds_of_node_descendants(node_ids)
    query = build_birds_of_node_descendants_query(node_ids)
    descendants = ActiveRecord::Base.connection.execute(query).map(&:values).flatten
  end
end
