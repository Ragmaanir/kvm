module Kvm
  module Instructions

    class Instruction
      def name
        self.class.name.split('::').last.underscore
      end

      def size
        1
      end

      def call(env)
        raise NotImplementedError
      end
    end

    class PushConstInt < Instruction
      def size
        2
      end

      def call(env)
        const = env.read_bytecode
        env.push_value(const)
      end
    end

    class PushVar < Instruction
      def size
        2
      end

      def call(env)
        var = env.read_bytecode
        env.value_stack.push(env[var])
      end
    end

    class Assign < Instruction
      def size
        2
      end

      def call(env)
        val = env.value_stack.pop
        var = env.read_bytecode
        env[var] = val
      end
    end

    class Add < Instruction
      def call(env)
        v1 = env.value_stack.pop
        v2 = env.value_stack.pop
        env.value_stack.push(v1 + v2)
      end
    end

    class PopFrame < Instruction
      def call(env)
        env.pop_frame
      end
    end

  end
end

#
# other =
# self.method 1, 2
# other.method 2, 11
#
#
# x = 1
# y = x + 1
# puts y
#
#
# push_const_i, 1
# assign, 0
# push_var, 0
# push_const_i, 1
# add_i
# assign, 1
# push_const System.write
# push_var, 1
# call
