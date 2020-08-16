module Stubs = Bindings.Stubs (Bindings_stubs)
open Unix
open Unix_representations
open Stubs.Kvm_userspace_memory_region
open Stubs.Kvm
open Stubs.Kvm_exit
open Ctypes
open Bigarray
open Stubs

let ioctl =
  Foreign.foreign "ioctl" Ctypes.(int @-> int @-> int @-> returning int)

let ioctl2 =
  Foreign.foreign "ioctl" Ctypes.(int @-> int @-> ptr void @-> returning int)

exception MmapExc of string

let mmap =
  Foreign.foreign "mmap"
    Ctypes.(
      ptr void @-> size_t @-> int @-> int @-> int @-> size_t
      @-> returning (ptr_opt void))

let empty_sregs vcpu_fd =
  let open Ctypes in
  let sregs = make Stubs.Kvm_sregs.t in
  let _ = ioctl2 vcpu_fd _KVM_GET_SREGS (to_voidp (addr sregs)) in
  (* XXX: check for failure *)
  let () =
    setf sregs Kvm_sregs.cs_base Int64.zero;
    setf sregs Kvm_sregs.cs_selector 0;
    setf sregs Kvm_sregs.ss_base Int64.zero;
    setf sregs Kvm_sregs.ss_selector 0;
    setf sregs Kvm_sregs.ds_base Int64.zero;
    setf sregs Kvm_sregs.ds_selector 0;
    setf sregs Kvm_sregs.es_base Int64.zero;
    setf sregs Kvm_sregs.es_selector 0;
    setf sregs Kvm_sregs.fs_base Int64.zero;
    setf sregs Kvm_sregs.fs_selector 0;
    setf sregs Kvm_sregs.gs_selector 0
  in
  sregs

let get_region size file_path =
  let region = Ctypes.make Stubs.Kvm_userspace_memory_region.t in
  (*let mem_fd = Unix.openfile "/dev/shm/test"*)
  let mem_fd = Unix.openfile file_path [ Unix.O_RDWR ] 0o656 in
  (*[Unix.O_RDWR; Unix.O_TRUNC; Unix.O_CREAT] 0o656 in*)
  let buf =
    array1_of_genarray (Unix.map_file mem_fd char c_layout false [| size |])
  in
  (*let a = array_of_bigarray array1 buf in*)
  let () =
    let open Ctypes in
    setf region slot Int32.zero;
    setf region flags Int32.zero;
    setf region guest_phys_addr Int64.zero;
    setf region memory_size (Int64.of_int size);
    setf region userspace_addr (bigarray_start array1 buf)
  in
  (region, mem_fd)

let main () =
  let kvm_fd = openfile "/dev/kvm" [ O_RDWR ] 0 in
  let () = Printf.printf "kvm_fd = %d\n" (int_of_file_descr kvm_fd) in
  let fd = Int32.of_int (int_of_file_descr kvm_fd) in
  let vm_fd = ioctl (int_of_file_descr kvm_fd) _KVM_CREATE_VM 0 in

  let () = Printf.printf "vm_fd = %d\n" vm_fd in
  let size = 1_073_741_824 in

  let region, mem_fd = get_region size "../guest" in
  let _ =
    ioctl2 vm_fd _KVM_SET_USER_MEMORY_REGION Ctypes.(to_voidp (addr region))
  in

  let vcpu_fd = ioctl vm_fd _KVM_CREATE_VCPU 0 in
  let () = Printf.printf "vcpu_fd = %d\n" vcpu_fd in

  let kvm_run_mmap_size =
    ioctl (int_of_file_descr kvm_fd) _KVM_GET_VCPU_MMAP_SIZE 0
  in
  let () = Printf.printf "vcpu_mmap_size = %d\n" kvm_run_mmap_size in

  (* PROT_READ | PROT_WRITE is 3 *)
  (* MAP_SHARED is 1 *)
  let run_addr =
    match
      mmap Ctypes.null
        (Unsigned.Size_t.of_int kvm_run_mmap_size)
        3 1 vcpu_fd (Unsigned.Size_t.of_int 0)
    with
    | None -> raise (MmapExc "mmap returned null")
    | Some p -> p
  in

  let run_ptr = coerce (ptr void) (ptr Stubs.Kvm_run.t) run_addr in

  let run = !@run_ptr in
  let () =
    Printf.printf "exit_reason = %d\n" (getf run Stubs.Kvm_run.exit_reason)
  in

  let regs = Ctypes.make Stubs.Kvm_regs.t in
  let sregs = empty_sregs vcpu_fd in

  let _ = ioctl2 vcpu_fd _KVM_SET_SREGS Ctypes.(to_voidp (addr sregs)) in

  let () =
    Ctypes.setf regs Kvm_regs.rflags (Int64.of_int 2);
    Ctypes.setf regs Kvm_regs.rip Int64.zero
  in

  let _ = ioctl2 vcpu_fd _KVM_SET_REGS Ctypes.(to_voidp (addr regs)) in

  let rec process_exit reason =
    match reason with
    | z when z == _KVM_EXIT_IO ->
        let port = Ctypes.getf run Stubs.Kvm_run.io_port in
        let offset = Ctypes.getf run Stubs.Kvm_run.io_data_offset in
        let void_ptr =
          Nativeint.add
            (raw_address_of_ptr run_addr)
            (Nativeint.of_int (Int64.to_int offset))
        in
        let data_ptr =
          coerce (ptr void) (ptr int64_t) (ptr_of_raw_address void_ptr)
        in
        let data = !@data_ptr in
        let () = Printf.printf "IO port: %x, data: %Lx\n" port data in
        let ret = ioctl vcpu_fd _KVM_RUN 0 in
        process_exit (getf run Stubs.Kvm_run.exit_reason)
    | z when z == _KVM_EXIT_SHUTDOWN -> Printf.printf "shutdown\n"
    | x -> Printf.printf "unknown exit %d\n" x
  in

  let ret = ioctl vcpu_fd _KVM_RUN 0 in
  let () = Printf.printf "kvm_exit_io = %d\n" Stubs.Kvm_exit._KVM_EXIT_IO in
  let () = process_exit (getf run Stubs.Kvm_run.exit_reason) in

  let () = close mem_fd in
  let () = close (file_descr_of_int vm_fd) in
  close kvm_fd

let () = main ()

(*
NOTES:

Cstruct.of_bigarray
https://github.com/avsm/mirage-duniverse/blob/983e115ff5a9fb37e3176c373e227e9379f0d777/ocaml_modules/cstruct/ppx_test/basic.ml#L131

http://lists.ocaml.org/pipermail/ctypes/2016-February/000196.html

ctypes:
http://ocamllabs.io/ocaml-ctypes/Ctypes.html
bigarray_of_ptr

https://dev.realworldocaml.org/runtime-memory-layout.html

https://github.com/mirage/mmap/blob/master/test/test.ml

    let a = array1_of_genarray (Mmap.V1.map_file fd float64 c_layout true [|10000|])    in
    for i = 0 to 9999 do a.{i} <- float i done;

http://lists.ocaml.org/pipermail/ctypes/2013-December/000017.html

struct in struct
https://github.com/ocamllabs/ocaml-ctypes/blob/master/examples/fts/foreign/fts.ml

let p_addr = Ctypes.allocate (ptr mystruct) (from_voidp mystruct null) in
let err = myfunc p_addr in
let p = !@ p_addr in
https://stackoverflow.com/questions/49166644/ocaml-ctypes-how-to-make-the-pointer-to-pointer

*)
