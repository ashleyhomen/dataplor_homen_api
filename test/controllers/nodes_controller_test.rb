require "test_helper"

class NodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @node = nodes(:one)
  end

  test "should get index" do
    get nodes_url, as: :json
    assert_response :success
  end

  test "should create node" do
    assert_difference("Node.count") do
      post nodes_url, params: { node: { parent_id: @node.parent_id } }, as: :json
    end

    assert_response :created
  end

  test "should show node" do
    get node_url(@node), as: :json
    assert_response :success
  end

  test "should update node" do
    patch node_url(@node), params: { node: { parent_id: @node.parent_id } }, as: :json
    assert_response :success
  end

  test "should destroy node" do
    assert_difference("Node.count", -1) do
      delete node_url(@node), as: :json
    end

    assert_response :no_content
  end
end
