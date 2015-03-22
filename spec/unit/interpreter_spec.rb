describe Kvm::Interpreter do

  it '' do
    code_block = Kvm::CodeBuilder.build do
      push_int 99
      push_int 2
      add
      debug
      store 0
      ret
    end

    m = Kvm::Method.new(:main, code_block)
    i = described_class.new([m])
    i.run

    assert{ i.environment.debug_stream == [101] }
    #assert{ i.environment.variables == [101] }
  end

  it '' do
    code_block = Kvm::CodeBuilder.build do
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

    m = Kvm::Method.new(:main, code_block)
    i = described_class.new([m])
    i.run

    #assert{ i.environment.variables == [0] }
  end

  it '' do
    code_block = Kvm::CodeBuilder.build do
      push_int 5

      label :loop
      push_int 1
      sub
      dup
      debug
      if_non_zero :loop

      ret
    end

    m = Kvm::Method.new(:main, code_block)
    i = described_class.new([m])
    i.run

    assert{ i.environment.debug_stream == [4,3,2,1,0] }
  end

  it '' do
    m1_block = Kvm::CodeBuilder.build do
      push_int 1337
      ret
    end

    m2_block = Kvm::CodeBuilder.build do
      push_int 1
      call const('other')
      debug
      ret
    end

    m1 = Kvm::Method.new(:main, m2_block)
    m2 = Kvm::Method.new(:other, m1_block)
    i = described_class.new([m1, m2])
    i.run

    assert{ i.environment.debug_stream == [1337] }
  end

end
