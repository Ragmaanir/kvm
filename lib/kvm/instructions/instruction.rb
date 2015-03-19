module Kvm
  module Instructions

    def self.name_of(cls)
      cls.name.split('::').last.underscore
    end

    class Instruction
      def name
        Instructions.name_of(self.class)
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

    class Load < Instruction
      def size
        2
      end

      def call(env)
        var = env.read_bytecode
        env.value_stack.push(env[var])
      end
    end

    class Store < Instruction
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

    class Sub < Instruction
      def call(env)
        v1 = env.value_stack.pop
        v2 = env.value_stack.pop
        env.value_stack.push(v2 - v1)
      end
    end

    class Dup < Instruction
      def call(env)
        v = env.value_stack.pop
        env.value_stack.push(v)
        env.value_stack.push(v)
      end
    end

    class IfZero < Instruction
      def size
        2
      end

      def call(env)
        target = env.read_bytecode
        value = env.value_stack.pop
        if value == 0
          env.current_frame.instruction_counter = target
        end
      end
    end

    class Goto < Instruction
      def size
        2
      end

      def call(env)
        env.current_frame.instruction_counter = env.read_bytecode
      end
    end

    class Ret < Instruction
      def call(env)
        env.pop_frame
      end
    end

    class Debug < Instruction
      def call(env)
        puts(env.value_stack.last)
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
