# ovirt-node-ng-image
This is a readonly mirror of the repository with the same name under gerrit.ovirt.org 


#generate ks template
sudo make data/ovirt-node-ng-image.ks


#use ks file to generate disk img with squashfs compress
sudo make ovirt-node-ng-image.squashfs.img


#generate a iso file
 sudo make clean-local; sudo make ovirt-node-ng-image.squashfs.img
