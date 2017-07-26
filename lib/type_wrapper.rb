require "type_wrapper/version"
require "type_wrapper/module"
require "type_wrapper/forwarding"
require 'delegate'

module TypeWrapper
  using Module::Refines

  def self.[](*types)
    raise TypeError, "wrong argument type (expected Module(s))" if types.include?(nil)
    raise ArgumentError, "wrong number of arguments (given #{types.size}, expected 2+)" if types.size < 2

    type, *behaviors = *types

    raise ArgumentError, "Module(s) has no public methods defined" if behaviors.flat_map(&:public_instance_methods).empty?

    Class.new DelegateClass(type) do
      alias_method :~@, :__getobj__
      define_method(:inspect) { "#< #{self.class.name || behaviors} #{__getobj__} #>" }

      behaviors.each do |mod|
        include Forwarding.new mod.refines(type), *mod.public_instance_methods, to: :__getobj__
      end
    end
  end
end
