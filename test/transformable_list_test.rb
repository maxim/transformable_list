require 'test_helper'

class TransformableListTest < Minitest::Test
  def setup
    @item1 = Struct.new(:title).new('foo')
    @item2 = Struct.new(:title).new('foo')
    @item3 = Struct.new(:title).new('bar')

    @transformable_list = TransformableList.new([@item1, @item2, @item3],
      matcher: -> a, b { a.title == b.title }
    )
  end

  def test_returns_no_changes_when_all_items_match
    new_item1 = Struct.new(:title).new('foo')
    new_item2 = Struct.new(:title).new('foo')
    new_item3 = Struct.new(:title).new('bar')

    assert_equal [],
      @transformable_list.transform([new_item1, new_item2, new_item3])
  end

  def test_detects_delete_for_one_item
    new_item1 = Struct.new(:title).new('foo')
    new_item2 = Struct.new(:title).new('bar')

    assert_equal [
      [:delete, @item2, 1],
      [:move, @item3, 1]
    ], @transformable_list.transform([new_item1, new_item2])
  end

  def test_detects_rearranged_items
    assert_equal [
      [:move, @item3, 0],
      [:move, @item1, 1],
      [:move, @item2, 2]
    ], @transformable_list.transform([@item3, @item1, @item2])
  end

  def test_detects_create_move_and_delete
    new_item1 = Struct.new(:title).new('baz')

    assert_equal [
      [:delete, @item1, 0],
      [:create, new_item1, 0],
      [:move, @item3, 1],
      [:move, @item2, 2]
    ], @transformable_list.transform([new_item1, @item3, @item2])
  end

  def test_detects_adding_more_of_the_same
    assert_equal [
      [:create, @item1, 3],
      [:create, @item1, 4],
    ], @transformable_list.transform([@item1, @item2, @item3, @item1, @item1])
  end
end
