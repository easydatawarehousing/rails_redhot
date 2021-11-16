# RailsRedhot
__REDux pattern for HOTwire == Redhot__  
This is a proof of concept that shows how html-over-the-wire combined with the
redux (flux) pattern radically reduces complexity of software architecture.
Applications using (react) redux, especially when combined with
command-query-responsibility-separation (CQRS) can become very complex
([example](https://medium.com/resolvejs/resolve-redux-backend-ebcfc79bbbea)).

This gem assists in reducing the number of required components down to just four:

1. Views, normal rails views rendering the current state and delivered as turbo streams
2. Actions, just (submit) buttons that send a request to the backend
3. Store, keeping the list of actions and current state, managed by this gem and stored
   in an activerecord model
4. Reducers, a set of functions (provided by you) that translate actions to changes in state

Common actions (undo, redo, flatten actions to initial state) are provided by this gem.
Combined with turbo streams these make it easy to create a smooth user experience where
you save/undo/redo every user interaction.

## Usage
Create a migration to add a 'text' attribute to a model that should have a redux store.
In the model add an `acts_as_redux` line, specifying the name of the text attribute.
Add a private method holding all your reducer functions.
See [this example](test/dummy/app/models/foobar.rb).
Note that all reducer functions must return the state object (a Hash).

```ruby
include RailsRedhot::ActsAsRedux

acts_as_redux :my_redux

def my_redux_reducers
->(state, action) {
  case action[:type]
  when :add
    state[:total] += 1
  when :remove
    state[:total] -= 1
  end
  state
},
end
```

Or specify your own reducer method:

```ruby
acts_as_redux :my_redux, reducers: :list_of_reducers

def list_of_reducers
# ...
```

In your views add some submit buttons for adding and undoing actions.
See [this example](test/dummy/app/views/foobars/_editor.html.erb).
And let your controller ([example](test/dummy/app/controllers/foobars_controller.rb))
process these actions.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "rails_redhot"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rails_redhot
```

## Demo application
To use the demo application:

```bash
cd test/dummy
rails db:setup
rails server
```

Open the [application](http://localhost:3000/foobars).
Click on 'New foobar' 'Add a new foobar' and 'Edit this foobar'.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Remarks

- Developed using Ruby 3.0.2
- This gem is not designed to handle very large lists of actions and state.
  When calling `undo` the state is rebuilt from scratch.
  If the list of actions to process is large this would become slow.
  One would need 'savepoints' that regularly save the state so that the
  current state could be rebuilt from that point.
- No checking on the size of the text attribute is done
- There is no testset yet
- There is no documentation yet
- Currently only one redux store can be added to a model
- Redux store code inspired by:
  - https://gist.github.com/eadz/31c87375722397be861a0dbcf7fb7408
  - https://github.com/janlelis/redux.rb
