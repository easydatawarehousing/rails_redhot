class AnotherFooBar < ApplicationRecord

  acts_as_redux :another_redux_store,
    reducers:     :my_redux_reducers,
    after_change: :my_after_change_actions

  private

    def my_redux_reducers
      [
        # Initialize the store if needed
        -> (state, _action) {
          state[:items] ||= []
          state
        },
        # Add item
        -> (state, action) {
          state[:items] << { id: next_seq_id, value: CGI.escape(action[:item]), color: '' }
          state
        }
      ]
    end

    def my_after_change_actions
      if view_state[:items].length.odd?
        view_state[:items].each { |item| item[:color] = 'red' }
      else
        view_state[:items].each { |item| item[:color] = 'green' }
      end
    end
end
