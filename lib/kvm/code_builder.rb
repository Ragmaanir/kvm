module Kvm
  class CodeBuilder

    def self.build(instruction_set: DEFAULT_IS, &block)
      new(instruction_set, &block).result
    end

    attr_reader :result

    def initialize(instruction_set=DEFAULT_IS, &block)
      @result = []
      @instruction_set = instruction_set
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

      @result = @result.map do |value|
        case value
          when Integer then value
          when Symbol then @labels[value] || raise("Undefined label: #{value}")
          else raise
        end
      end
    end

    def label(name)
      @labels[name] = @result.length
    end

  private

    def append(*args)
      @result += args
    end

  end
end
