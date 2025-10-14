require "test_helper"

class DogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dogs_url
    assert_response :success
  end

  test "should get show" do
    dog = dogs(:one)
    get dog_url(dog)
    assert_response :success
  end

  test "should get new" do
    get new_dog_url
    assert_response :success
  end

  test "should get create" do
    owner = users(:one)
    post dogs_url, params: { dog: { name: "Test Dog", breed: "Labrador", age: 3, weight: "50", owner_id: owner.id } }
    assert_response :redirect
  end

  test "should get edit" do
    dog = dogs(:one)
    get edit_dog_url(dog)
    assert_response :success
  end

  test "should get update" do
    dog = dogs(:one)
    patch dog_url(dog), params: { dog: { name: "Updated Dog" } }
    assert_response :redirect
  end

  test "should get destroy" do
    dog = dogs(:one)
    delete dog_url(dog)
    assert_response :redirect
  end
end
