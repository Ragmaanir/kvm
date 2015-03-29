module Kvm
  module Debugging
    class MethodCallDisplayer
      def self.display(*args)
        new(*args).call
      end

      def initialize(env)
        @env = env
      end

      def call
        str = ""



        str
      end
    end
  end
end
