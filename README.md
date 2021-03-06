# kvm

https://github.com/Ragmaanir/kvm

## DESCRIPTION:

Very light-weight and experimental VM implemented in Ruby.

## Features

* Build your bytecode using readable mnemonics by using the `Kvm::CodeBuilder`
* Output the bytecode in a readable format with `Kvm::CodeSegment.to_s`
* Add custom instruction with ease by creating a subclass of `Kvm::Instruction` and adding that instruction to your own custom `Kvm::InstructionSet` instance.

## Problems/Todo

* just a lot (classes, methods, exceptions, ...)

## Synopsis

This is a working example of a loop:

    bytecode = Kvm::CodeBuilder.build do
      push_const_int 5

      label :loop
      push_const_int 1
      sub
      dup
      debug # prints top of value stack to consonle
      if_zero :success
      jump :loop

      label :success
      ret
    end

    i = Kvm::Interpreter.new(bytecode)
    i.run

## Requirements

* activesupport

## Install

* just git clone

## Developers

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

## License

(The MIT License)

Copyright (c) 2015 Ragmaanir

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
