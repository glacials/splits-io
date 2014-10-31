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

  test "should filter disallowed params correctly" do
    game_1 = Game.create(shortname: "game_1")
    game_2 = Game.create(shortname: "game_2")
    get :index, id: game_1.id, shortname: game_2.shortname

    assert_response  200
    assert_equal     1,         JSON.parse(@response.body).length
    assert_not_equal game_1.id, JSON.parse(@response.body)[0]["id"]
    assert_equal     game_2.id, JSON.parse(@response.body)[0]["id"]
  end
end
