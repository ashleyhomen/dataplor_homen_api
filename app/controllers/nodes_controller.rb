class NodesController < ApplicationController

  # GET /nodes
  def index
    @nodes = Node.all

    render json: @nodes
  end

  def common_ancestors
    @node_a = Node.find(params[:node_id])
    @node_b = Node.find(params[:node_b_id])
    @common_ancestors = @node_a.common_ancestors(@node_b)
    render json: @common_ancestors
  end

  def bird_params
    params.expect(node: [ :node_id, :node_b_id ])
  end
end
