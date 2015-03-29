module Kvm
  module Instructions

    class Instruction
      attr_reader :name, :size, :code

      def initialize(name, size: 1, &block)
        @name = name
        @size = size
        @code = block
      end

      def call(env)
        code.call(env)
      end

      def inspect
        "#{self.class.name}(#{name}, #{size})"
      end
    end

    PushInt = Instruction.new(:push_int, size: 2) do |env|
      const = env.read_bytecode
      env.push_operand(const)
    end

    PushStr = Instruction.new(:push_str, size: 2) do |env|
      const_idx = env.read_bytecode
      str = env.constants[const_idx]
      env.push_operand(str)
    end

    Load = Instruction.new(:load, size: 2) do |env|
      var = env.read_bytecode
      env.push_operand(env[var])
    end

    Store = Instruction.new(:store, size: 2) do |env|
      val = env.pop_operand
      var = env.read_bytecode
      env[var] = val
    end

    Add = Instruction.new(:add) do |env|
      v1 = env.pop_operand
      v2 = env.pop_operand
      env.push_operand(v1 + v2)
    end

    Sub = Instruction.new(:sub) do |env|
      v1 = env.pop_operand
      v2 = env.pop_operand
      env.push_operand(v2 - v1)
    end

    Dup = Instruction.new(:dup) do |env|
      v = env.top_operand
      env.push_operand(v)
    end

    Pop = Instruction.new(:pop) do |env|
      env.pop_operand
    end

    IfZero = Instruction.new(:if_zero, size: 2) do |env|
      target = env.read_bytecode
      value = env.pop_operand
      if value == 0
        env.current_frame.instruction_counter = target
      end
    end

    IfNonZero = Instruction.new(:if_non_zero, size: 2) do |env|
      target = env.read_bytecode
      value = env.pop_operand
      if value != 0
        env.current_frame.instruction_counter = target
      end
    end

    Goto = Instruction.new(:goto, size: 2) do |env|
      env.current_frame.instruction_counter = env.read_bytecode
    end

    Call = Instruction.new(:call, size: 2) do |env|
      obj = env.pop_operand
      const_id = env.read_bytecode
      env.call(obj, env.constants[const_id])
    end

    Ret = Instruction.new(:ret) do |env|
      env.pop_frame
    end

    Allocate = Instruction.new(:allocate, size: 2) do |env|
      const_id = env.read_bytecode
      cls = env.find_object(env.constants[const_id])
      obj = env.allocate(cls)
      env.push_operand(obj)
    end

    GetField = Instruction.new(:get_field, size: 2) do |env|
      field_id = env.read_bytecode
      field_offset = 0 # FIXME
      obj = env.pop_operand
      env.push_operand(obj[field_offset])
    end

    SetField = Instruction.new(:set_field, size: 2) do |env|
      field_id = env.read_bytecode
      field_offset = 0 # FIXME
      value = env.pop_operand
      obj = env.pop_operand
      obj[field_offset] = value
    end

    Print = Instruction.new(:print) do |env|
      puts env.top_operand
    end

    Breakpoint = Instruction.new(:breakpoint) do |env|
      env.breakpoint
    end

    Debug = Instruction.new(:debug) do |env|
      env.debug(env.top_operand)
    end

  end
end
