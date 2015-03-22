module Kvm
  class Method

    attr_reader :name

    def initialize(name, code_block)
      @name = name
      @code_block = code_block
    end

    def constants
      @code_block.constants
    end

    def code
      @code_block.code
    end

  end
end
