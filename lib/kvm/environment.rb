module Kvm
  class Environment

    attr_reader :variables, :operand_stack, :code_segment, :frame_stack, :debug_stream

    def initialize(code_segment)
      @variables = []
      @operand_stack = Utils::Stack.new
      @frame_stack = Utils::Stack.new(Frame.new(0))
      @code_segment = code_segment
      @debug_stream = []
    end

    def current_frame
      frame_stack.top
    end

    def read_bytecode
      raise "No more code" if current_frame.instruction_counter == code_segment.length
      code = code_segment[current_frame.instruction_counter]
      current_frame.instruction_counter += 1
      code
    end

    def finished?
      @frame_stack.empty?
    end

    def top_operand
      @operand_stack.top
    end

    def pop_operand
      @operand_stack.pop
    end

    def push_operand(op)
      @operand_stack.push(op)
    end

    def pop_frame
      @frame_stack.pop
    end

    def [](var)
      raise ArgumentError if var > variables.length
      variables[var]
    end

    def []=(var, val)
      #raise ArgumentError if var > variables.length
      variables[var] = val
    end

    def debug(data)
      @debug_stream << data
    end

  end
end
