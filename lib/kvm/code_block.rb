module Kvm
  class CodeBlock < Struct.new(:constants, :code)
  end
end
