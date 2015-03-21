describe Kvm::CodeBuilder do

  it '' do
    bytecode = described_class.build do
      push_int 99
      push_int 2
      add
      store 0
      ret
    end

    output = <<-BYTECODE
   0: push_int 99
   2: push_int 2
   4: add
   5: store 0
   7: ret
    BYTECODE

    seg = Kvm::CodeSegment.new(bytecode)

    assert{ seg.to_s == output }
  end

  it '' do
    bytecode = described_class.build do
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

    output = <<-BYTECODE
   0: push_int -1
   2: push_int 1
   4: add
   5: if_zero 13
   7: push_int 1
   9: store 0
  11: goto 17
  13: push_int 0
  15: store 0
  17: ret
    BYTECODE

    seg = Kvm::CodeSegment.new(bytecode)

    assert{ seg.to_s == output }
  end

  it '' do
    bytecode = described_class.build do
      push_int 5

      label :loop
      push_int 1
      sub
      dup
      debug
      if_non_zero :loop

      ret
    end
  end

end
