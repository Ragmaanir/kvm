module Kvm
  class ProgramBuilder
    def self.build(*args, &block)
      new(*args, &block).result
    end

    attr_reader :result

    def initialize(entry_point, &block)
      @classes = {}

      instance_eval(&block)

      @result = Program.new(@classes, entry_point)
    end

    def define_class(name, *args, &block)
      @classes[name] = KClassBuilder.build(name, *args, &block)
    end
  end
end
