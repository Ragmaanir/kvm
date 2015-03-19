module Kvm
  class CodeSegment

    attr_reader :bytecode, :instruction_set

    def initialize(bytecode, instruction_set: DEFAULT_IS)
      @bytecode = bytecode
      @instruction_set = instruction_set
    end

    def validate

    end

    def mnemonics
      mnemonics = []
      i = 0

      while i < @bytecode.length
        bc = @bytecode[i]
        inst = instruction_set[bc] || raise("Invalid bytecode #{bc} at byte #{i} for instruction set")

        mnemonics << [
          i,
          inst.name,
          @bytecode[(i+1), inst.size - 1]
        ]


        i = i + inst.size
      end

      mnemonics
    end

    def to_s
      str = ""

      mnemonics.map do |(byte_no, name, values)|
        str << "%4d: " % byte_no
        str << name
        str << " " + values.join(',') if values.present?
        str << "\n"
      end

      str
    end

  end
end
