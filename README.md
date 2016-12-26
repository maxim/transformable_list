# TransformableList

Need to transform one list into another without wreaking too much havoc? Just follow the steps.

```
>> TransformableList.new(%w(c a x b)).transform(%w(a b c d e))
=> [
     [:delete, "x", 2],
     [:create, "d", 3],
     [:create, "e", 4],
     [:move, "a", 0],
     [:move, "b", 1],
     [:move, "c", 2]
   ]
```

Each step is `[action, item, index]` where action can be

- delete
- create
- move

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'transformable_list'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transformable_list

## Matcher

You can change what items are considered equal by supplying a matcher.

```ruby
TransformableList.new(%(a foo), matcher: -> a, b { a.size == b.size })
```

The default is `-> a, b { a == b }`.

## Use case

A use case for this gem could be an ActiveRecord has_many association that maintains a sequential index field. Let's say you have a voting system, and a user would assign all the choices by assigning an array. When you are updating existing choices into new ones, you want to keep most of them intact. You can then use logic like this:

```ruby
original_list = TransformableList.new(choices, matcher: -> a, b { a['text'] == b['text'] })
steps = original_list.transform(new_list)

steps.each do |step|
  action, item, index = step

  case action
  when :delete then item.destroy
  when :create then choices.create(text: item['text'], index: index)
  when :move then item.update_attribute(:index, index)
  end
end
```

## Algorithm efficiency

The gem was not intended for big lists, and efficiency wasn't a concern. If you have ideas on how to make it more efficient, PRs are very welcome.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/crossfield/transformable_list. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

