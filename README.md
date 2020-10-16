# Create ProSocVM in Azure

## Deploy the Image Creation Script

Go to the Azure Portal and open the Azure CLI, use **Bash** as shell, no Powershell.
![cli1](https://i.imgur.com/gJ3F3wr.png)
Download and allow execute permission to the script

```bash
wget -O copyVMImage.sh https://www.dropbox.com/s/ym9w7qsgegycmwm/copyImage.sh?dl=0

chmod +x copyVMImage.sh
```

Execute the script

```bash
./copyVMImage.sh
```

The script will ask for your **Resource Group** name and the **location** where you want to copy the Image and
deploy the VM.

When the script finish a message will show the name of the image created.
![finish](https://i.imgur.com/17VlHlp.png)
You can search for it in the Resource Group you selected or under Images searching on the Azure Portal.

## Deploy the VM

Search for the image just created and click on **Create VM**.

![VM1](https://i.imgur.com/ljkkE10.png)
In the next page, choose the following parameters
![VM2](https://i.imgur.com/cHY3htB.png)

1. Virtual Machine Name: Prosocv7
2. Size: At least **Standard_D2s_v3**
3. Authentication Type: Password
4. Choose any password you prefer, as username use **proficio**.
   Click next
   On the **Disks** tab choose **Premium SSD**
   On the **Networking** tab choose the Virtual Network and Subnet for the new VM.
   ![VM3](https://i.imgur.com/Cr3oSYi.png)
   Leave the next tabs as default and create the VM.
   When finish, please share the public IP with Proficio to check if we can connect to the VM
