# UEFIPascalOS
Source Code of UEFI Pascal OS(For x64,aarch64,loongarch64,riscv64 architecture)  
## Tips before use
These days this OS is problematic,if you want to test,your should edit the source code.  
## How to use it
1.Get the fpc(free pascal compiler) source code from gitlab.  
2.Compile the fpc source code using fpc installed from linux package manager.    
3.run bash build.sh to compile code to CD image with your host architecture.   
4.If you want to have cross-compiled architecture's image,run build.sh aarch64(for example when your host is x64,you can input loongarch64/riscv64 as a replacement) to compile the CD image for other architecture.  
5.If you have custom binutils,you can run bash build.sh ARCH BINUTILSDIR to compile with your custom binutils.  
## Tips to use
This system is tested in x64,ARM64,riscv64,loongarch64 architecture,but it is just like a bare metal program these days.  
Device driver seems hard to me,however I will consume many times to overcome it.
## Clause I've use
BSD-4.0 Clause
