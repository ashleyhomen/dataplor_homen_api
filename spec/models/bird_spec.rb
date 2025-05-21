require 'rails_helper'
require_relative '../../app/models/bird.rb'
require 'byebug'

RSpec.describe Bird do 
  context 'birds_of_node_descendants' do
    let(:node600) { Bird.where(node_id: [600,800,1200,1600]).ids }
    let(:node700) { Bird.where(node_id: [700,900,1400,1800]).ids }
    let(:expected) do
      (node600 + node700).sort
    end

    it 'returns the correct common birds associated with given nodes and decendance' do
      expect(Bird.birds_of_node_descendants([600,700])).to eq(expected)
    end
  end
end