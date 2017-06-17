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
    FOR[type, *modules]
  end

  FOR = -> type, *behaviors do
        Class.new(Delegator) do
          include TypeWrapper
          forwarding = behaviors.flat_map(&:public_instance_methods) - public_instance_methods
          code = forwarding.uniq.map { |meth| "def %{meth}(*args, &block) __getobj__.%{meth}(*args, &block) end; " % { meth: meth } }
          code.unshift "using Module.new { refine(#{type}) { prepend #{behaviors.reverse.join(', ')} } };"
          class_eval code.join(' ')
        end
      end
end
