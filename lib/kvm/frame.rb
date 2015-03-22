module Kvm
  class Frame

    attr_accessor :method, :instruction_counter, :max_variables

    def initialize(method, max_variables)
      @method = method
      @instruction_counter = 0
      @max_variables = max_variables
      @variables = Array.new(max_variables)
    end

    def read_bytecode
      raise "No more code" if instruction_counter == method.code.length
      code = method.code[instruction_counter]
      self.instruction_counter += 1
      code
    end

    def [](at)
      raise if at >= max_variables
      @variables[at]
    end

    def []=(at, value)
      raise if at >= max_variables
      @variables[at] = value
    end

  end
end
