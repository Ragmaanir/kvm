describe Kvm::Interpreter do

  it '' do
    bytecode = Kvm::CodeBuilder.build do
      push_int 99
      push_int 2
      add
      store 0
      ret
    end

    i = described_class.new(bytecode)
    i.run

    assert{ i.environment.variables == [101] }
  end

  it '' do
    bytecode = Kvm::CodeBuilder.build do
      push_int -1
      push_int 1
      add
      if_zero :success
      push_int 1
      store 0
      goto :end
      label :success
      push_int 0
      store 0
      label :end
      ret
    end

    seg = Kvm::CodeSegment.new(bytecode)

    i = described_class.new(bytecode)
    i.run

    assert{ i.environment.variables == [0] }
  end

  it '' do
    bytecode = Kvm::CodeBuilder.build do
      push_int 5

      label :loop
      push_int 1
      sub
      dup
      debug
      if_non_zero :loop

      ret
    end

    i = described_class.new(bytecode)
    i.run

    assert{ i.environment.debug_stream == [4,3,2,1,0] }
  end

end
