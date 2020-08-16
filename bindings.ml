module Stubs =
functor
  (S : Cstubs_structs.TYPE)
  ->
  struct
    module Kvm_userspace_memory_region = struct
      type kvm_userspace_memory_region

      type t = kvm_userspace_memory_region Ctypes.structure

      let t : t S.typ = S.structure "kvm_userspace_memory_region"

      let slot = S.(field t "slot" int32_t)

      let flags = S.(field t "flags" int32_t)

      let guest_phys_addr = S.(field t "guest_phys_addr" int64_t)

      let memory_size = S.(field t "memory_size" int64_t)

      let userspace_addr = S.(field t "userspace_addr" (ptr char))

      let () = S.seal t
    end

    module Kvm_run = struct
      type kvm_run

      type t = kvm_run Ctypes.structure

      let t : t S.typ = S.structure "kvm_run"

      let exit_reason = S.(field t "exit_reason" int)

      let io_port = S.(field t "io.port" int16_t)

      let io_data_offset = S.(field t "io.data_offset" int64_t)

      let () = S.seal t
    end

    module Kvm_regs = struct
      type kvm_regs

      type t = kvm_regs Ctypes.structure

      let t : t S.typ = S.structure "kvm_regs"

      let rflags = S.(field t "rflags" int64_t)

      let rip = S.(field t "rip" int64_t)
      
      let rsi = S.(field t "rsi" int64_t)

      let () = S.seal t
    end

    module Kvm_sregs = struct
      type kvm_sregs

      type t = kvm_sregs Ctypes.structure

      let t : t S.typ = S.structure "kvm_sregs"

      let cs_selector = S.(field t "cs.selector" int16_t)

      let cs_base = S.(field t "cs.base" int64_t)
      let cs_limit = S.(field t "cs.limit" int32_t)
      let cs_g = S.(field t "cs.g" int8_t)
      let cs_db = S.(field t "cs.db" int8_t)

      let ss_selector = S.(field t "ss.selector" int16_t)

      let ss_base = S.(field t "ss.base" int64_t)
      let ss_limit = S.(field t "ss.limit" int32_t)
      let ss_g = S.(field t "ss.g" int8_t)
      let ss_db = S.(field t "ss.db" int8_t)

      let ds_selector = S.(field t "ds.selector" int16_t)

      let ds_base = S.(field t "ds.base" int64_t)
      let ds_limit = S.(field t "ds.limit" int32_t)
      let ds_g = S.(field t "ds.g" int8_t)

      let es_selector = S.(field t "es.selector" int16_t)

      let es_base = S.(field t "es.base" int64_t)
      let es_limit = S.(field t "es.limit" int32_t)
      let es_g = S.(field t "es.g" int8_t)

      let fs_selector = S.(field t "fs.selector" int16_t)

      let fs_base = S.(field t "fs.base" int64_t)
      let fs_limit = S.(field t "fs.limit" int32_t)
      let fs_g = S.(field t "fs.g" int8_t)

      let gs_selector = S.(field t "gs.selector" int16_t)

      let gs_base = S.(field t "gs.base" int64_t)
      let gs_limit = S.(field t "gs.limit" int32_t)
      let gs_g = S.(field t "gs.g" int8_t)
      
      let cr0 = S.(field t "cr0" int64_t)

      let () = S.seal t
    end

    module Kvm_cpuid_entry2 = struct
      type kvm_cpuid_entry2

      type t = kvm_cpuid_entry2 Ctypes.structure

      let t : t S.typ = S.structure "kvm_cpuid_entry2"

      let _function = S.(field t "function" uint32_t)
      let eax = S.(field t "eax" uint32_t)
      let ebx = S.(field t "ebx" uint32_t)
      let ecx = S.(field t "ecx" uint32_t)
      let edx = S.(field t "edx" uint32_t)

      let () = S.seal t
    end

    module Kvm_cpuid2 = struct
      type kvm_cpuid2

      type t = kvm_cpuid2 Ctypes.structure

      let t : t S.typ = S.structure "kvm_cpuid2"

      let nent = S.(field t "nent" uint32_t)
      let padding = S.(field t "padding" uint32_t)
      (*let entries = S.(field t "entries" (ptr void))*)

      let () = S.seal t
    end

    module Kvm_pit_config = struct
      type kvm_pit_config

      type t = kvm_pit_config Ctypes.structure

      let t : t S.typ = S.structure "kvm_pit_config"

      let flags = S.(field t "flags" int32_t)

      let () = S.seal t
    end

    module Boot_params = struct
      type boot_params

      type t = boot_params Ctypes.structure

      let t : t S.typ = S.structure "boot_params"

      let () = S.seal t
    end


    module Limits = struct
      let shrt_max = S.(constant "SHRT_MAX" short)
    end

    module Kvm = struct
      let _KVM_CREATE_VM = S.(constant "KVM_CREATE_VM" int)

      let _KVM_SET_USER_MEMORY_REGION =
        S.(constant "KVM_SET_USER_MEMORY_REGION" int)

      let _KVM_CREATE_VCPU = S.(constant "KVM_CREATE_VCPU" int)

      let _KVM_GET_VCPU_MMAP_SIZE = S.(constant "KVM_GET_VCPU_MMAP_SIZE" int)

      let _KVM_GET_SREGS = S.(constant "KVM_GET_SREGS" int)

      let _KVM_SET_SREGS = S.(constant "KVM_SET_SREGS" int)

      let _KVM_GET_REGS = S.(constant "KVM_GET_REGS" int)

      let _KVM_SET_REGS = S.(constant "KVM_SET_REGS" int)

      let _KVM_RUN = S.(constant "KVM_RUN" int)

      let _KVM_GET_SUPPORTED_CPUID = S.(constant "KVM_GET_SUPPORTED_CPUID" int)

      let _KVM_CPUID_SIGNATURE = S.(constant "KVM_CPUID_SIGNATURE" int)

      let _KVM_CPUID_FEATURES = S.(constant "KVM_CPUID_FEATURES" int)

      let _KVM_SET_CPUID2 = S.(constant "KVM_SET_CPUID2" int)

      let _KVM_SET_TSS_ADDR = S.(constant "KVM_SET_TSS_ADDR" int)

      let _KVM_SET_IDENTITY_MAP_ADDR = S.(constant "KVM_SET_IDENTITY_MAP_ADDR" int)

      let _KVM_CREATE_IRQCHIP = S.(constant "KVM_CREATE_IRQCHIP" int)

      let _KVM_CREATE_PIT = S.(constant "KVM_CREATE_PIT" int)
      
      let _KVM_CREATE_PIT2 = S.(constant "KVM_CREATE_PIT2" int)
    end

    module Kvm_exit = struct
      let _KVM_EXIT_IO = S.(constant "KVM_EXIT_IO" int)

      let _KVM_EXIT_SHUTDOWN = S.(constant "KVM_EXIT_SHUTDOWN" int)
    end

    (*
#define KVM_EXIT_UNKNOWN          0
#define KVM_EXIT_EXCEPTION        1
#define KVM_EXIT_IO               2
#define KVM_EXIT_HYPERCALL        3
#define KVM_EXIT_DEBUG            4
#define KVM_EXIT_HLT              5
#define KVM_EXIT_MMIO             6
#define KVM_EXIT_IRQ_WINDOW_OPEN  7
#define KVM_EXIT_SHUTDOWN         8
#define KVM_EXIT_FAIL_ENTRY       9
#define KVM_EXIT_INTR             10
#define KVM_EXIT_SET_TPR          11
#define KVM_EXIT_TPR_ACCESS       12
#define KVM_EXIT_S390_SIEIC       13
#define KVM_EXIT_S390_RESET       14
#define KVM_EXIT_DCR              15
#define KVM_EXIT_NMI              16
#define KVM_EXIT_INTERNAL_ERROR   17
#define KVM_EXIT_OSI              18
#define KVM_EXIT_PAPR_HCALL	  19
#define KVM_EXIT_S390_UCONTROL	  20
*)
  end
