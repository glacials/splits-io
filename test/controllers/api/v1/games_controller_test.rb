require 'test_helper'

class Api::V1::GamesControllerTest < ActionController::TestCase
  test "should return 400 for no search params" do
    get :index

    assert_response 400
  end

  test "should return games correctly" do
    game = Game.create
    get :show, id: game.id

    assert_response 200
    assert_equal game.id, JSON.parse(@response.body)["id"]
  end

  test "should not filter by disallowed params" do
    game = Game.create
    get :index, id: game.id

    assert_response 400
  end

  test "should filter mixed params correctly" do
    hidden_game = Game.create
    visible_game = Game.create(shortname: 'visible')
    get :index, id: hidden_game.id, shortname: visible_game.shortname

    assert_response  200
    assert_equal     1,               JSON.parse(@response.body).length
    assert_equal     visible_game.id, JSON.parse(@response.body)[0]
    assert_not_equal hidden_game.id,  JSON.parse(@response.body)[0]
  end
end
