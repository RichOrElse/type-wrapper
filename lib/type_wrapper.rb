require "type_wrapper/version"
require "type_wrapper/module"
require 'delegate'

module TypeWrapper
  alias_method :initialize, def __setobj__(obj)
                              @delegate_tw_obj = obj # change delegation object
                            end

  alias_method :~@,         def __getobj__
                              @delegate_tw_obj # return object we are delegating to
                            end

  def self.[](*types)
    raise TypeError, "wrong argument type (expected Module(s))" if types.include?(nil)
    raise ArgumentError, "wrong number of arguments (given #{types.size}, expected 2+)" if types.size < 2

    FOR[*types]
  end
  
  using Module::Refines

  FOR = -> type, *behaviors do
        Class.new(Delegator) do
          include TypeWrapper
          const_set :Type, type
          const_set :BEHAVIORS, behaviors
          const_set :Trait, Module.new { behaviors.each { |mod| include mod.refines(type) } }
          forwarding = behaviors.flat_map(&:public_instance_methods) - public_instance_methods
          code = forwarding.uniq.map { |meth| "def %{meth}(*args, &block) __getobj__.%{meth}(*args, &block) end" % { meth: meth } }
          class_eval code.unshift("using Trait").join("\n")
        end
      end
end
