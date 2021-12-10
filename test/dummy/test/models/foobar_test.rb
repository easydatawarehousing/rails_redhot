require "test_helper"

class FoobarNewTest < ActiveSupport::TestCase
  setup do
    @foobar = foobars(:foobar_new)
  end

  test "should have a view_state" do
    assert @foobar.view_state.present?
    assert @foobar.view_state.key?("total")
    assert_equal @foobar.view_state["total"], 0
    assert @foobar.view_state.key?("items")
    assert_equal @foobar.view_state["items"], []
  end


  test "has nothing to undo" do
    assert !@foobar.undo?
  end

  test "has no undo action" do
    assert_nil @foobar.undo_action
  end

  test "can't undo" do
    assert !@foobar.undo!
  end


  test "has nothing to redo" do
    assert !@foobar.redo?
  end

  test "has no redo action" do
    assert_nil @foobar.redo_action
  end

  test "can't redo" do
    assert !@foobar.redo!
  end


  test "has nothing to flatten" do
    assert !@foobar.flatten?
  end

  test "can flatten" do
    assert @foobar.flatten!
  end


  test "can get the next sequence id" do
    assert_equal @foobar.seq_id, 0
    assert_equal @foobar.next_seq_id, 1
  end


  test "can dispatch an action" do
    assert @foobar.dispatch!({ type: "add", item: "Foo" })
    @foobar.save! # Make all keys strings
    assert_equal @foobar.my_redux["head"], 0
    assert_equal @foobar.my_redux["actions"].length, 1
    assert_equal @foobar.my_redux["actions"].first["type"], "add"
    assert_equal @foobar.my_redux["actions"].first["item"], "Foo"
    assert_equal @foobar.my_redux["seq_id"], 1
  end
end

class FoobarStateTest < ActiveSupport::TestCase
  setup do
    @foobar = foobars(:foobar_state)
  end

  test "should have a view_state" do
    assert @foobar.view_state.present?
    assert @foobar.view_state.key?("total")
    assert_equal @foobar.view_state["total"], 2
    assert @foobar.view_state.key?("items")
    assert_equal @foobar.view_state["items"].length, 2
  end


  test "has something to undo" do
    assert @foobar.undo?
  end

  test "has an undo action" do
    assert_equal @foobar.undo_action["type"], "add"
  end

  test "can undo" do
    assert @foobar.undo!
    @foobar.save! # Make all keys strings
    assert_equal @foobar.my_redux["head"], 0
    assert_equal @foobar.my_redux["actions"].length, 3
  end


  test "has something to redo" do
    assert @foobar.redo?
  end

  test "has a redo action" do
    assert_equal @foobar.redo_action["type"], "add"
  end

  test "can redo" do
    assert @foobar.redo!
    @foobar.save! # Make all keys strings
    assert_equal @foobar.my_redux["head"], 2
    assert_equal @foobar.my_redux["actions"].length, 3
    assert_equal @foobar.my_redux["actions"].last["type"], "add"
    assert_equal @foobar.my_redux["actions"].last["item"], "Custom"
    assert_equal @foobar.my_redux["seq_id"], 4
  end


  test "has something to flatten" do
    assert @foobar.flatten?
  end

  test "can flatten" do
    assert @foobar.flatten!
    @foobar.save! # Make all keys strings
    assert_equal @foobar.my_redux["head"], -1
    assert_equal @foobar.my_redux["actions"].length, 0
    assert_equal @foobar.my_redux["initial_state"]["items"].length, 2
  end


  test "can get the next sequence id" do
    assert_equal @foobar.seq_id, 3
    assert_equal @foobar.next_seq_id, 4
  end


  test "can dispatch an action" do
    assert @foobar.dispatch!({ type: "add", item: "Foo" })
    @foobar.save! # Make all keys strings
    assert_equal @foobar.my_redux["head"], 2
    assert_equal @foobar.my_redux["actions"].length, 3
    assert_equal @foobar.my_redux["actions"].last["type"], "add"
    assert_equal @foobar.my_redux["actions"].last["item"], "Foo"
    assert_equal @foobar.my_redux["seq_id"], 4

    assert_equal @foobar.view_state["total"], 3
    assert_equal @foobar.view_state["items"].length, 3
  end

  test "can dispatch an action after redo" do
    assert @foobar.redo!
    assert @foobar.dispatch!({ type: "add", item: "Foo" })
    @foobar.save! # Make all keys strings
    assert_equal @foobar.my_redux["head"], 3
    assert_equal @foobar.my_redux["actions"].length, 4
    assert_equal @foobar.my_redux["actions"].last["type"], "add"
    assert_equal @foobar.my_redux["actions"].last["item"], "Foo"
    assert_equal @foobar.my_redux["seq_id"], 5
  end
end
