require 'active_support'
require 'active_support/core_ext/string'

require 'kvm/version'

require 'kvm/utils/stack'

require 'kvm/code_block'
require 'kvm/method'
require 'kvm/field'
require 'kvm/kclass'
require 'kvm/kinstance'
require 'kvm/program'
require 'kvm/frame'
require 'kvm/environment'
require 'kvm/instructions/instruction'
require 'kvm/instruction_set'

require 'kvm/code_builder'
require 'kvm/kclass_builder'
require 'kvm/program_builder'

require 'kvm/debugging/code_formatter'
require 'kvm/debugging/operand_stack_displayer'
require 'kvm/debugging/method_call_displayer'
require 'kvm/debugging/stepwise_debugger'

require 'kvm/interpreter'

module Kvm

end
