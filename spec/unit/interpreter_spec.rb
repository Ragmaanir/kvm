describe Kvm::Interpreter do
  it '' do
    bytecode = Kvm::CodeBuilder.build do
      push_const_int(99)
      push_const_int(2)
      add
      assign(0)
      pop_frame
    end

    i = described_class.new(bytecode)
    i.run

    assert{ i.environment.variables == [101] }
  end
end
