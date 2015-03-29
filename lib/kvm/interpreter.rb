module Kvm
  class Interpreter

    class VMError < RuntimeError
    end

    class ExecutionError < VMError

      attr_reader :error, :environment

      def initialize(error, object, method, instruction_counter, instruction_set)
        @error = error
        @object = object
        @method = method
        @instruction_counter = instruction_counter
        @instruction_set = instruction_set
      end

      def to_s
        f = Debugging::CodeFormatter.new(
          @method.code_block,
          instruction_set: @instruction_set,
          current_instruction: @instruction_counter
        )

        <<-ERROR.gsub(/^\s+\|/,'')
        |Error(#{error.class}): #{error.message}
        |#{@object.name}: #{@method.mangled_name}
        |#{'-'*30}
        |#{f.to_s}
        |#{'-'*30}
        ERROR
      end
    end

    attr_reader :environment, :instruction_set

    def initialize(program, instruction_set: DEFAULT_IS)
      @environment = Environment.new(program)
      @instruction_set = instruction_set
      @halted = false
    end

    def run
      while running?
        interpret
      end
    end

    def run_stepwise(&block)
      while running?
        block.call(environment)
        interpret
      end
    end

    def halted?
      @halted
    end

    def running?
      !halted? && !environment.finished?
    end

  private

    def interpret
      counter = environment.current_instruction_counter
      bc = environment.read_bytecode

      if inst = instruction_set[bc]
        inst.call(environment)
      else
        raise "invalid bytecode: #{bc.inspect}"
      end
    rescue StandardError => e
      raise ExecutionError.new(e, environment.current_object, environment.current_method, counter, instruction_set)
    end
  end
end
