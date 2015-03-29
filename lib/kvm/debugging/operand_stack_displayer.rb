module Kvm
  module Debugging
    class OperandStackDisplayer

      def self.display(*args)
        new(*args).call
      end

      def initialize(env)
        @env = env
      end

      def call
        str = "--- #{@env.current_object.name} #{@env.current_method.name} ---\n"

        @env.operand_stack.to_a.each_with_index.map do |entry, i|
          str << "%2d: %s\n" % [i, entry]
        end

        str
      end
    end
  end
end
