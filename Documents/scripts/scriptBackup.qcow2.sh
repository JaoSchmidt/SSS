#!/bin/bash

$image_folder='/imagens/vm-imagens'
$backup_folder='/imagens/vm-backups'

#pega todas as imagens
vms=$(virsh list --all | tr -s ' ' | cut -d " " -f 3 | tail -n +3)

for i in $vms; do
	if [ -f $image_folder/$i.qcow2 ] && [ -f $image_folder/$i.xml ] ; then
		if virsh shutdown $i ; then
			virsh dumpxml $i &> $image_folder/$i.xml
			tar jcvfpP $backup_folder/$i.backup.tar.bz2 $image_folder/$i.qcow2 $image_folder/$i.xml
			virsh start $i
			gdrive upload --partent 1wGs0aHd9D01dKgXm4u9KL_VCucVWpoKj $backup_folder/$i.backup.tar.bz2
		fi
	fi
done

