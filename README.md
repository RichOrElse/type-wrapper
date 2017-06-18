# TypeWrapper

Delegator pattern in Ruby without object schizophrenia. Because Object#extend at runtime is evil.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'type_wrapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install type_wrapper

## Usage

```ruby
module ToArray
  def to_a
    [self]
  end
end

module ToString
  def to_s
    "#{self}"
  end
end

Person = Struct.new(:name)

PersonPresenter = TypeWrapper[Person, ToArray, ToString]

peter = PersonPresenter.new(Person.new('Peter'))
peter.to_a
```

## Pros

* Five (5) times faster than [Object#extend](https://apidock.com/ruby/Object/extend).
* Delegation without [self schizophrenia](https://en.wikipedia.org/wiki/Schizophrenia_(object-oriented_programming)).
* Allows [DCI](http://dci.github.io/) in Ruby without [blowing the method cache at run time](https://tonyarcieri.com/dci-in-ruby-is-completely-broken).

## Cons

* Three (3) times slower than calling class method. [See benchmark.](https://github.com/RichOrElse/wrapper-based/tree/master/examples/benchmark.rb)
* [Procedural code](https://en.wikipedia.org/wiki/Procedural_programming) inside Mixin is broken.
* Methods applied by [Object#extend](https://apidock.com/ruby/Object/extend) takes precedence over Mixin methods.
* Will not work with anonymous Class and Mixins.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RichOrElse/type_wrapper.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
