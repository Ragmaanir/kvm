require 'forwardable'

module Kvm
  module Utils
    class Stack

      extend Forwardable

      def_delegators :@stack, :empty?, :length, :size

      def initialize(*args)
        @stack = [*args]
      end

      def push(value)
        @stack << value
      end

      def pop
        raise if empty?
        @stack.pop
      end

      def top
        @stack.last
      end


    end
  end
end
