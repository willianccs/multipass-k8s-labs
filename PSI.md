# PSI Secure Browser

Ubuntu 22.04 issues

> https://helpdesk.psionline.com/hc/en-gb/articles/4409608794260--PSI-Bridge-FAQ-System-Requirements
> Currently, we are delayed in supporting 22.04 while AppImage support is broken in 22.04. More information will be posted as soon as it's available.

```sh
/bin/sh -c '$HOME/.config/com.psiexams.psi-bridge-secure-browser/PSIBridgeSecureBrowser.AppImage %U'
## Error 1: dlopen(): error loading libfuse.so.2 | AppImages require FUSE to run
# Ref: https://techpiezo.com/linux/error-appimages-require-fuse-to-run-in-ubuntu-22-04/
sudo apt update
sudo apt install libfuse2
/bin/sh -c '$HOME/.config/com.psiexams.psi-bridge-secure-browser/PSIBridgeSecureBrowser.AppImage %U'
## Error 2: libssl.so.1.1: cannot open shared object file: No such file or directory
cd $HOME/Downloads
wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb
/bin/sh -c '$HOME/.config/com.psiexams.psi-bridge-secure-browser/PSIBridgeSecureBrowser.AppImage %U'
```
