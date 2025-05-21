require 'rails_helper'
require_relative '../../app/controllers/nodes_controller.rb'
RSpec.describe NodesController, type: :request do

  before do 
    Node.find_or_create_by!(id: 100, parent_id: nil)
    Node.find_or_create_by!(id: 300, parent_id: 100)
    Node.find_or_create_by!(id: 500, parent_id: 300)
    Node.find_or_create_by!(id: 700, parent_id: 500)

    Node.find_or_create_by!(id: 200, parent_id: nil)
    Node.find_or_create_by!(id: 400, parent_id: 200)
    Node.find_or_create_by!(id: 600, parent_id: 400)
    Node.find_or_create_by!(id: 800, parent_id: 600)
  end

  describe 'GET /nodes' do
    let(:expected_response) do
      [
        {id: 100, parent_id: nil},
        {id: 200, parent_id: nil},
        {id: 300, parent_id: 100},
        {id: 400, parent_id: 200},
        {id: 500, parent_id: 300},
        {id: 600, parent_id: 400},
        {id: 700, parent_id: 500},
        {id: 800, parent_id: 600}
      ].to_json
    end
    it 'responds with ok status' do
      get nodes_path

      expect(response).to have_http_status :ok
    end

    it 'responds with nodes' do
      get nodes_path

      expect(response.body).to eq(Node.all.to_json)
    end
  end

  describe 'GET /common_ancestors' do
    let(:expected_response) do
      { root_id: 100, lowest_common_ancestor: 500, depth: 3 }.to_json
    end

    it 'responds with ok status' do
      get node_common_ancestors_path(node_id: 500, node_b_id: 700)

      expect(response).to have_http_status :ok
    end

    it 'responds with nodes' do
      get node_common_ancestors_path(node_id: 500, node_b_id: 700)

      expect(response.body).to eq(expected_response)
    end
  end
end