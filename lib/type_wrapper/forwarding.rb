module TypeWrapper
  class Forwarding < Module
    def initialize(refinements, *forward, to:)
      raise ArgumentError, "No List of Methods specified.", caller if forward.empty?
      raise ArgumentError, "Can't convert #{to}:#{to.class} to Symbol", caller unless to.respond_to? :to_sym
      const_set :Refinements, refinements
      DefineMethods[forward, to.to_sym, self]
      @forward = forward
      @target = to
    end

    def inspect
      refinements = const_get :Refinements
      name || "Forwarding[#{refinements} #{@forward.join(' ')} to: #{@target}]"
    end

    def self.[](*args)
      new *args
    end

    DefineMethods = -> forward, target, base do
      code = forward.uniq.map do |forwarding|
        <<-EOS
          def #{forwarding}(*args, &block)
            #{target}.#{forwarding}(*args, &block)
          end
        EOS
      end
      base.module_eval code.unshift("using Refinements").join("\n")
    end # DefineMethods proc
  end # Forwarding class
end
