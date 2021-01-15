### ovirt-node-ng-image


#### generate ks template 
sudo make data/ovirt-node-ng-image.ks


#### use ks file to generate disk img with squashfs compress 
sudo make ovirt-node-ng-image.squashfs.img 


#### generate a iso file 
sudo make clean-local; sudo make ovirt-node-ng-image.squashfs.img
