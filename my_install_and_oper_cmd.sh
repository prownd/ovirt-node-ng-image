 #!/usr/bin/bash

# oVirt
# https://github.com/oVirt/ovirt-node-ng-image
#
# git clone  https://github.com/oVirt/ovirt-node-ng-image


 sudo pip2 install yaml
 sudo pip2 install jinja2
 #如果ovirt-node-ng-image.ks 为空 
 # 那么就删除这个文件 用make 重新生成
 rm -fr data/ovirt-node-ng-image.ks
 sudo make data/ovirt-node-ng-image.ks
 sudo make ovirt-node-ng-image.squashfs.img
 sudo make clean-local; sudo make ovirt-node-ng-image.squashfs.img

# 如果  出现qemu-kvm  -nofconfig  修改 
#        #qemu_cmd += ["-nodefconfig"]
#       qemu_cmd += ["-no-user-config"] 
#		修改为-no-user-config 
