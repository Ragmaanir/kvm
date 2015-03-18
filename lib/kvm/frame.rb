module Kvm
  class Frame

    attr_accessor :instruction_counter

    def initialize(instruction_counter)
      @instruction_counter = instruction_counter
    end

  end
end
