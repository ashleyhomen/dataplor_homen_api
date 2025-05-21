# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization
1. rails db:create
2. rails db:migrate
3. rails db:seed
4. rails RAILS_ENV=test db:migrate
5. rails RAILS_ENV=test db:seed   

* How to run the test suite
- rspec

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
rails s
Visit local_host:3000

* API Instructions

Nodes 

local_host:3000/nodes
Desription: will return all nodes
-> [{
    "id": NODE_ID,
    "parent_id": NODE_ID,
    "created_at": TIMESTAMP,
    "updated_at": TIMESTAMP
  }]

local_host:3000/nodes/:id/common_ancestors?node_b_id=:id
Desription: will return the root shared node ancestor of the two given nodes with the depth of connection
-> {"root_id":<NODE_ID>,"lowest_common_ancestor":<NODE_ID>,"depth":<INTEGER>}

Birds

local_host:3000/birds
Desription: will return all birds
-> [{
    "id": BIRD_ID,
    "node_id": NODE_ID,
    "name": STRING,
    "created_at": TIMESTAMP,
    "updated_at": TIMESTAMP
}]


local_host:3000/birds?node_ids=:node_id,:node_id
Desription: will return all bird_ids associated with the given nodes and their decendance 
-> [BIRD_ID, BIRD_ID, BIRD_ID]