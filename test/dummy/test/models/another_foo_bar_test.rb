require "test_helper"

class FooBarTestTest < ActiveSupport::TestCase

  setup do
    @another_foobar = another_foo_bars(:another_foo_bar_new)
  end

  test "can run after_dispatch method" do
    assert @another_foobar.dispatch!({ item: "Bar" })
    assert_equal @another_foobar.view_state[:items].last[:color], 'red'
    assert @another_foobar.dispatch!({ item: "Bar" })
    assert_equal @another_foobar.view_state[:items].last[:color], 'green'
  end

  test "can run after_dispatch after undo" do
    assert @another_foobar.undo!
    assert_equal @another_foobar.view_state[:items].last[:color], 'red'
    assert @another_foobar.undo!
    assert @another_foobar.view_state[:items].blank?
  end

  test "can run after_dispatch after redo" do
    assert @another_foobar.redo!
    assert_equal @another_foobar.view_state[:items].last[:color], 'red'
  end
end
