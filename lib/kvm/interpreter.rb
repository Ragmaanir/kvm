module Kvm
  class Interpreter

    attr_reader :environment, :instruction_set

    def initialize(code, instruction_set: DEFAULT_IS)
      @environment = Environment.new(code)
      @instruction_set = instruction_set
    end

    def run
      while(!environment.finished?)
        interpret
      end
    end

    def run_stepwise(&block)
      while(!environment.finished?)
        interpret
        block.call(self)
      end
    end

  private

    def interpret
      bc = environment.read_bytecode

      if inst = instruction_set[bc]
        inst.call(environment)
      else
        raise "invalid bytecode: #{bc.inspect}"
      end
    end
  end
end
