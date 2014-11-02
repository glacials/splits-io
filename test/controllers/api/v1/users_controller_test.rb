require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase
  test "should return 400 for no search params" do
    get :index

    assert_response 400
  end

  test "should return single users correctly" do
    user = User.create(email: "test@e.mail", password: "testpassword")
    get :show, id: user.id

    assert_response 200
    assert_equal user.id, JSON.parse(@response.body)["id"]
  end

  test "should return multiple users correctly" do
    user_1 = User.create(name: "testuser", email: "testemail", password: "testpassword")
    user_2 = User.create(name: "testuser", email: "testemail", password: "testpassword")

    get :index, name: user_1.name

    assert_response 200
    assert_equal 2, JSON.parse(@response.body).length
    assert_equal user_1.name, JSON.parse(@response.body)[0]["name"]
    assert_equal user_1.name, JSON.parse(@response.body)[1]["name"]
  end

  test "should not return users when given no search params" do
    user = User.create(email: "testemail", password: "testpassword")
    get :index

    assert_response 400
  end

  test "should not return users when given only disallowed search params" do
    user = User.create(email: "testemail", password: "testpassword")
    get :index, id: user.id

    assert_response 400
    assert_not_instance_of Array, JSON.parse(@response.body)
  end

  test "should ignore disallowed params when also given allowed params" do
    user = User.create(name: "testuser", email: "testemail", password: "testpassword")
    get :index, fake_param: "fake_value", name: user.name

    assert_response 200
    assert_equal    1,       JSON.parse(@response.body).length
    assert_equal    user.id, JSON.parse(@response.body)[0]["id"]
  end
end
