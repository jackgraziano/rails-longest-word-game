require 'test_helper'

class GameControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get game" do
    get game_controller_game_url
    assert_response :success
  end

  test "should get score" do
    get game_controller_score_url
    assert_response :success
  end

end
