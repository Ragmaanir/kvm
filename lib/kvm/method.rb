module Kvm
  class Method

    attr_reader :name, :signature, :code_block

    def initialize(name, signature, code_block:, visibility: :public, native: false)
      #raise ArgumentError if code_block && hardcoded
      @name = name
      @signature = signature
      @code_block = code_block
      @visibility = visibility
      @native = native
    end

    def constants
      @code_block.constants
    end

    def code
      if native?
        @code_block
      else
        @code_block.code
      end
    end

    def visibility
      @visibility
    end

    def native?
      @native
    end

    def mangled_name
      "#{@visibility} #{name}(#{signature.join(',')})"
    end

  end
end
