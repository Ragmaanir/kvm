module Kvm
  class CodeBlock < Struct.new(:constants, :code)

    def validate
      # validate each instruction
      # validate instruction arguments
      # validate types of operands/data
    end

  end
end
