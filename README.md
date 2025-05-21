# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
ruby-3.4.2

* System dependencies
- rspec
- pg

* Configuration

* Database creation
1. rails db:create
2. rails db:migrate
3. rails RAILS_ENV=test db:migrate

* Database initialization
1. rails db:seed
2. rails RAILS_ENV=test db:seed   

* How to run the test suite
- rspec

* Services (job queues, cache servers, search engines, etc.)
- CommonAncestorQuery
Handles the heavy lifting for building the query to evaluate common ancestors

* Deployment instructions
rails s
Visit local_host:3000

* API Instructions

Nodes 

local_host:3000/nodes
Desription: will return all nodes
=> [{
    "id": NODE_ID,
    "parent_id": NODE_ID,
    "created_at": TIMESTAMP,
    "updated_at": TIMESTAMP
  }]

local_host:3000/nodes/:id/common_ancestors?node_b_id=:id
Desription: will return the root shared node ancestor of the two given nodes with the depth of connection
=> {"root_id":<NODE_ID>,"lowest_common_ancestor":<NODE_ID>,"depth":<INTEGER>}

Birds

local_host:3000/birds
Desription: will return all birds
=> [{
    "id": BIRD_ID,
    "node_id": NODE_ID,
    "name": STRING,
    "created_at": TIMESTAMP,
    "updated_at": TIMESTAMP
}]


local_host:3000/birds?node_ids=:node_id,:node_id
Desription: will return all bird_ids associated with the given nodes and their decendance 
=> [BIRD_ID, BIRD_ID, BIRD_ID]

Files to view the primary logic of this application
Seed Data
- db/seeds.rb
Controllers
- birds_controller.rb
- nodes_controller.rb
- spec/controllers/birds_controller_spec.rb
- spec/controllers/nodes_controller_spec.rb
Models
- bird.rb
- node.rb
- spec/models/bird_spec.rb
- spec/models/node_spec.rb
Concerns
- bird_queries.rb 
- node_queries.rb