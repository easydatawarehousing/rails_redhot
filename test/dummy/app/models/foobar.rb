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
        # Update items
        -> (state, action) {
          case action[:type]&.to_sym
          when :add
            if action[:item].length.between?(1, 6)
              state[:items] << { id: next_seq_id, value: CGI.escape(action[:item]) }
            else
              reduce_errors.add(:base, message: 'Item should have between 1 and 6 characters')
            end
          when :remove
            if action[:item].blank? # Only used for testing reduce_errors
              reduce_errors.add(:base, :blank)
            else
              state[:items].delete_if do |item|
                item.symbolize_keys!
                item[:id] == action[:item]
              end
            end
          end

          state
        }
      ]
    end
end
