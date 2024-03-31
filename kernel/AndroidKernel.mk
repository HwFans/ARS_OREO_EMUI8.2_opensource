#Android makefile to build kernel as a part of Android Build
PERL		= perl

kernel_path := kernel/msm-4.4

KERNEL_TARGET := $(strip $(INSTALLED_KERNEL_TARGET))
ifeq ($(KERNEL_TARGET),)
INSTALLED_KERNEL_TARGET := $(PRODUCT_OUT)/kernel
endif

TARGET_KERNEL_MAKE_ENV := $(strip $(TARGET_KERNEL_MAKE_ENV))
ifeq ($(TARGET_KERNEL_MAKE_ENV),)
KERNEL_MAKE_ENV :=
else
KERNEL_MAKE_ENV := $(TARGET_KERNEL_MAKE_ENV)
endif

TARGET_KERNEL_ARCH := $(strip $(TARGET_KERNEL_ARCH))
ifeq ($(TARGET_KERNEL_ARCH),)
KERNEL_ARCH := arm
else
KERNEL_ARCH := $(TARGET_KERNEL_ARCH)
endif

TARGET_KERNEL_HEADER_ARCH := $(strip $(TARGET_KERNEL_HEADER_ARCH))
ifeq ($(TARGET_KERNEL_HEADER_ARCH),)
KERNEL_HEADER_ARCH := $(KERNEL_ARCH)
else
$(warning Forcing kernel header generation only for '$(TARGET_KERNEL_HEADER_ARCH)')
KERNEL_HEADER_ARCH := $(TARGET_KERNEL_HEADER_ARCH)
endif

KERNEL_HEADER_DEFCONFIG := $(strip $(KERNEL_HEADER_DEFCONFIG))
ifeq ($(KERNEL_HEADER_DEFCONFIG),)
KERNEL_HEADER_DEFCONFIG := $(KERNEL_DEFCONFIG)
endif

# Force 32-bit binder IPC for 64bit kernel with 32bit userspace
ifeq ($(KERNEL_ARCH),arm64)
ifeq ($(TARGET_ARCH),arm)
KERNEL_CONFIG_OVERRIDE := CONFIG_ANDROID_BINDER_IPC_32BIT=y
endif
endif

# open ptrace before FINAL_RELEASE, and close it after release
ifneq ($(FINAL_RELEASE),true)
KERNEL_CONFIG_OVERRIDE += CONFIG_HUAWEI_PTRACE_POKE_ON=y
endif

ifneq ($(FINAL_RELEASE),true)
KERNEL_CONFIG_OVERRIDE += CONFIG_HW_ROOT_SCAN_ENG_DEBUG=y
endif

ifeq ($(FINAL_RELEASE),true)
KERNEL_CONFIG_OVERRIDE += CONFIG_LOCALVERSION="-perf"
KERNEL_CONFIG_OVERRIDE += CONFIG_CMA_SIZE_MBYTES=32
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_DEBUG_LAR_UNLOCK=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_CORE_HANG_DETECT=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_DCC=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CORESIGHT_DBGUI=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CORESIGHT_ETMV4=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CORESIGHT_REMOTE_ETM=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DYNAMIC_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_PAGE_OWNER=n
KERNEL_CONFIG_OVERRIDE += CONFIG_SLUB_DEBUG_PANIC_ON=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_OBJECTS=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_OBJECTS_FREE=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_OBJECTS_TIMERS=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_OBJECTS_WORK=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=n
KERNEL_CONFIG_OVERRIDE += CONFIG_SLUB_DEBUG_ON=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_KMEMLEAK=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_STACK_USAGE=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_MEMORY_INIT=n
KERNEL_CONFIG_OVERRIDE += CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=n
KERNEL_CONFIG_OVERRIDE += CONFIG_PANIC_ON_SCHED_BUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_PANIC_ON_RT_THROTTLING=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_SPINLOCK=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_LIST=n
KERNEL_CONFIG_OVERRIDE += CONFIG_FAULT_INJECTION=n
KERNEL_CONFIG_OVERRIDE += CONFIG_FAIL_PAGE_ALLOC=n
KERNEL_CONFIG_OVERRIDE += CONFIG_UFS_FAULT_INJECTION=n
KERNEL_CONFIG_OVERRIDE += CONFIG_FAULT_INJECTION_DEBUG_FS=n
KERNEL_CONFIG_OVERRIDE += CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=n
KERNEL_CONFIG_OVERRIDE += CONFIG_BLK_DEV_IO_TRACE=n
KERNEL_CONFIG_OVERRIDE += CONFIG_PANIC_ON_DATA_CORRUPTION=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HUAWEI_KERNEL_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_PAGEALLOC=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_VMALLOC=n
KERNEL_CONFIG_OVERRIDE += CONFIG_INPUT_MINI_BUGREPORT_TRIGGER=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HUAWEI_BOOT_TIME=y
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_MUTEXES=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_RTB=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_RTB_SEPARATE_CPUS=n
KERNEL_CONFIG_OVERRIDE += CONFIG_FREE_PAGES_RDONLY=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_LL=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEVMEM=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEVKMEM=n
KERNEL_CONFIG_OVERRIDE += CONFIG_LOWMEM_DBG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CPU_STRESS_TEST=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_RT_MUTEXES=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_LOCK_ALLOC=n
KERNEL_CONFIG_OVERRIDE += CONFIG_LOCKDEP=n
KERNEL_CONFIG_OVERRIDE += CONFIG_LOCK_STAT=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HUAWEI_IO_TRACING=n
KERNEL_CONFIG_OVERRIDE += CONFIG_PROVE_LOCKING=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MINIDUMP_TRACE_INFO=n
KERNEL_CONFIG_OVERRIDE += CONFIG_SQUASHFS=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HUWEI_LMK_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_ATOMIC_SLEEP=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_LOCKDEP=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_SPINLOCK_PANIC_ON_BUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_SPINLOCK_BITE_ON_BUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_LOCKUP_DETECTOR=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_OCMEM_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_OCMEM_NONSECURE=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_XPU_ERR_FATAL=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_TEST_PACMAN=n
KERNEL_CONFIG_OVERRIDE += CONFIG_ALLOC_BUFFERS_IN_4K_CHUNKS=n
KERNEL_CONFIG_OVERRIDE += CONFIG_PAGE_POISONING=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DEBUG_PREEMPT=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HANDSET_SYSRQ_RESET=n
KERNEL_CONFIG_OVERRIDE += CONFIG_RELAY=n
KERNEL_CONFIG_OVERRIDE += CONFIG_SLUB_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_RCU_CPU_STALL_VERBOSE=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CORESIGHT_ETM=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HUAWEI_CFI_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HW_KHARDEN_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HW_MEMORY_MONITOR=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HISI_SLOW_PATH_COUNT=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_COMMON_LOG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_USB_NET_SMSC75XX=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HW_MMC_TEST=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_JTAGV8=n
KERNEL_CONFIG_OVERRIDE += CONFIG_FORCE_PAGES=n
KERNEL_CONFIG_OVERRIDE += CONFIG_PM_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_SPI_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_JTAGV8=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CORESIGHT_FUSE=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CORESIGHT_TMC=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CORESIGHT_TPIU=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CORESIGHT_FUNNEL=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CORESIGHT_REPLICATOR=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_SMD_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MM_DEBUG=n
# KERNEL_CONFIG_OVERRIDE += CONFIG_HUAWEI_CFI_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HUAWEI_SELINUX_DSM_DEBUG=n
# KERNEL_CONFIG_OVERRIDE += CONFIG_HW_MEMORY_MONITOR=n
# KERNEL_CONFIG_OVERRIDE += CONFIG_HISI_SLOW_PATH_COUNT=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HUAWEI_LMK_DBG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CGROUP_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_IOMMU_DEBUG_TRACKING=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HAVE_DEBUG_KMEMLEAK=n
KERNEL_CONFIG_OVERRIDE += CONFIG_SCHED_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_SYSRQ_SCHED_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CMA_DEBUGFS=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HUAWEI_LMK_DBG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_IOMMU_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_IOSCHED_NOOP=n
KERNEL_CONFIG_OVERRIDE += CONFIG_IOSCHED_DEADLINE=n
KERNEL_CONFIG_OVERRIDE += CONFIG_FUNCTION_GRAPH_TRACER=n
KERNEL_CONFIG_OVERRIDE += CONFIG_IRQSOFF_TRACER=n
KERNEL_CONFIG_OVERRIDE += CONFIG_PREEMPT_TRACER=n
KERNEL_CONFIG_OVERRIDE += CONFIG_DYNAMIC_FTRACE=n
KERNEL_CONFIG_OVERRIDE += CONFIG_FTRACE_MCOUNT_RECORD=n
KERNEL_CONFIG_OVERRIDE += CONFIG_QCOM_RTB=n
KERNEL_CONFIG_OVERRIDE += CONFIG_HUAWEI_VIRT_TO_PHYS=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSM_CAMERA_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MSMB_CAMERA_DEBUG=n
KERNEL_CONFIG_OVERRIDE += CONFIG_CLEANCACHE=n
KERNEL_CONFIG_OVERRIDE += CONFIG_SCHED_STACK_END_CHECK=n
KERNEL_CONFIG_OVERRIDE += CONFIG_MEMTEST=n
KERNEL_CONFIG_OVERRIDE += CONFIG_L2TP_DEBUGFS=n
KERNEL_CONFIG_OVERRIDE += CONFIG_IOMMU_IO_PGTABLE_FAST_SELFTEST=n
KERNEL_CONFIG_OVERRIDE += CONFIG_PAGE_EXTENSION=n
KERNEL_CONFIG_OVERRIDE += CONFIG_QCOM_CPUSS_DUMP=n
KERNEL_CONFIG_OVERRIDE += CONFIG_ARM64_PTDUMP=n
KERNEL_CONFIG_OVERRIDE += CONFIG_XZ_DEC=n
KERNEL_CONFIG_OVERRIDE += CONFIG_XZ_DEC_X86=n
KERNEL_CONFIG_OVERRIDE += CONFIG_XZ_DEC_POWERPC=n
KERNEL_CONFIG_OVERRIDE += CONFIG_XZ_DEC_IA64=n
KERNEL_CONFIG_OVERRIDE += CONFIG_XZ_DEC_ARM=n
KERNEL_CONFIG_OVERRIDE += CONFIG_XZ_DEC_ARMTHUMB=n
KERNEL_CONFIG_OVERRIDE += CONFIG_XZ_DEC_SPARC=n
KERNEL_CONFIG_OVERRIDE += CONFIG_XZ_DEC_BCJ=n
KERNEL_CONFIG_OVERRIDE += CONFIG_REGMAP_ALLOW_WRITE_DEBUGFS=n
KERNEL_CONFIG_OVERRIDE += CONFIG_PNP_DEBUG_MESSAGES=n
KERNEL_CONFIG_OVERRIDE += CONFIG_PROC_IO_INFO=n
endif

ifeq ($(KASAN_BUILD),true)
KERNEL_CONFIG_OVERRIDE += CONFIG_KASAN=y
KERNEL_CONFIG_OVERRIDE += CONFIG_TEST_KASAN=m
endif

ifeq ($(strip $(kcov)), true)
KERNEL_CONFIG_OVERRIDE += CONFIG_KCOV=y
endif

TARGET_KERNEL_CROSS_COMPILE_PREFIX := $(strip $(TARGET_KERNEL_CROSS_COMPILE_PREFIX))
ifeq ($(TARGET_KERNEL_CROSS_COMPILE_PREFIX),)
KERNEL_CROSS_COMPILE := arm-eabi-
else
KERNEL_CROSS_COMPILE := $(TARGET_KERNEL_CROSS_COMPILE_PREFIX)
endif
CROSS_COMPILE_PREFIX := $(KERNEL_CROSS_COMPILE)

ifeq ($(TARGET_PREBUILT_KERNEL),)

KERNEL_GCC_NOANDROID_CHK := $(shell (echo "int main() {return 0;}" | $(KERNEL_CROSS_COMPILE)gcc -E -mno-android - > /dev/null 2>&1 ; echo $$?))
ifeq ($(strip $(KERNEL_GCC_NOANDROID_CHK)),0)
KERNEL_CFLAGS := KCFLAGS=-mno-android
endif

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
ifeq ($(TARGET_KERNEL_VERSION),)
    TARGET_KERNEL_VERSION := 4.4
endif
TARGET_KERNEL := msm-$(TARGET_KERNEL_VERSION)
ifeq ($(TARGET_KERNEL),$(current_dir))
    # New style, kernel/msm-version
    BUILD_ROOT_LOC := ../../
    TARGET_KERNEL_SOURCE := kernel/$(TARGET_KERNEL)
    KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/kernel/$(TARGET_KERNEL)
    KERNEL_SYMLINK := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
    KERNEL_USR := $(KERNEL_SYMLINK)/usr
else
    # Legacy style, kernel source directly under kernel
    KERNEL_LEGACY_DIR := true
    BUILD_ROOT_LOC := ../
    TARGET_KERNEL_SOURCE := kernel
    KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
endif

KERNEL_CONFIG := $(KERNEL_OUT)/.config

ifeq ($(KERNEL_DEFCONFIG)$(wildcard $(KERNEL_CONFIG)),)
$(error Kernel configuration not defined, cannot build kernel)
else

ifeq ($(TARGET_USES_UNCOMPRESSED_KERNEL),true)
$(info Using uncompressed kernel)
TARGET_PREBUILT_INT_KERNEL := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/Image
else
ifeq ($(KERNEL_ARCH),arm64)
TARGET_PREBUILT_INT_KERNEL := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/Image.gz
else
TARGET_PREBUILT_INT_KERNEL := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/zImage
endif
endif

ifeq ($(TARGET_KERNEL_APPEND_DTB), true)
$(info Using appended DTB)
TARGET_PREBUILT_INT_KERNEL := $(TARGET_PREBUILT_INT_KERNEL)-dtb
endif

KERNEL_HEADERS_INSTALL := $(KERNEL_OUT)/usr
KERNEL_MODULES_INSTALL ?= system
KERNEL_MODULES_OUT ?= $(PRODUCT_OUT)/$(KERNEL_MODULES_INSTALL)/lib/modules

TARGET_PREBUILT_KERNEL := $(TARGET_PREBUILT_INT_KERNEL)

define mv-modules
mdpath=`find $(KERNEL_MODULES_OUT) -type f -name modules.dep`;\
if [ "$$mdpath" != "" ];then\
mpath=`dirname $$mdpath`;\
ko=`find $$mpath/kernel -type f -name *.ko`;\
for i in $$ko; do mv $$i $(KERNEL_MODULES_OUT)/; done;\
fi
endef

define clean-module-folder
mdpath=`find $(KERNEL_MODULES_OUT) -type f -name modules.dep`;\
if [ "$$mdpath" != "" ];then\
mpath=`dirname $$mdpath`; rm -rf $$mpath;\
fi
endef

ifneq ($(KERNEL_LEGACY_DIR),true)
$(KERNEL_USR): $(KERNEL_HEADERS_INSTALL)
	rm -rf $(KERNEL_SYMLINK)
	ln -s kernel/$(TARGET_KERNEL) $(KERNEL_SYMLINK)

$(TARGET_PREBUILT_INT_KERNEL): $(KERNEL_USR)
endif

$(KERNEL_OUT):
	mkdir -p $(KERNEL_OUT)

$(KERNEL_CONFIG): $(KERNEL_OUT)
	$(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) $(KERNEL_MAKE_ENV) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) $(KERNEL_DEFCONFIG)
	$(hide) if [ ! -z "$(KERNEL_CONFIG_OVERRIDE)" ]; then \
			echo "Overriding kernel config with '$(KERNEL_CONFIG_OVERRIDE)'"; \
			echo $(KERNEL_CONFIG_OVERRIDE) >> $(KERNEL_OUT)/.config; \
			$(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) $(KERNEL_MAKE_ENV) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) oldconfig; fi

$(TARGET_PREBUILT_INT_KERNEL): $(KERNEL_OUT) $(KERNEL_HEADERS_INSTALL)
	$(hide) echo "Building kernel..."
	$(hide) rm -rf $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts
	$(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) $(KERNEL_MAKE_ENV) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) $(KERNEL_CFLAGS)
	$(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) $(KERNEL_MAKE_ENV) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) $(KERNEL_CFLAGS) modules
	$(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) INSTALL_MOD_PATH=$(BUILD_ROOT_LOC)../$(KERNEL_MODULES_INSTALL) INSTALL_MOD_STRIP=1 $(KERNEL_MAKE_ENV) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) modules_install
	$(mv-modules)
	$(clean-module-folder)

$(KERNEL_HEADERS_INSTALL): $(KERNEL_OUT)
	$(hide) if [ ! -z "$(KERNEL_HEADER_DEFCONFIG)" ]; then \
			rm -f $(BUILD_ROOT_LOC)$(KERNEL_CONFIG); \
			$(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) $(KERNEL_MAKE_ENV) ARCH=$(KERNEL_HEADER_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) $(KERNEL_HEADER_DEFCONFIG); \
			$(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) $(KERNEL_MAKE_ENV) ARCH=$(KERNEL_HEADER_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) headers_install; fi
	$(hide) if [ "$(KERNEL_HEADER_DEFCONFIG)" != "$(KERNEL_DEFCONFIG)" ]; then \
			echo "Used a different defconfig for header generation"; \
			rm -f $(BUILD_ROOT_LOC)$(KERNEL_CONFIG); \
			$(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) $(KERNEL_MAKE_ENV) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) $(KERNEL_DEFCONFIG); fi
	$(hide) if [ ! -z "$(KERNEL_CONFIG_OVERRIDE)" ]; then \
			echo "Overriding kernel config with '$(KERNEL_CONFIG_OVERRIDE)'"; \
			for CONFIG_OVERRIDE in $(KERNEL_CONFIG_OVERRIDE); do echo $$CONFIG_OVERRIDE >> $(KERNEL_OUT)/.config; done; \
			$(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) $(KERNEL_MAKE_ENV) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) oldconfig; fi

kerneltags: $(KERNEL_OUT) $(KERNEL_CONFIG)
	$(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) $(KERNEL_MAKE_ENV) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) tags

kernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) $(KERNEL_MAKE_ENV) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) menuconfig
	env KCONFIG_NOTIMESTAMP=true \
	     $(MAKE) -C $(TARGET_KERNEL_SOURCE) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) $(KERNEL_MAKE_ENV) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) savedefconfig
	cp $(KERNEL_OUT)/defconfig $(TARGET_KERNEL_SOURCE)/arch/$(KERNEL_ARCH)/configs/$(KERNEL_DEFCONFIG)

endif
endif

ifeq ($(KP_MODULE), false)
KP_PARA = -s ${kernel_path}
else
ifeq ($(KP_BUILD), false)
KP_PARA = -s ${kernel_path} -m ${KP_MODULE}
else
KP_PARA = -b ${KP_BUILD} -m ${KP_MODULE}
endif
endif
kernel_patch_build:
	rm -rf $(kernel_path)/include/config
	rm -rf $(kernel_path)/include/generated
ifeq ($(KP_BUILD), true)
	$(MAKE) -C $(kernel_path) O=$(BUILD_ROOT_LOC)$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE)
endif
	vendor/opensource/patch_tool/kernel_patch_build ${KP_PARA} -v ${KP_VMLINUX} -c ${KP_CONFIG} -r ${KP_UTSRELEASE_H} -n ${KP_PATCH_NAME} ${KP_PATCH}
	mv -f $(ANDROID_BUILD_TOP)/$(KP_PATCH_NAME).ko $(ANDROID_BUILD_TOP)/out/target/product/$(TARGET_PRODUCT)/
	$(ANDROID_BUILD_TOP)/build/tools/signkernel/sign-kernel.sh $(ANDROID_BUILD_TOP)/out/target/product/$(TARGET_PRODUCT)/$(KP_PATCH_NAME).ko
