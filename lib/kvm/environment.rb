module Kvm
  class Environment

    attr_reader :debug_stream

    def initialize(program)
      @program = program
      @operand_stack = Utils::Stack.new
      @frame_stack = Utils::Stack.new(Frame.new(program.main_method, 10))
      @debug_stream = []

      push_operand(program.main_object)
    end

    def current_instruction_counter
      current_frame.instruction_counter
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
      # cls_id, meth_id = method_name.split('#')
      # cls = @program.get_object(cls_id)
      # meth = cls.get_method(meth_id)
      # new_frame = Frame.new(meth, 10)
      # @frame_stack.push(new_frame)
      cls_id, meth_id = if method_name.include?('.')
        method_name.split('.')
      else
        method_name.split('#')
      end

      cls = @program.get_object(cls_id)

      meth = if method_name.include?('.')
        cls.get_object_method(meth_id)
      else
        cls.get_method(meth_id)
      end

      if meth.hardcoded?
        meth.code.call(self)
      else
        new_frame = Frame.new(meth, 10)
        @frame_stack.push(new_frame)
      end
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

  end
end
