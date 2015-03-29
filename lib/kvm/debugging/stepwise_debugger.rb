module Kvm
  module Debugging
    class StepwiseDebugger

      def self.debug(interpreter)
        new(interpreter).run
      end

      def initialize(interpreter)
        @interpreter = interpreter
      end

      def run
        @interpreter.run_stepwise do |env|
          puts Kvm::Debugging::OperandStackDisplayer.display(env)
          #puts Kvm::Debugging::MethodCallDisplay.display(i.environment.current_method)
          puts Kvm::Debugging::CodeFormatter.new(env.current_method, current_instruction: env.current_instruction_counter)

          input = STDIN.gets.strip
          byebug if input == 'inspect'
        end
      end

    end
  end
end
