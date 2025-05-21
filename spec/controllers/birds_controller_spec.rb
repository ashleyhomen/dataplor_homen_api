require 'rails_helper'
require_relative '../../app/controllers/birds_controller.rb'
RSpec.describe BirdsController, type: :request do

  before do 
    Node.find_or_create_by!(id: 100, parent_id: nil)
    Node.find_or_create_by!(id: 300, parent_id: 100)
    Node.find_or_create_by!(id: 500, parent_id: 300)
    Node.find_or_create_by!(id: 700, parent_id: 500)

    Node.find_or_create_by!(id: 200, parent_id: nil)
    Node.find_or_create_by!(id: 400, parent_id: 200)
    Node.find_or_create_by!(id: 600, parent_id: 400)
    Node.find_or_create_by!(id: 800, parent_id: 600)

    Bird.find_or_create_by!(id: 11, node_id: 100)
    Bird.find_or_create_by!(id: 15, node_id: 300)
    Bird.find_or_create_by!(id: 18, node_id: 500)
    Bird.find_or_create_by!(id: 21, node_id: 700)
  end

  describe 'GET /birds' do
    it 'responds with ok status' do
      get birds_path

      expect(response).to have_http_status :ok
    end

    it 'responds with birds' do
      get birds_path

      expect(response.body).to eq(Bird.all.to_json)
    end
  end

  describe 'GET /birds/ with node params' do
    let(:expected_response) do
      {id: 500, parent_id: 300}.to_json
    end
    it 'responds with ok status' do
      get "/birds?node_ids=300,700"

      expect(response).to have_http_status :ok
    end

    it 'responds with birds' do
      get "/birds?node_ids=300,700"

      expected = Bird.where(node_id: [300,500,700,900,1000,1400,1500,1800,1900]).ids

      expect(response.body).to eq(expected.to_json)
    end
  end
end