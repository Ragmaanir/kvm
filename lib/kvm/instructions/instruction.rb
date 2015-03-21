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
    end

    PushInt = Instruction.new(:push_int, size: 2) do |env|
      const = env.read_bytecode
      env.push_value(const)
    end

    Load = Instruction.new(:load, size: 2) do |env|
      var = env.read_bytecode
      env.push_value(env[var])
    end

    Store = Instruction.new(:store, size: 2) do |env|
      val = env.pop_value
      var = env.read_bytecode
      env[var] = val
    end

    Add = Instruction.new(:add) do |env|
      v1 = env.pop_value
      v2 = env.pop_value
      env.push_value(v1 + v2)
    end

    Sub = Instruction.new(:sub) do |env|
      v1 = env.pop_value
      v2 = env.pop_value
      env.push_value(v2 - v1)
    end

    Dup = Instruction.new(:dup) do |env|
      v = env.top_value
      env.push_value(v)
    end

    IfZero = Instruction.new(:if_zero, size: 2) do |env|
      target = env.read_bytecode
      value = env.pop_value
      if value == 0
        env.current_frame.instruction_counter = target
      end
    end

    IfNonZero = Instruction.new(:if_non_zero, size: 2) do |env|
      target = env.read_bytecode
      value = env.pop_value
      if value != 0
        env.current_frame.instruction_counter = target
      end
    end

    Goto = Instruction.new(:goto, size: 2) do |env|
      env.current_frame.instruction_counter = env.read_bytecode
    end

    Ret = Instruction.new(:ret) do |env|
      env.pop_frame
    end

    Debug = Instruction.new(:debug) do |env|
      env.debug(env.top_value)
    end

  end
end
