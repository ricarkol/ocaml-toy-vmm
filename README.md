This is a tiny toy KVM-based-VMM written in OCaml using Cstubs_cstructs. It's based on [kvm-host](https://gist.github.com/zserge/ae9098a75b2b83a1299d19b79b5fe488) by Serge Zaitsev, and the [Cstubs_cstructs example](https://github.com/ocamllabs/ocaml-ctypes/tree/master/examples/cstubs_structs) in the
ocaml-ctypes repo. It's capable of starting a Linux bzImage and loading an initrd (or initramfs). It just emulates a very basic 8250 serial console (and just the basic features).

Note that this is very rough: errors are not handled correctly, everything is hardcoded (like memory size), it's full of magic values without any explanation, and files are pretty much the same as the ones in the ocaml-ctypes example.
