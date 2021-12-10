# frozen_string_literal: true

module RailsRedhot
  # Include ActAsRedux module to add redux functionality to Rails
  module ActsAsRedux
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_redux(store_name, options = {})
        reducers = options.key?(:reducers) ? options[:reducers] : "#{store_name}_reducers".to_sym

        store(store_name, accessors: [ :initial_state, :state, :actions, :head, :seq_id ], coder: JSON)

        after_initialize :load_store

        define_method('view_state') do
          state || initial_state || {}
        end

        define_method('undo?') do
          head > -1
        end

        define_method('redo?') do
          (head + 1) < actions.length
        end

        define_method('flatten?') do
          undo?
        end

        define_method('undo_action') do
          undo? ? actions[head] : nil
        end

        define_method('redo_action') do
          redo? ? actions[head + 1] : nil
        end

        define_method('undo!') do
          if undo?
            self.head -= 1
            self.state = initial_state
            if head > -1
              actions[0..head].each { |action| perform_reduce(action) }
            else
              perform_reduce(initial_state)
            end
            true
          else
            false
          end
        end

        define_method('redo!') do
          if redo?
            self.head += 1
            perform_reduce(actions[head])
            true
          else
            false
          end
        end

        define_method('flatten!') do
          self.initial_state = state
          self.state         = nil
          self.head          = -1
          self.actions       = []
          true
        end

        define_method('next_seq_id') do
          self.seq_id += 1
        end

        define_method('dispatch!') do |action|
          # Destroy any redo actions
          self.actions.slice!(head + 1, actions.length - head - 1) if redo?

          self.actions << action
          self.head += 1
          perform_reduce(action)
          true
        end

        # private

          define_method('load_store') do
            self.initial_state ||= {}
            # self.state is initially nil: no need to store state twice when there are no actions
            self.head          ||= -1
            self.actions       ||= []
            self.seq_id        ||= 0
            perform_reduce({}) if state.blank? && initial_state.blank?
          end

          define_method('all_reducers') do
            send(reducers)
          end

          define_method('perform_reduce') do |action|
            self.state = all_reducers.reduce(
              view_state.dup.deep_symbolize_keys
            ) do |current_state, reducer|
              reducer.call(current_state, action.deep_symbolize_keys)
            end
          end

          private :load_store, :all_reducers, :perform_reduce,
                  :initial_state,  :state,  :actions,  :head,
                  :initial_state=, :state=, :actions=, :head=, :seq_id=
      end
    end
  end
end
