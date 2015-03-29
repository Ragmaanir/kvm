describe Kvm::Interpreter do

  it 'raises helpful error message when bytecode invalid' do
    prog = Kvm::ProgramBuilder.build('App.run') do
      define_class('App') do
        class_method(:run) do
          pop
          pop # raises
          ret
        end
      end
    end

    i = described_class.new(prog)

    expect{ i.run }.to raise_error(Kvm::Interpreter::ExecutionError, <<-ERROR)
Error(RuntimeError): Stack empty
App: public run()
------------------------------
    0: pop
>   1: pop
    2: ret
------------------------------
ERROR
  end

  it 'calls the passed class method on the passed object' do
    prog = Kvm::ProgramBuilder.build('App.run') do
      define_class('App') do
        class_method(:run) do
          debug
          ret
        end
      end
    end

    i = described_class.new(prog)
    i.run

    assert{ i.environment.debug_stream == [prog.objects['App']] }
  end

  it 'loops' do
    prog = Kvm::ProgramBuilder.build('App.run') do
      define_class('App') do
        class_method(:run) do
          push_int 5

          label :loop
          debug
          push_int 1
          sub
          dup
          if_non_zero :loop

          ret
        end
      end
    end

    i = described_class.new(prog)
    i.run

    assert{ i.environment.debug_stream == [5, 4, 3, 2, 1] }
  end

  it 'calls a method' do
    prog = Kvm::ProgramBuilder.build('App.run') do
      define_class('App') do
        class_method(:run) do
          dup
          call const('App.other')
          debug
          ret
        end

        class_method(:other) do
          push_str const('other')
          ret
        end
      end
    end

    i = described_class.new(prog)
    i.run

    assert{ i.environment.debug_stream == ['other'] }
  end

  it 'calls a native method' do
    prog = Kvm::ProgramBuilder.build('App.run') do
      define_class('String') do
        method(:length, [], native: true) do |env|
          env.push_operand(env.top_operand.length)
        end
      end

      define_class('App') do
        class_method(:run) do
          push_str const('Foobar')
          dup
          call const('String#length')
          debug
          ret
        end
      end
    end

    i = described_class.new(prog)
    i.run

    assert{ i.environment.debug_stream == [6] }
  end

  it 'sets an attribute on an object' do
    prog = Kvm::ProgramBuilder.build('App.run') do
      define_class('Foo') do
        field :name, 'String'
        field :age, 'Int'
      end

      define_class('App') do
        class_method(:run) do
          allocate const('Foo')
          dup
          dup
          dup
          #call const('Foo#initialize')
          get_field const('name')
          debug
          pop
          push_int 1337
          set_field const('age')
          get_field const('age')
          debug
          pop
          dup
          push_str const('Yolo')
          set_field const('name')
          get_field const('name')
          debug
          ret
        end
      end
    end

    i = described_class.new(prog)

    i.run
    #Kvm::Debugging::StepwiseDebugger.new(i).run

    assert{ i.environment.debug_stream == [nil, 1337, 'Yolo'] }
  end

  it 'creates an instance of a class'

end
