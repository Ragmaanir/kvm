describe Kvm::KClassBuilder do
  it '' do
    cls = described_class.build('String') do
      method(:length) do
        push_int 5
      end
    end

    assert{ cls.name == 'String' }
    assert{ cls.superclass == 'Object' }
    assert{ cls.instance_methods.length == 1 }
    assert{ cls.instance_methods.first.name == :length }
  end
end
