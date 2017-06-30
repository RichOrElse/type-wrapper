require "type_wrapper/version"
require 'delegate'

module TypeWrapper
  alias_method :initialize, def __setobj__(obj)
                              @delegate_tw_obj = obj # change delegation object
                            end

  alias_method :~@,         def __getobj__
                              @delegate_tw_obj # return object we are delegating to
                            end

  def self.[](type, *modules)
    raise TypeError, "wrong argument type (expected Class)" unless Class === type
    raise TypeError, "wrong argument type (expected Module(s))" unless modules.all? { |mod| mod.class == Module }
    raise ArgumentError, "wrong number of arguments (given 1, expected 2+)" if modules.empty?

    FOR[type, *modules]
  end

  FOR = -> type, *behaviors do
        Class.new(Delegator) do
          include TypeWrapper
          const_set :Type, type
          const_set :BEHAVIORS, behaviors
          const_set :Trait, Module.new { refine(type) { prepend(*behaviors.reverse) } }
          forwarding = behaviors.flat_map(&:public_instance_methods) - public_instance_methods
          code = forwarding.uniq.map { |meth| "def %{meth}(*args, &block) __getobj__.%{meth}(*args, &block) end" % { meth: meth } }
          class_eval code.unshift("using Trait").join("\n")
        end
      end
end
