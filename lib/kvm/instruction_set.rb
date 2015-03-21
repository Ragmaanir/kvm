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
    0x1 => Instructions::PushInt.new,
    0x2 => Instructions::Load.new,
    0x3 => Instructions::Store.new,
    0x4 => Instructions::Add.new,
    0x5 => Instructions::Sub.new,
    0x6 => Instructions::Dup.new,
    0x7 => Instructions::Ret.new,
    0x8 => Instructions::IfZero.new,
    0x9 => Instructions::IfNonZero.new,
    0x10 => Instructions::Goto.new,
    0xff => Instructions::Debug.new
  )
end
