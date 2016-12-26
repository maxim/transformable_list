require 'transformable_list/version'
require 'set'

class TransformableList
  def initialize(items, matcher: -> a, b { a == b })
    @items = items
    @matcher = matcher
  end

  def transform(new_items)
    build_remaining_items_index!

    moves = []
    creates = []
    deletes = []

    indexes_to_keep = Set.new

    new_items.each.with_index do |new_item, new_index|
      if existing_index = find_index_and_eliminate_match(new_item)
        if new_index != existing_index
          moves << [:move, @items[existing_index], new_index]
        end

        indexes_to_keep << existing_index
      else
        creates << [:create, new_item, new_index]
      end
    end

    (0...@items.size).each do |index|
      unless indexes_to_keep.include?(index)
        deletes << [:delete, @items[index], index]
      end
    end

    deletes.sort_by(&:last) + creates.sort_by(&:last) + moves.sort_by(&:last)
  end

  private

  def build_remaining_items_index!
    @remaining_items = @items.map.with_index{|item, i| [item, i]}
  end

  def find_index_and_eliminate_match(new_item)
    remaining_index =
      @remaining_items.index{|item, _| item.object_id == new_item.object_id} ||
        @remaining_items.index{|item, _| match?(item, new_item)}

    _, original_index = if remaining_index
      result = @remaining_items[remaining_index]
      @remaining_items.delete_at(remaining_index)
      result
    end

    original_index
  end

  def match?(a, b)
    @matcher.(a, b)
  end
end
