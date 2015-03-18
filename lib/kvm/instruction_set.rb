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
    0x1 => Instructions::PushConstInt.new,
    0x2 => Instructions::PushVar.new,
    0x3 => Instructions::Assign.new,
    0x4 => Instructions::Add.new,
    0x5 => Instructions::PopFrame.new
  )
end
