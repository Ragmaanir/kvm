describe Kvm::Interpreter do

  it '' do
    bytecode = Kvm::CodeBuilder.build do
      push_const_int 99
      push_const_int 2
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
      push_const_int -1
      push_const_int 1
      add
      if_zero :success
      push_const_int 1
      store 0
      jump :end
      label :success
      push_const_int 0
      store 0
      label :end
      ret
    end

    seg = Kvm::CodeSegment.new(bytecode)

    puts seg.to_s

    i = described_class.new(bytecode)
    i.run

    assert{ i.environment.variables == [0] }
  end

  it '' do
    bytecode = Kvm::CodeBuilder.build do
      push_const_int 5

      label :loop
      push_const_int 1
      sub
      dup
      debug
      if_zero :success
      jump :loop

      label :success
      ret
    end

    i = described_class.new(bytecode)
    i.run
  end

end
