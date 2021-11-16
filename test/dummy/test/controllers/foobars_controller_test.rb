require "test_helper"

class FoobarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @foobar = foobars(:one)
  end

  test "should get index" do
    get foobars_url
    assert_response :success
  end

  test "should get new" do
    get new_foobar_url
    assert_response :success
  end

  test "should create foobar" do
    assert_difference("Foobar.count") do
      post foobars_url, params: { foobar: {  } }
    end

    assert_redirected_to foobar_url(Foobar.last)
  end

  test "should show foobar" do
    get foobar_url(@foobar)
    assert_response :success
  end

  test "should get edit" do
    get edit_foobar_url(@foobar)
    assert_response :success
  end

  test "should update foobar" do
    patch foobar_url(@foobar), params: { foobar: {  } }
    assert_redirected_to foobar_url(@foobar)
  end

  test "should destroy foobar" do
    assert_difference("Foobar.count", -1) do
      delete foobar_url(@foobar)
    end

    assert_redirected_to foobars_url
  end
end
