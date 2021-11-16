class Foobar < ApplicationRecord

  acts_as_redux :my_redux

  private

    def my_redux_reducers
      @my_redux_reducers ||= [
        # Initialize the store if needed
        ->(state, _action) {
          state[:total]   ||= 0
          state[:items]   ||= []
          state
        },
        # Update total
        ->(state, action) {
          case action[:type]&.to_sym
          when :add
            state[:total] += 1
          when :remove
            state[:total] -= 1
          end
          state
        },
        # Update item list
        -> (state, action) {
          case action[:type]&.to_sym
          when :add
            state[:items] << { id: next_seq_id, value: action[:item] }
          when :remove
            state[:items].delete_if do |item|
              item.symbolize_keys!
              item[:id] == action[:item]
            end
          end
          state
        }
      ]
    end
end
