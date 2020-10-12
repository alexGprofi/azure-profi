#!/bin/bash
#Create VM from PageBlob
# Alex Gomez
# agomez@proficio.com
GREEN='\033[0;32m'
NC='\033[0m'
RED='\033[0;31m'

echo "----Available locations----"
az account list-locations --query [].name | tee mylocations.txt
echo "##########################"
echo ""
echo "Please type your location: "
read mylocation

numberLocs=$(grep $mylocation mylocations.txt | wc -l)
if [ $numberLocs -eq 0 ]
	then
	echo -e "${RED} $mylocation -> This location doesn't exist ${NC}"
	exit 0
fi
echo ''
echo "Available Resource Groups in the location -- $mylocation"
az group list --query "[?location=='$mylocation']" > mygrouplist.txt
grep name mygrouplist.txt | cut -d':' -f2
echo "##########################"
echo ""
echo "Please type the name of the Resource Group: "
read myresourcegroup

if [ $(az group exists -n $myresourcegroup) == 'false' ]
	then
	echo -e "${RED} The resource group doesn't exist ${NC}"
	exit 0
fi

rm -rf mylocations.txt mygrouplist.txt
#Create group if require, choose your location/region
#az group create -l westus -n Proficio
diskName='ProSOCv7'
numberDisk=$(az disk list  -g $myresourcegroup --query [].name | grep $diskName | wc -l)
if [ $numberDisk -gt 0 ]
	then
	diskName="ProSOCv7_$(date +"%s")"
fi
#Create Disk In Azure
 
echo -e "Creating disk --- ${GREEN} $diskName ${NC} ..."
myRG=$myresourcegroup
myRegion=$mylocation
myprosocSA='prosoc783'
#For disk size check with "ls"
az disk create -n $diskName -g $myRG -l $myRegion --for-upload --upload-size-bytes 137363456512 --sku premium_lrs

#Open the disk to be written
echo "===== Preparing disk for download the VHD disk ===== "
SASURI=$(az disk grant-access -n $diskName -g $myRG --access-level Write --duration-in-seconds 86400 --query [accessSas] -o tsv)
echo "===== Copy Disk from page Blob Container ===="

#Install AZCopy, then you can run the command
azcopy copy "https://publicprosocvm.blob.core.windows.net/publicprosocvm78/prosocvm78.vhd" $SASURI --blob-type PageBlob
echo ""
#After uploading need to revoke access
echo "===Finishing preparing disk=="
az disk revoke-access -n $diskName -g $myRG
echo -e " Disk ${GREEN} $diskName ${NC} created"
sleep 2
echo "===Creating Image=="
az image create -g $myRG -n $diskName --os-type Linux --source $diskName
echo ""
echo "##########################"
echo ""
echo -e " Image ${GREEN} $diskName ${NC} created"
echo ""
echo "##########################"
echo "Now you can proceed to deploy the VM from Image"
sleep 2
# az vm create \
    # --resource-group $myRG \
    # --location $myRegion \
    # --name myNewVM \
	# --os-type linux \
    # --attach-os-disk $diskName

