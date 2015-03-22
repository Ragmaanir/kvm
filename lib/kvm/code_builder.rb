module Kvm
  class CodeBuilder

    def self.build(instruction_set: DEFAULT_IS, &block)
      new(instruction_set, &block).result
    end

    attr_reader :result

    def initialize(instruction_set=DEFAULT_IS, &block)
      @code = []
      @instruction_set = instruction_set
      @constants = []
      @labels = {}

      dsl = Module.new

      instruction_set.each do |bytecode, instruction|
        dsl.send(:define_method, instruction.name) do |*args|
          raise ArgumentError if instruction.size != args.length + 1
          append(bytecode, *args)
        end
      end

      self.extend(dsl)

      instance_eval(&block)

      @code = @code.map do |value|
        case value
          when Integer then value
          when Symbol then @labels[value] || raise("Undefined label: #{value}")
          else raise("Invalid bytecode element: #{value.inspect}")
        end
      end

      @result = CodeBlock.new(@constants, @code)
    end

    def label(name)
      @labels[name] = @code.length
    end

    def const(val)
      if idx = @constants.index(val)
        idx
      else
        @constants << val
        @constants.length - 1
      end
    end

  private

    def append(*args)
      @code += args
    end

  end
end
