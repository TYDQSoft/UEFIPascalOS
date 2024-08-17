        mkdir Binaries
	mkdir Binaries/BootLoader
	mkdir Binaries/System
	/home/tydq/source/compiler/ppcrv64 -n -O4 -Si -Sc -Sg -Xd -Ur -Us -CX -XXs -Cg BaseUnits/system.pas
	/home/tydq/source/compiler/ppcrv64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/fpintres.pas
	/home/tydq/source/compiler/ppcrv64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/sysinit.pas
	/home/tydq/source/compiler/ppcrv64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/si_prc.pas
	/home/tydq/source/compiler/ppcrv64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Xi -Cg -k-nostdlib -dCPURISCV64 -dcpuriscv64 -dCPU64 -FuBaseUnits -FEBinaries/BootLoader BootLoader/uefiloader.pas
	rm -rf Utility/elf2efi
	/home/tydq/source/compiler/ppcrv64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Xi -Fu/home/tydq/source/compiler/x86_64/units/x86_64-linux -Fu/home/tydq/source/rtl/units/x86_64-linux -Cg Utility/elf2efi.pas
	rm -rf Utility/*.o Utility/*.ppu
	./Utility/elf2efi "Binaries/BootLoader/uefiloader" Custom "Binaries/BootLoader/bootriscv64.efi"
	rm -rf BaseUnits/*.ppu BaseUnits/*.o Installer/*.o Installer/*.ppu BootLoader/*.o BootLoader/*.ppu
	/home/tydq/source/compiler/ppcrv64 -n -O4 -Si -Sc -Sg -Xd -Ur -Us -CX -XXs -Cg BaseUnits/system.pas
	/home/tydq/source/compiler/ppcrv64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/fpintres.pas
	/home/tydq/source/compiler/ppcrv64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/sysinit.pas
	/home/tydq/source/compiler/ppcrv64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/si_prc.pas
	/home/tydq/source/compiler/ppcrv64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Xi -Cg -k-nostdlib -dCPURISCV64 -dcpuriscv64 -FuBaseUnits -FEBinaries/System System/kernelmain.pas
	objcopy Binaries/System/kernelmain Binaries/System/kernelmain.elf
	rm -rf BaseUnits/*.ppu BaseUnits/*.o System/*.o System/*.ppu 
	dd if=/dev/zero of=Binaries/fat.img bs=512 count=131072
	/usr/sbin/mkfs.vfat -F 32 Binaries/fat.img
	mmd -i Binaries/fat.img ::/EFI
	mmd -i Binaries/fat.img ::/EFI/BOOT
	mmd -i Binaries/fat.img ::/EFI/SYSTEM
	mcopy -i Binaries/fat.img Binaries/BootLoader/*.efi ::/EFI/BOOT/bootrv64.efi
	mcopy -i Binaries/fat.img Binaries/System/*.elf ::/EFI/SYSTEM
	mkdir Binaries/iso
	cp Binaries/fat.img Binaries/iso
	xorriso -as mkisofs -R -f -e fat.img -no-emul-boot -o Binaries/cdimagerv64.iso Binaries/iso
	rm -rf Binaries/BootLoader Binaries/System Binaries/fat.img Binaries/iso
