module Kvm
  class Field

    attr_reader :name, :type

    def initialize(name, type)
      @name = name
      @type = type
    end

    def ==(other)
      case other
        when Field then name == other.name
        else false
      end
    end

  end
end
