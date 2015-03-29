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
    0x01 => Instructions::PushInt,
    0x02 => Instructions::PushStr,
    0x03 => Instructions::Dup,
    0x04 => Instructions::Pop,
    0x10 => Instructions::Load,
    0x11 => Instructions::Store,
    0x20 => Instructions::Add,
    0x21 => Instructions::Sub,
    0x30 => Instructions::IfZero,
    0x31 => Instructions::IfNonZero,
    0x32 => Instructions::Goto,
    0x33 => Instructions::Call,
    0x34 => Instructions::Ret,
    0x40 => Instructions::Allocate,
    0x41 => Instructions::GetField,
    0x42 => Instructions::SetField,
    0xf0 => Instructions::Print,
    0xf1 => Instructions::Breakpoint,
    0xf2 => Instructions::Debug
  )
end
