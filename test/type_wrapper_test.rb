require "test_helper"

class TypeWrapperTest < Minitest::Test
  class ExampleClass
    def foo; 42; end
  end

  module ExampleMixin
    def foo; 43; end
  end

  def setup
    @wrapper = TypeWrapper[ExampleClass, ExampleMixin]
  end

  def test_that_it_has_a_version_number
    refute_nil ::TypeWrapper::VERSION
  end

  def test_it_does_something_useful
    assert 43, @wrapper.new(ExampleClass.new).foo
  end
end
