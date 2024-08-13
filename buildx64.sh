	mkdir Binaries
	mkdir Binaries/BootLoader
	mkdir Binaries/System
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -Us -CX -XXs -Twin64 -Cg BaseUnits/system.pas
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Twin64 -Cg BaseUnits/fpintres.pas
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Twin64 -Cg BaseUnits/sysinit.pas
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Xi -Twin64 -Cg -dCPUX86_64 -dcpux86_64 -FuBaseUnits -FEBinaries/BootLoader BootLoader/uefiloader.pas
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -Us -CX -Xs -Cg BaseUnits/system.pas
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -Xs -Cg BaseUnits/fpintres.pas
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -Xs -Cg BaseUnits/sysinit.pas
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -Xs -Cg BaseUnits/si_prc.pas
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -Xs -Xi -al -Cg -dCPUX86_64 -dcpux86_64 -FuBaseUnits -FEBinaries/BootLoader BootLoader/uefiloaderx64.pas
	objcopy -I pei-x86-64 -O efi-app-x86-64 Binaries/BootLoader/uefiloader.exe Binaries/BootLoader/bootx64.efi
	rm -rf BaseUnits/*.ppu BaseUnits/*.o Installer/*.o Installer/*.ppu BootLoader/*.o BootLoader/*.ppu
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -Us -CX -XXs -Cg BaseUnits/system.pas
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/fpintres.pas
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/sysinit.pas
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/si_prc.pas
	/home/tydq/source/compiler/ppcx64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -Xs -Xi -Cg -dCPUX86_64 -dcpux86_64 -FuBaseUnits -FEBinaries/System System/kernelmain.pas
	objcopy Binaries/System/kernelmain Binaries/System/kernelmain.elf
	rm -rf BaseUnits/*.ppu BaseUnits/*.o System/*.o System/*.ppu 
	dd if=/dev/zero of=Binaries/fat.img bs=512 count=131072
	/usr/sbin/mkfs.vfat -F 32 Binaries/fat.img
	mmd -i Binaries/fat.img ::/EFI
	mmd -i Binaries/fat.img ::/EFI/BOOT
	mmd -i Binaries/fat.img ::/EFI/SYSTEM
	mcopy -i Binaries/fat.img Binaries/BootLoader/*.efi ::/EFI/BOOT
	mcopy -i Binaries/fat.img Binaries/System/*.elf ::/EFI/SYSTEM
	mkdir Binaries/iso
	cp Binaries/fat.img Binaries/iso
	xorriso -as mkisofs -R -f -e fat.img -no-emul-boot -o Binaries/cdimagex64.iso Binaries/iso
	#rm -rf Binaries/BootLoader Binaries/System Binaries/fat.img Binaries/iso
