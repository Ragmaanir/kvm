module Kvm
  class CodeFormatter

    attr_reader :code_block, :instruction_set

    def initialize(code_block, instruction_set: DEFAULT_IS)
      @code_block = code_block
      @instruction_set = instruction_set
    end

    def validate

    end

    def each_instruction
      i = 0

      while i < @code_block.code.length
        bc = @code_block.code[i]
        inst = instruction_set[bc] || raise("Invalid bytecode #{bc} at byte #{i} for instruction set")

        yield(i, inst)

        i = i + inst.size
      end
    end

    # Outputs:
    # [
    #   [0, 0x3, [12]],
    #   [2, 0x7, []],
    #   [3, 0x1, []]
    # ]
    def mnemonics
      mnemonics = []

      each_instruction do |i, inst|
        mnemonics << [
          i,
          inst.name,
          @code_block.code[(i+1), inst.size - 1]
        ]
      end

      mnemonics
    end

    # Outputs:
    #    1: push_cont_int 1
    #    2: add
    def to_s
      str = ""

      mnemonics.map do |(byte_no, name, values)|
        str << "%4d: " % byte_no
        str << name.to_s
        str << " " + values.join(',') if values.present?
        str << "\n"
      end

      str
    end

  end
end
