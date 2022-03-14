# Ranger

Modern language implementations using Virtual Machines feature diverse execution engines such as byte-code interpreters and machine-code dynamic translators, a.k.a. JIT compilers.
Validating such engines requires not only validating each in isolation, but also that they are functionally equivalent.
Tests should be duplicated for each execution engine exercising the same execution paths on each of them.

Ranger presents a novel automated testing approach for virtual machines featuring byte-code interpreters.
Ranger uses concolic meta-interpretation:
 - it applies concolic testing to a byte-code interpreter to explore all possible execution interpreter paths and obtain a list of concrete values that explore such paths.
 - it then uses such values to apply differential testing on the VM interpreter and JIT compiler.

This solution is based on two insights: (1) both the interpreter and compiler implement the same language semantics and (2) interpreters are simple executable specifications of those semantics and thus promising targets to (meta-) interpretation using concolic testing.
We validated it on 4 different compilers of the open-source Pharo Virtual Machine and found 468 differences between them, produced by 91 different causes, organized in 6 different categories.

## Dependencies

Ranger has been so far tested on x86-64 OSX, and has the following dependencies:
 - the Pharo VM source code and the Pharo IDE
 - the LLVM disassembler dynamic library with support for at least x86 and ARM32
 - the Unicorn machine simulator dynamic library
 - the minizinc constraint solver (https://www.minizinc.org/)

## Usage Guide

Check the usage guide on the [wiki page](https://github.com/Alamvic/ranger/wiki/Quick-Start)
