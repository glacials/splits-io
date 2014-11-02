require 'test_helper'

class Api::V1::CategoriesControllerTest < ActionController::TestCase
  test "should return 400 for no search params" do
    get :index

    assert_response 400
  end

  test "should return categories correctly" do
    category = Category.create

    get :show, id: category.id

    assert_response 200
    assert_equal category.id, JSON.parse(@response.body)["id"]
  end

  test "should not filter by disallowed params" do
    category = Category.create

    get :index, id: category.id

    assert_response 400
  end

  test "should filter disallowed params correctly" do
    category_1 = Game.create.categories.create
    category_2 = Game.create.categories.create

    get :index, id: category_1.id, game_id: category_2.game.id

    assert_response  200
    assert_equal     1,             JSON.parse(@response.body).length
    assert_not_equal category_1.id, JSON.parse(@response.body)[0]["id"]
    assert_equal     category_2.id, JSON.parse(@response.body)[0]["id"]
  end
end
