class Node < ApplicationRecord
  include NodeQueries

  belongs_to :parent, class_name: "Node", optional: true
  has_many :children, class_name: "Node", foreign_key: :parent_id
  has_many :birds, dependent: :destroy

  # This method returns all ancestors of a node as an array of ids
  def ancestors
    query = build_ancestors_query()
    ActiveRecord::Base.connection.execute(query).map(&:values).flatten
  end

  # This method returns all descendants of a node as an array of ids
  def descendants
    query = build_descendants_query()
    descendants = ActiveRecord::Base.connection.execute(query).map(&:values).flatten
  end

  # It returns a hash with the following keys: root_id, lowest_common_ancestor, depth
  def common_ancestors(node)
    return {root_id: nil, lowest_common_ancestor: nil, depth: nil} if node.nil?
    
    # This could be optomized with caching giving these considerations:
    # 1. The data is not going to change often
    # 2. Additinal depth could be added, which would change the results 
    # 3. Any change to the nodes db whould require a cache clear
    query = build_common_ancestors_query(node)

    # Approach considerations:
    # 1. I prioritized minimal DB calls
    # -- Iterating over the results would require multiple calls to the DB
    # -- Loops would be slow for large datasets
    # 2. Only load the data required for the results
    # -- The query is optimized to only return the data needed
    # 3. How I broke down the prolem:
    # -- 1. Get all node ancestors
    # -- 2. Join on common ancestors
    # -- 3. Add sorting to prevent misordered ancestor (ids may not be in order)
    #       This allowed to to find only the first and last shared ancestors
    # -- 4. Get the root and lowest ancestor and depth
    result = ActiveRecord::Base.connection.execute(query).first.symbolize_keys

    result[:depth] = nil if result[:depth].zero?
    result
  end
end
