# UEFIPascalOS
Source Code of UEFI Pascal OS(For x64,aarch64,loongarch64,riscv64 architecture)  
## How to use it
1.Get the fpc(free pascal compiler) source code from gitlab.  
2.Compile the fpc source code using fpc installed from linux package manager.    
3.run build.sh to compile code to CD image with your host architecture.   
4.If you want to have cross-compiled architecture's image,run build.sh aarch64(for example when your host is x64,you can input loongarch64/riscv64 as a replacement) to compile the CD image for other architecture.    
## Tips to use
This system is only tested on x64 architecture.My host cannot test riscv64 architecture due to riscv64 virtual machine performance is too bad.  
Other two architecture will be tested later.  
