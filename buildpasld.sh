	# ARCH is architecture,CROSSARCH(optional) is cross-compile architecture,CUSTOMBIN(optional) is your custom binutils path.
	ARCH=$(uname -m)
	CROSSARCH=$1
	CUSTOMBIN=$2
	if [ "$ARCH" = "x86_64" ]; then
	 CARCH="x64"
	 CARCHNAME="x86_64"
	 CARCHNAMEL="X86_64"
	 BITS="64"
	 CISONAME="x64"
	 CISONAMEL="X64"
	elif [ "$ARCH" = "aarch64" ]; then
	 CARCH="a64"
	 CARCHNAME="aarch64"
	 CARCHNAMEL="AARCH64"
	 BITS="64"
	 CISONAME="aa64"
	 CISONAMEL="AA64"
	elif [ "$ARCH" = "riscv64" ]; then
	 CARCH="rv64"
	 CARCHNAME="riscv64"
	 CARCHNAMEL="RISCV64"
	 BITS="64"
	 CISONAME="riscv64"
	 CISONAMEL="RISCV64"
	elif [ "$ARCH" = "loongarch64" ]; then
	 CARCH="loongarch64"
	 CARCHNAME="loongarch64"
	 CARCHNAMEL="LOONGARCH"
	 BITS="64"
	 CISONAME="loongarch64"
	 CISONAMEL="LOONGARCH64"
	elif [ "$ARCH" = "i386" ]; then
	 CARCH="386"
	 CARCHNAME="i386"
	 CARCHNAMEL="I386"
	 BITS="32"
	 CISONAME="ia32"
	 CISONAMEL="IA32"
	elif [ "$ARCH" = "arm" ]; then
	 CARCH="arm"
	 CARCHNAME="arm"
	 CARCHNAMEL="ARM"
	 BITS="32"
	 CISONAME="arm"
	 CISONAMEL="ARM"
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
	 CCISONAMEL="X64"
	elif [ "$CROSSARCH" = "aarch64" ]; then
	 CCARCH="a64"
	 CCARCHNAME="aarch64"
	 CCARCHNAMEL="AARCH64"
	 BUNAME="-XPaarch64-linux-gnu-"
	 OCNAME="aarch64-linux-gnu-"
	 BITS="64"
	 CCISONAME="aa64"
	 CCISONAMEL="AA64"
	elif [ "$CROSSARCH" = "riscv64" ]; then
	 CCARCH="rv64"
	 CCARCHNAME="riscv64"
	 CCARCHNAMEL="RISCV64"
	 BUNAME="-XPriscv64-linux-gnu-"
	 OCNAME="riscv64-linux-gnu-"
	 BITS="64"
	 CCISONAME="riscv64"
	 CCISONAMEL="RISCV64"
	elif [ "$CROSSARCH" = "loongarch64" ]; then
	 CCARCH="loongarch64"
	 CCARCHNAME="loongarch64"
	 CCARCHNAMEL="LOONGARCH"
	 BUNAME="-XPloongarch64-linux-gnu-"
	 OCNAME="loongarch64-linux-gnu-"
	 BITS="64"
	 CCISONAME="loongarch64"
	 CCISONAMEL="LOONGARCH64" 
	elif [ "$CROSSARCH" = "i386" ]; then
	 CCARCH="386"
	 CCARCHNAME="i386"
	 CCARCHNAMEL="I386"
	 BUNAME="-XPi386-linux-gnu-"
	 OCNAME="i386-linux-gnu-"
	 BITS="32"
	 CCISONAME="ia32"
	 CCISONAMEL="IA32"
	elif [ "$CROSSARCH" = "arm" ]; then
	 CCARCH="arm"
	 CCARCHNAME="arm"
	 CCARCHNAMEL="ARM"
	 BUNAME="-XParm-linux-gnu-"
	 OCNAME="arm-linux-gnu-"
	 BITS="32"
	 CCISONAME="arm"
	 CCISONAMEL="ARM"
	else
	 CCARCH=$CARCH
	 CCARCHNAME=$CARCHNAME
	 CCARCHNAMEL=$CARCHNAMEL
	 BUNAME=""
	 OCNAME=""
	 CCISONAME=$CISONAME
	 CCISONAMEL=$CISONAMEL
	fi
	if [ "$CUSTOMBIN" != "" ]; then
	 BUNAME="-XP"$CUSTOMBIN
	fi
 	mkdir Binaries
	mkdir Binaries/Kernel
	/home/tydq/source/compiler/ppc$CCARCH -n -va -al -O- -Si $BUNAME -Sg -Xd -Ur -Us -CX -XXs -Cg BaseUnits/system.pas
	/home/tydq/source/compiler/ppc$CCARCH -n -O- -Si $BUNAME -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/fpintres.pas
	/home/tydq/source/compiler/ppc$CCARCH -n -O- -Si $BUNAME -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/sysinit.pas
	/home/tydq/source/compiler/ppc$CCARCH -n -O- -Si $BUNAME -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/si_prc.pas
	/home/tydq/source/compiler/ppc$CCARCH -n -O- -Si $BUNAME -Sg -Xd -Ur -CX -XXs -Cg BaseUnits/objpas.pas
	if [ "$CCARCHNAME" = "arm" ]||[ "$CCARCHNAME" = "aarch64" ]; then
	/home/tydq/source/compiler/ppc$CCARCH -n -O- -Si $BUNAME -Sg -Xd -Ur -CX -XXs -Cg -FUBinaries/Kernel BaseUnits/prt0.pas
	fi
	/home/tydq/source/compiler/ppc$CCARCH -Cn -n -va -O- -Si $BUNAME -al -Sg -Xd -Ur -CX -XX -Xi -Cg -k-nostdlib -k-znoexecstack -k-znodefaultlib -k-pie -k--no-dynamic-linker -k-znow -dCPU$CCARCHNAMEL -dcpu$CCARCHNAME -dCPU$BITS -FuBaseUnits -FEBinaries/Kernel Kernel/kernel.pas -oBinaries/Kernel/kernel.elf
	/home/tydq/pasld/pasld --entry-point _start --input-path Binaries/Kernel --input-path BaseUnits --output Binaries/Kernel/lookup.elf --smartlinking --alignment page --executable
	/home/tydq/pasld/pasld --entry-point _start --input-path Binaries/Kernel --input-path BaseUnits --output Binaries/Kernel/boot$CCISONAME.efi --smartlinking --alignment page --efi-application
	rm -rf BaseUnits/*.ppu BaseUnits/*.res BaseUnits/*.sh 
	#rm -rf BaseUnits/*.o
	#dd if=/dev/zero of=Binaries/fat.img bs=512 count=131072
	#/usr/sbin/mkfs.vfat -F 32 Binaries/fat.img
	#mmd -i Binaries/fat.img ::/EFI
	#mmd -i Binaries/fat.img ::/EFI/BOOT
	#mcopy -i Binaries/fat.img Binaries/Kernel/*.efi ::/EFI/BOOT/
	/home/tydq/source/compiler/ppc$CARCH -n -O3 -Si -Sc -Sg -Xd -Ur -CX -XXs -Xi -Fu/home/tydq/source/compiler/$CARCHNAME/units/$CARCHNAME-linux -Fu/home/tydq/source/rtl/units/$CARCHNAME-linux -dcpu$BITS -Cg Utility/genfs/genfs.pas
	Utility/genfs/genfs create Binaries/fat.img fat32 64MB
	Utility/genfs/genfs add Binaries/fat.img Binaries/Kernel/*.efi /EFI/BOOT/BOOT$CCISONAMEL.EFI
	rm -rf Utility/genfs/*.o Utility/genfs/*.ppu
	/home/tydq/source/compiler/ppc$CARCH -n -O3 -Si -Sc -Sg -Xd -Ur -CX -XXs -Xi -Fu/home/tydq/source/compiler/$CARCHNAME/units/$CARCHNAME-linux -Fu/home/tydq/source/rtl/units/$CARCHNAME-linux -dcpu$BITS -Cg Utility/geniso/geniso.pas
	rm -rf Utility/geniso/*.o Utility/geniso/*.ppu
	Utility/geniso/geniso Binaries/cdimage$CCISONAME.iso Binaries/fat.img eltorito fat.img
	#mkdir Binaries/iso
	#cp Binaries/fat.img Binaries/iso
	#xorriso -as mkisofs -R -f -e fat.img -no-emul-boot -o Binaries/cdimage$CCISONAME.iso Binaries/iso
	rm -rf Binaries/System Binaries/iso
	rm -rf Binaries/fat.img
	rm -rf Utility/elf2efi/elf2efi 
	rm -rf Utility/genfs/genfs
	rm -rf Utility/geniso/geniso
