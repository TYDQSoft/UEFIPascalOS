	mkdir Binaries
	mkdir Binaries/Installer
	mkdir Binaries/BootLoader
	mkdir Binaries/System
	/home/tydq/source/compiler/ppca64 -n -O4 -Si -Sc -Sg -Xd -Ur -Us -CX -XXs -Twin64 -Cg BaseUnits/system.pas
	/home/tydq/source/compiler/ppca64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Twin64 -Cg BaseUnits/fpintres.pas
	/home/tydq/source/compiler/ppca64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Twin64 -Cg BaseUnits/sysinit.pas
	/home/tydq/source/compiler/ppca64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Xi -Twin64 -Cg -FuBaseUnits -FEBinaries/Installer Installer/uefiinstaller.pas
	/home/tydq/source/compiler/ppca64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Xi -Twin64 -Cg -FuBaseUnits -FEBinaries/BootLoader BootLoader/uefiloader.pas
	objcopy -I pei-x86-64 -O efi-app-x86_64 Binaries/Installer/uefiinstaller.dll Binaries/Installer/bootaa64.efi
	objcopy -I pei-x86-64 -O efi-app-x86_64 Binaries/BootLoader/uefiloader.dll Binaries/BootLoader/bootaa64.efi
	rm -rf BaseUnits/*.ppu BaseUnits/*.o Installer/*.o Installer/*.ppu BootLoader/*.o BootLoader/*.ppu
	/home/tydq/source/compiler/ppca64 -n -O4 -Si -Sc -Sg -Xd -Ur -Us -CX -Xs -Cg BaseUnits/system.pas
	/home/tydq/source/compiler/ppca64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -Xs -Cg BaseUnits/fpintres.pas
	/home/tydq/source/compiler/ppca64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -Xs -Cg BaseUnits/sysinit.pas
	/home/tydq/source/compiler/ppca64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -Xs -Cg BaseUnits/si_prc.pas
	/home/tydq/source/compiler/ppca64 -n -O4 -Si -Sc -Sg -Xd -Ur -CX -Xs -Xi -Cg -FuBaseUnits -FEBinaries/System System/kernelmain.pas
	objcopy Binaries/System/kernelmain Binaries/System/kernelmain.elf
	rm -rf BaseUnits/*.ppu BaseUnits/*.o System/*.o System/*.ppu 
	dd if=/dev/zero of=Binaries/fat.img bs=512 count=131072
	/usr/sbin/mkfs.vfat -F 32 Binaries/fat.img
	mmd -i Binaries/fat.img ::/EFI
	mmd -i Binaries/fat.img ::/EFI/BOOT
	mmd -i Binaries/fat.img ::/EFI/SETUP
	mmd -i Binaries/fat.img ::/EFI/SYSTEM
	mcopy -i Binaries/fat.img Binaries/Installer/*.efi ::/EFI/BOOT
	mcopy -i Binaries/fat.img Binaries/BootLoader/*.efi ::/EFI/SETUP
	mcopy -i Binaries/fat.img Binaries/System/*.elf ::/EFI/SYSTEM
	mkdir Binaries/iso
	cp Binaries/fat.img Binaries/iso
	xorriso -as mkisofs -R -f -e fat.img -no-emul-boot -o Binaries/cdimageaa64.iso Binaries/iso
	rm -rf Binaries/Installer Binaries/BootLoader Binaries/System Binaries/fat.img Binaries/iso
