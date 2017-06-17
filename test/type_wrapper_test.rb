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

  def test_with_one_argument
    assert_raises(ArgumentError) { TypeWrapper[ExampleClass] }
  end

  def test_wrong_argument_types
    assert_raises(TypeError) { TypeWrapper[nil, ExampleMixin] }
    assert_raises(TypeError) { TypeWrapper[ExampleClass, ExampleMixin, nil] }
    assert_raises(TypeError) { TypeWrapper[ExampleClass, ExampleClass] }
  end

  def test_with_anonymous_class_and_modules
    assert_raises(ArgumentError) { TypeWrapper[Class.new, ExampleMixin] }
    assert_raises(ArgumentError) { TypeWrapper[ExampleClass, ExampleMixin, Module.new] }
  end
end
