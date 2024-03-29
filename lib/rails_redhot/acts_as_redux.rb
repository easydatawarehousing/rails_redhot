# frozen_string_literal: true

module RailsRedhot
  # Include ActAsRedux module to add redux functionality to Rails
  module ActsAsRedux
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_redux(store_name, options = {})
        reducers = options.key?(:reducers) ? options[:reducers] : "#{store_name}_reducers".to_sym
        reducer_errors = nil
        reducer_after_change = options[:after_change]

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
              self.send(reducer_after_change) if reducer_after_change
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
            self.send(reducer_after_change) if reducer_after_change
            true
          else
            false
          end
        end

        define_method('flatten!') do
          self.initial_state = view_state
          self.state         = nil
          self.head          = -1
          self.actions       = []
          true
        end

        define_method('reduce_errors') do
          reducer_errors
        end

        define_method('reduce_valid?') do
          reducer_errors.details.empty?
        end

        define_method('next_seq_id') do
          self.seq_id += 1
        end

        define_method('dispatch!') do |action|
          # Destroy any redo actions
          self.actions.slice!(head + 1, actions.length - head - 1) if redo?

          self.actions << action
          self.head += 1
          perform_reduce(action.deep_dup.deep_symbolize_keys)
          self.send(reducer_after_change) if reducer_after_change
          reduce_valid?
        end

        # private

          define_method('reset_reduce_errors') do
            reducer_errors = ActiveModel::Errors.new(self)
          end

          define_method('load_store') do
            self.initial_state ||= {}
            # self.state is initially nil: no need to store state twice when there are no actions
            self.head          ||= -1
            self.actions       ||= []
            self.seq_id        ||= 0

            if state.blank? && initial_state.blank?
              perform_reduce({})
            else
              reset_reduce_errors
            end
          end

          define_method('all_reducers') do
            send(reducers)
          end

          define_method('perform_reduce') do |action|
            reset_reduce_errors

            self.state = all_reducers.reduce(
              view_state.deep_dup.deep_symbolize_keys
            ) do |current_state, reducer|
              reducer.call(current_state, action)
            end
          end

          private :load_store, :all_reducers, :perform_reduce,
                  :initial_state,  :state,  :actions,  :head,
                  :initial_state=, :state=, :actions=, :head=, :seq_id=
      end
    end
  end
end
