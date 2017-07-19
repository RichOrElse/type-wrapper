module TypeWrapper
# == Basic Usage
#
# === Define a block with the 'new' method and pass the 'mod' parameter to 'using' keyword.
#
#   AwesomeSinging = TypeWrapper::Module.new do |mod| using mod
#     def sing
#       "#{name} sings #{song}"
#     end
#
#     def song
#       "Everything is AWESOME!!!"
#     end
#   end
#
# === Use as refinement module by passing the 'refines' method with types.
#  
#   Lego = Struct.new(:name)
#   using AwesomeSinging[Lego]
#   Lego.new("Emmette").sing
#

  class Module < ::Module
    def initialize(default = Object, *types, &blk)
      mod, @block = self, blk
      types.unshift(default).each do |type|
        refine(type) { module_exec mod, &blk }
      end
      super(&blk)
    end

    def refines(*types)
      self.class.new(*types, &@block)
    end

    alias_method :[], :refines

    module Refines
      refine ::Module do
        def refines(*types)
          mod = self
          Module.new do
            types.each do |type|
              refine(type) { prepend mod }
            end
          end # new Module
        end # refines method
      end # ::Module refinements
    end # Refinements module
  end # Module class
end # TypeWrapper module
