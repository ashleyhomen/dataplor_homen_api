require "test_helper"

class BirdsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bird = birds(:one)
  end

  test "should get index" do
    get birds_url, as: :json
    assert_response :success
  end

  test "should create bird" do
    assert_difference("Bird.count") do
      post birds_url, params: { bird: { node_id: @bird.node_id } }, as: :json
    end

    assert_response :created
  end

  test "should show bird" do
    get bird_url(@bird), as: :json
    assert_response :success
  end

  test "should update bird" do
    patch bird_url(@bird), params: { bird: { node_id: @bird.node_id } }, as: :json
    assert_response :success
  end

  test "should destroy bird" do
    assert_difference("Bird.count", -1) do
      delete bird_url(@bird), as: :json
    end

    assert_response :no_content
  end
end
