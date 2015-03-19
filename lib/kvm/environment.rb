module Kvm
  class Environment

    attr_reader :variables, :value_stack, :code_segment, :frame_stack

    def initialize(code_segment)
      @variables = []
      @value_stack = []
      @frame_stack = [Frame.new(0)]
      @code_segment = code_segment
    end

    def current_frame
      frame_stack.last
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

    def push_value(val)
      @value_stack << val
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

  end
end