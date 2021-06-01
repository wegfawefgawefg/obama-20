kern_sources := $(shell find src/impl/kernel -name *.c)
kern_objects := $(patsubst src/impl/kernel/%.c, build/kernel/%.o, $(kern_sources))

c_sources := $(shell find src/impl/x86_64 -name *.c)
c_objects := $(patsubst src/impl/x86_64/%.c, build/x86_64/%.o, $(c_sources))

asm_sources := $(shell find src/impl/x86_64 -name *.asm)
asm_objects := $(patsubst src/impl/x86_64/%.asm, build/x86_64/%.o, $(asm_sources))

objects := $(c_objects) $(asm_objects)

$(kern_objects): build/kernel/%.o : src/impl/kernel/%.c
	mkdir -p $(dir $@) && \
	x86_64-elf-gcc -c -I src/intf -ffreestanding $(patsubst build/kernel/%.o, src/impl/kernel/%.c, $@) -o $@

$(c_objects): build/x86_64/%.o : src/impl/x86_64/%.c
	mkdir -p $(dir $@) && \
	x86_64-elf-gcc -c -I src/intf -ffreestanding $(patsubst build/x86_64/%.o, src/impl/x86_64/%.c, $@) -o $@

$(asm_objects): build/x86_64/%.o : src/impl/x86_64/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/x86_64/%.o, src/impl/x86_64/%.asm, $@) -o $@

.PHONY: build-x86_64
build-x86_64: $(kern_objects) $(objects)
	mkdir -p dist/x86_64 && \
	x86_64-elf-ld -n -o dist/x86_64/kernel.bin -T targets/x86_64/linker.ld $(kern_objects) $(objects) && \
	cp dist/x86_64/kernel.bin targets/x86_64/iso/boot/kernel.bin && \
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86_64/kernel.iso targets/x86_64/iso
