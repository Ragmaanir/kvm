module Kvm
  class Environment

    attr_reader :debug_stream

    def initialize(methods)
      @methods = methods
      @operand_stack = Utils::Stack.new
      @frame_stack = Utils::Stack.new(Frame.new(find_method(:main), 10))
      @debug_stream = []
    end

    def read_bytecode
      current_frame.read_bytecode
    end

    def finished?
      @frame_stack.empty?
    end

    def current_frame
      @frame_stack.top
    end

    def pop_frame
      @frame_stack.pop
    end

    def constants
      current_frame.method.constants
    end

    def call(object, method_name)
      @frame_stack.push(Frame.new(find_method(method_name), 10))
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

    def [](var)
      current_frame[var]
    end

    def []=(var, val)
      current_frame[var] = val
    end

    def breakpoint
      require 'byebug'
      byebug
    end

    def debug(data)
      @debug_stream << data
    end

  private

    def find_method(name)
      @methods.find{ |m| m.name.to_s == name.to_s } || raise("Method not found: #{name}")
    end

  end
end
