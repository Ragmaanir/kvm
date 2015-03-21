module Kvm
  class InstructionSet

    def initialize(instructions)
      @instructions = instructions
    end

    def [](bc)
      @instructions[bc]
    end

    def each(*args, &block)
      @instructions.each(*args, &block)
    end

  end

  DEFAULT_IS = InstructionSet.new(
    0x1 => Instructions::PushInt,
    0x2 => Instructions::Load,
    0x3 => Instructions::Store,
    0x4 => Instructions::Add,
    0x5 => Instructions::Sub,
    0x6 => Instructions::Dup,
    0x7 => Instructions::Ret,
    0x8 => Instructions::IfZero,
    0x9 => Instructions::IfNonZero,
    0x10 => Instructions::Goto,
    0xff => Instructions::Debug
  )
end
