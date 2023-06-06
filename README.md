# PackerRepository
 PackerConfigFiles
Day 0 "Infrastructure As Code" 
This packer code will create a Virtual Box VM, install a CentOS 8 Stream from ISO with customizations from a Kickstart file and run a script (firstboot) that will setup the KVM that will be employed to run some deploys with terraform and customizations with ansible.


PRE-REQs:

- Install Virtual Box 7, Vagrant and Packer on a Windows 11;
- Packer, VBoxManager and Vagrant must be located on PATH environment variable;

Steps:
These are the basics to setup the initial environment (powershell / batch commands below):

rm 'vagrant_deploys\packer_virtualbox_virtualbox.box';
vagrant box remove centos8Stream;
cd 'PackerRepository';
packer.exe build -on-error=abort -force .\centos.pkr.hcl;
cp 'PackerRepository\packer_virtualbox_virtualbox.box' '\vagrant_deploys';
cd '\vagrant_deploys\';
vagrant box add .\packer_virtualbox_virtualbox.box --name=centos8Stream;
