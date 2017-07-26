require "test_helper"

class TypeWrapperTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TypeWrapper::VERSION
  end

  class ExampleClass
    def foo; 42; end
  end

  module ExampleMixin
    def foo; 43; end
  end

  def test_wraps_objects
    assert_equal 43, TypeWrapper[ExampleClass, ExampleMixin].new(ExampleClass.new).foo
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
    assert_kind_of Class, TypeWrapper[Class.new, ExampleMixin].class
    assert_kind_of Class, TypeWrapper[ExampleClass, ExampleMixin, Module.new { def foo; end }].class
  end

  def test_with_methodless_module
    error = assert_raises(ArgumentError) { TypeWrapper[ExampleClass, Module.new] }
    assert_equal "Module(s) has no public methods defined", error.message
  end

  module First
    def number; 1 end
  end

  module Second
    def number; 2 end
  end

  def test_last_mixin_methods_precedes_previous_mixins
    example =  TypeWrapper[ExampleClass, First, Second].new(ExampleClass.new)
    assert_equal 2, example.number
  end

  def test_tilde
    wrapper = TypeWrapper[String, Comparable]
    unwrapped = "string"
    wrapped = wrapper.new unwrapped
    assert_same unwrapped, ~wrapped
  end

  def test_inspect
    wrapper = TypeWrapper[String, Comparable]
    assert_equal '#< [Comparable] Awesome #>', wrapper.new('Awesome').inspect
  end
end
