# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
# 125     |       130
# 130     |          
# 2820230 |       125
# 4430546 |       125
# 5497637 |   4430546

nodes = [
    { id: 125, parent_id: 130 },         # 130
    { id: 130, parent_id: nil },         # 130
    { id: 2820230, parent_id: 125 },     # 125 130
    { id: 4430546, parent_id: 125 },     # 125 130
    { id: 5497637, parent_id: 4430546 }, # 4430546 125 130

    { id: 100, parent_id: nil },  # 100
    # 300 500 700 900 1000 1100 1400 1500 1800 1900
    { id: 200, parent_id: nil },  # 200
    # 400 600 800 1200 1300 1600 1700
    { id: 300, parent_id: 100 },  # 100
    { id: 400, parent_id: 200 },  # 200
    { id: 500, parent_id: 300 },  # 300 100
    { id: 600, parent_id: 400 },  # 400 200
    { id: 700, parent_id: 500 },  # 500 300 100
    { id: 800, parent_id: 600 },  # 600 400 200
    { id: 900, parent_id: 700 },  # 700 500 300 100
    { id: 1000, parent_id: 500 }, # 500 300 100
    { id: 1100, parent_id: 100 }, # 100
    { id: 1200, parent_id: 600 }, # 600 400 200
    { id: 1300, parent_id: 200 }, # 200
    { id: 1400, parent_id: 700 }, # 700 500 300 100
    { id: 1500, parent_id: 300 }, # 300 100
    { id: 1600, parent_id: 800 }, # 800 600 400 200
    { id: 1700, parent_id: 400 }, # 400 200
    { id: 1800, parent_id: 900 }, # 900 700 500 300 100
    { id: 1900, parent_id: 500 }, # 500 300 100
]

birds = [
    ["Red-bellied Woodpecker", "Downy Woodpecker", "Pileated Woodpecker", "Hairy Woodpecker"],
    ["Black-capped Chickadee"],
    ["White-breasted Nuthatch", "Red-breasted Nuthatch"],
    ["Pine Siskin"],
    ["House Sparrow", "American Tree Sparrow"],
    ["Blue Jay"],
    ["American Goldfinch", "Purple Finch", "House Finch"],
    ["Mourning Dove"],
    ["Common Redpoll", "Hoary Redpoll"],
    ["Dark-eyed Junco"],
    ["American Crow", "Common Raven"],
    ["Northern Flicker"],
    ["Northern Cardinal", "Brown Creeper"],
    ["American Robin"],
    ["Pine Grosbeak", "Evening Grosbeak"],
    ["European Starling"],
    ["Black-billed Magpie", "Yellow-billed Magpie"],
    ["American Kestrel"],
    ["Barn Owl", "Eastern Screech Owl", "Great Horned Owl"],
    ["Merlin"],
    ["Barn Swallow", "Tree Swallow", "Northern Rough-winged Swallow"],
    ["Peregrine Falcon"],
    ["Common Grackle", "Boat-tailed Grackle"],
    ["Mallard Duck aka Pally Mally"],
]

nodes.each_with_index do |node, i|
    parent = Node.find_or_create_by!(id: node[:id], parent_id: node[:parent_id])
    birds[i].each do |bird|
        Bird.find_or_create_by!(name: bird, node_id: parent.id)
    end
end

# Create 100 nodes with parent-child relationships
99.times do |i|
    parent_id = i.zero? ? nil : i
    Node.find_or_create_by!(id: i + 1, parent_id: parent_id)
end
# Create a single that skips to the middle
Node.find_or_create_by!(id: 102, parent_id: 88)

# Circular nodes
Node.find_or_create_by!(id: 202, parent_id: 206)
Node.find_or_create_by!(id: 203, parent_id: 202)
Node.find_or_create_by!(id: 204, parent_id: 203)
Node.find_or_create_by!(id: 205, parent_id: 204)
Node.find_or_create_by!(id: 206, parent_id: 202)
