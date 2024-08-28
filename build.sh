	# ARCH is architecture,CROSSARCH(optional) is cross-compile architecture,CUSTOMBIN(optional) is your custom binutils path.
	ARCH=$(uname -m)
	CROSSARCH=$1
	CROSSBIN=$2
	if [ "$ARCH" = "x86_64" ]; then
	 CARCH="x64"
	 CARCHNAME="x86_64"
	 CARCHNAMEL="X86_64"
	 BITS="64"
	 CISONAME="x64"
	elif [ "$ARCH" = "aarch64" ]; then
	 CARCH="a64"
	 CARCHNAME="aarch64"
	 CARCHNAMEL="AARCH64"
	 BITS="64"
	 CISONAME="aa64"
	elif [ "$ARCH" = "riscv64" ]; then
	 CARCH="rv64"
	 CARCHNAME="riscv64"
	 CARCHNAMEL="RISCV64"
	 BITS="64"
	 CISONAME="riscv64"
	elif [ "$ARCH" = "loongarch64" ]; then
	 CARCH="loongarch64"
	 CARCHNAME="loongarch64"
	 CARCHNAMEL="LOONGARCH"
	 BITS="64"
	 CISONAME="loongarch64"
	elif [ "$ARCH" = "i386" ]; then
	 CARCH="386"
	 CARCHNAME="i386"
	 CARCHNAMEL="I386"
	 BITS="32"
	 CISONAME="ia32"
	elif [ "$ARCH" = "arm" ]; then
	 CARCH="arm"
	 CARCHNAME="arm"
	 CARCHNAMEL="ARM"
	 BITS="32"
	 CISONAME="arm"
	else
	 echo "Unsupported architecture "$ARCH
	 exit
	fi
	if [ "$CROSSARCH" = "x86_64" ]; then
	 CCARCH="x64"
	 CCARCHNAME="x86_64"
	 CCARCHNAMEL="X86_64"
	 BUNAME="-XPx86_64-linux-gnu-"
	 OCNAME="x86_64-linux-gnu-"
	 BITS="64"
	 CCISONAME="x64"
	elif [ "$CROSSARCH" = "aarch64" ]; then
	 CCARCH="a64"
	 CCARCHNAME="aarch64"
	 CCARCHNAMEL="AARCH64"
	 BUNAME="-XPaarch64-linux-gnu-"
	 OCNAME="aarch64-linux-gnu-"
	 BITS="64"
	 CCISONAME="aa64"
	elif [ "$CROSSARCH" = "riscv64" ]; then
	 CCARCH="rv64"
	 CCARCHNAME="riscv64"
	 CCARCHNAMEL="RISCV64"
	 BUNAME="-XPriscv64-linux-gnu-"
	 OCNAME="riscv64-linux-gnu-"
	 BITS="64"
	 CCISONAME="riscv64"
	elif [ "$CROSSARCH" = "loongarch64" ]; then
	 CCARCH="loongarch64"
	 CCARCHNAME="loongarch64"
	 CCARCHNAMEL="LOONGARCH"
	 BUNAME="-XPloongarch64-linux-gnu-"
	 OCNAME="loongarch64-linux-gnu-"
	 BITS="64"
	 CCISONAME="loongarch64"
	elif [ "$CROSSARCH" = "i386" ]; then
	 CCARCH="386"
	 CCARCHNAME="i386"
	 CCARCHNAMEL="I386"
	 BUNAME="-XPi386-linux-gnu-"
	 OCNAME="i386-linux-gnu-"
	 BITS="32"
	 CCISONAME="ia32"
	elif [ "$CROSSARCH" = "arm" ]; then
	 CCARCH="arm"
	 CCARCHNAME="arm"
	 CCARCHNAMEL="ARM"
	 BUNAME="-XParm-linux-gnu-"
	 OCNAME="arm-linux-gnu-"
	 BITS="32"
	 CCISONAME="arm"
	else
	 CCARCH=$CARCH
	 CCARCHNAME=$CARCHNAME
	 CCARCHNAMEL=$CARCHNAMEL
	 BUNAME=""
	 OCNAME=""
	 CCISONAME=$CISONAME
	fi
	if [ "$CUSTOMBIN" != "" ]; then
	 BUNAME="-XP"$CUSTOMBIN
	fi
 	mkdir Binaries
	mkdir Binaries/BootLoader
	mkdir Binaries/System
	/home/tydq/source/compiler/ppc$CCARCH -n -O4 -Si $BUNAME -Sc -Sg -Xd -Ur -Us -CX -XXs -Cg BaseUnits/system.pas
	/home/tydq/source/compiler/ppc$CCARCH -n -O4 -Si $BUNAME -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/fpintres.pas
	/home/tydq/source/compiler/ppc$CCARCH -n -O4 -Si $BUNAME -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/sysinit.pas
	/home/tydq/source/compiler/ppc$CCARCH -n -O4 -Si $BUNAME -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/si_prc.pas
	if [ "$CCARCHNAME" = "arm" ]||[ "$CCARCHNAME" = "aarch64" ]; then
	/home/tydq/source/compiler/ppc$CCARCH -n -O4 -Si $BUNAME -Sc -Sg -Xd -Ur -CX -XXs -Cg -FUBinaries/BootLoader BaseUnits/prt0.pas
	fi
	/home/tydq/source/compiler/ppc$CCARCH -n -O4 -Si $BUNAME -Sc -Sg -Xd -Ur -CX -XX -Xi -Cg -al -k-static -k-nostdlib -k-znoexecstack -k-znow -k-pie -k--no-dynamic-linker -dCPU$CCARCHNAMEL -dcpu$CCARCHNAME -dCPU$BITS -FuBaseUnits -FEBinaries/BootLoader BootLoader/uefiloader.pas -oBinaries/BootLoader/uefiloader.elf
	rm -rf Utility/elf2efi
	/home/tydq/source/compiler/ppc$CARCH -n -O4 -Si -Sc -Sg -Xd -Ur -CX -XXs -Xi -Fu/home/tydq/source/compiler/x86_64/units/$CARCHNAME-linux -Fu/home/tydq/source/rtl/units/$CARCHNAME-linux -dcpu$BITS -Cg Utility/elf2efi.pas
	rm -rf Utility/*.o Utility/*.ppu
	Utility/elf2efi "Binaries/BootLoader/uefiloader.elf" Custom "Binaries/BootLoader/boot"$CCISONAME".efi"
	rm -rf BaseUnits/*.ppu BaseUnits/*.o BaseUnits/*.res BaseUnits/*.sh BootLoader/*.ppu BootLoader/*.o BootLoader/*.res BootLoader/*.sh
	/home/tydq/source/compiler/ppc$CCARCH -n -O4 -Si $BUNAME -Sc -Sg -Xd -Ur -Us -CX -XXs -Cg BaseUnits/system.pas
	/home/tydq/source/compiler/ppc$CCARCH -n -O4 -Si $BUNAME -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/fpintres.pas
	/home/tydq/source/compiler/ppc$CCARCH -n -O4 -Si $BUNAME -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/sysinit.pas
	/home/tydq/source/compiler/ppc$CCARCH -n -O4 -Si $BUNAME -Sc -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/si_prc.pas
	if [ "$CCARCHNAME" = "arm" ]||[ "$CCARCHNAME" = "aarch64" ]; then
	/home/tydq/source/compiler/ppc$CCARCH -n -O4 -Si $BUNAME -Sc -Sg -Xd -Ur -CX -XXs -Cg -FUBinaries/System BaseUnits/prt0.pas
	fi
	/home/tydq/source/compiler/ppc$CCARCH -n -O4 -Si $BUNAME -Sc -Sg -Xd -Ur -CX -XXs -Xi -Cg -k-static -k-nostdlib -k-znoexecstack -k-znodefaultlib -k-znow -k-pie -k--no-dynamic-linker -dCPU$CCARCHNAMEL -dcpu$CCARCHNAME -dCPU$BITS -FuBaseUnits -FEBinaries/System System/kernelmain.pas -oBinaries/System/kernelmain.elf
	rm -rf BaseUnits/*.ppu BaseUnits/*.o BaseUnits/*.res BaseUnits/*.sh System/*.ppu System/*.o System/*.res System/*.sh 
	dd if=/dev/zero of=Binaries/fat.img bs=512 count=131072
	/usr/sbin/mkfs.vfat -F 32 Binaries/fat.img
	mmd -i Binaries/fat.img ::/EFI
	mmd -i Binaries/fat.img ::/EFI/BOOT
	mmd -i Binaries/fat.img ::/EFI/SYSTEM
	mcopy -i Binaries/fat.img Binaries/BootLoader/*.efi ::/EFI/BOOT/
	mcopy -i Binaries/fat.img Binaries/System/*.elf ::/EFI/SYSTEM/
	mkdir Binaries/iso
	cp Binaries/fat.img Binaries/iso
	xorriso -as mkisofs -R -f -e fat.img -no-emul-boot -o Binaries/cdimage$CCISONAME.iso Binaries/iso
	rm -rf Binaries/System Binaries/fat.img Binaries/iso
