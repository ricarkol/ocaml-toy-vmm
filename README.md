This is a tiny toy KVM-based-VMM written in OCaml using Cstubs_cstructs. It's
based on kvm-host by Serge Zaitsev [1], and the Cstubs_cstructs example in the
ocaml-ctypes repo [2]. It's capable of starting a Linux bzImage and loading an
initrd (or initramfs). It just emulates a very basic 8250 serial console and
has no other device emulated.

Note that this is very rough: errors are not handled correctly, everything is
hardcoded (like memory size), and it's full of magic values without any
explanation.

[1] https://gist.github.com/zserge/ae9098a75b2b83a1299d19b79b5fe488)
[2] https://github.com/ocamllabs/ocaml-ctypes/tree/master/examples/cstubs_structs
