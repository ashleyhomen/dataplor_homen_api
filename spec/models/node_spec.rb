require 'rails_helper'
require_relative '../../app/models/node.rb'
require 'byebug'

RSpec.describe Node do 
    context 'with valid matches' do
        let(:expected) do
            [
                {a: 5497637, b: 2820230, result: {root_id: 130, lowest_common_ancestor: 125, depth: 2}},
                {a: 5497637, b: 130, result: {root_id: 130, lowest_common_ancestor: 130, depth: 1}},
                {a: 5497637, b: 4430546, result: {root_id: 130, lowest_common_ancestor: 4430546, depth: 3}},
                {a: 1800, b: 500, result: {root_id: 100, lowest_common_ancestor: 500, depth: 3}},
            ]
        end

        it 'returns the correct common ancestors with depth' do
            expected.each do |entry|
                a = Node.find(entry[:a])
                b = Node.find(entry[:b]);
                
                expect(a.common_ancestors(b)).to eq(entry[:result])
            end
        end
    end

    context 'with opposite matches' do
        let(:expected) do
            [
                {a: 2820230, b: 5497637, result: {root_id: 130, lowest_common_ancestor: 125, depth: 2}},
                {a: 130, b: 5497637, result: {root_id: 130, lowest_common_ancestor: 130, depth: 1}},
                {a: 4430546, b: 5497637, result: {root_id: 130, lowest_common_ancestor: 4430546, depth: 3}},
                {a: 500, b: 1800, result: {root_id: 100, lowest_common_ancestor: 500, depth: 3}},
            ]
        end

        it 'returns the correct common ancestors with depth' do
            expected.each do |entry|
                a = Node.find(entry[:a])
                b = Node.find(entry[:b]);
                
                expect(a.common_ancestors(b)).to eq(entry[:result])
            end
        end
    end

    context 'with no matches' do
        let(:a) { a = Node.find(1800) } # odd ancestors
        let(:b) { b = Node.find(1600) } # even ancestors

        it 'returns the nil values' do
            expect(a.common_ancestors(b)).to eq({root_id: nil, lowest_common_ancestor: nil, depth: nil})
        end
    end

    context 'with self match' do
        let(:a) { a = Node.find(4430546) }
        let(:b) { b = Node.find(4430546) }

        it 'returns the ancestors on self with depth' do
            expect(a.common_ancestors(b)).to eq({root_id: 130, lowest_common_ancestor: 4430546, depth: 3})
        end
    end

    context 'Handles indexing for large sets' do
        let(:a) { a = Node.find(102) }
        let(:b) { b = Node.find(99) }

        it 'returns the ancestors on self with depth' do
            expect(a.common_ancestors(b)).to eq({root_id: 1, lowest_common_ancestor: 88, depth: 88})
        end
    end

    context 'Handles nil value' do
        let(:a) { a = Node.find(500) }

        it 'returns the ancestors on self with depth' do
            expect(a.common_ancestors(nil)).to eq({root_id: nil, lowest_common_ancestor: nil, depth: nil})
        end
    end

    context 'Handles nil parent value' do
        let(:a) { a = Node.find(200) }
        let(:b) { b = Node.find(100) }

        it 'returns the ancestors on self with depth' do
            expect(a.common_ancestors(b)).to eq({root_id: nil, lowest_common_ancestor: nil, depth: nil})
        end
    end

    context 'Handles direct child' do
        let(:a) { a = Node.find(400) }
        let(:b) { b = Node.find(200) }

        it 'returns the ancestors on self with depth' do
            expect(a.common_ancestors(b)).to eq({root_id: 200, lowest_common_ancestor: 200, depth: 1})
        end
    end

    context 'Handles infinate loop' do
        let(:a) { a = Node.find(203) }
        let(:b) { b = Node.find(206) }

        it 'returns the ancestors on self with depth' do
            expect(a.common_ancestors(b)).to eq({root_id: 202, lowest_common_ancestor: 206, depth: 2})
        end
    end
end