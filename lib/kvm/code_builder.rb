module Kvm
  class CodeBuilder

    def self.build(instruction_set: DEFAULT_IS, &block)
      new(instruction_set, &block).result
    end

    attr_reader :result

    def initialize(instruction_set=DEFAULT_IS, &block)
      @result = []
      @instruction_set = instruction_set

      dsl = Module.new

      instruction_set.each do |bytecode, instruction|
        dsl.send(:define_method, instruction.name) do |*args|
          raise ArgumentError if args.length != (instruction.size - 1)
          append(bytecode, *args)
        end
      end

      self.extend(dsl)

      instance_eval(&block)
    end

    # def push_const_i(val)
    #   append(Instructions::BC_PUSH_CONST_I, val)
    # end

    # def push_var(var)
    #   append(Instructions::BC_PUSH_VAR, var)
    # end

    # def assign(var)
    #   append(Instructions::BC_ASSIGN, var)
    # end

    # def add_i
    #   append(Instructions::BC_ADD_I)
    # end

    # def pop_frame
    #   append(Instructions::BC_POP_FRAME)
    # end

  private

    def append(*args)
      @result += args
    end

  end
end
