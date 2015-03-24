module Kvm
  class Interpreter

    class VMError < RuntimeError
    end

    class ExecutionError < VMError

      attr_reader :error, :environment

      def initialize(error, method, instruction_counter, instruction_set)
        @error = error
        @method = method
        @instruction_counter = instruction_counter
        @instruction_set = instruction_set
      end

      def to_s
        f = CodeFormatter.new(@method.code_block, instruction_set: @instruction_set)

        <<-ERROR.gsub(/^\s+/,'')
        Error(#{error.class}): #{error.message}
        At bytecode #{@instruction_counter} in:
        #{@method.mangled_name}
        -----
        #{f.to_s}
        -----
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
        interpret
        block.call(self)
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
    rescue RuntimeError => e
      raise ExecutionError.new(e, environment.current_frame.method, counter, instruction_set)
    end
  end
end
