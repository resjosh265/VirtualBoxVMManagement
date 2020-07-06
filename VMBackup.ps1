# YOU MAY NEED TO ADD "vboxmanage" TO YOUR SYSTEM VARIABLES
# CREATE A TASK SCHEDULER TASK THAT WILL EXECUTE AT A SPECIFIC TIME DAILY

$VMNAME = 'VM1' # Exact name of the VM you wish to back up in VirtualBox
$BACKUPDIRECTORY = 'D:\cloud\drive\vms' # Path you wish to backup to, using a cloud folder can auto upload to cloud
$TIMESTAMP = Get-Date -Format "MM-dd-yyyy"
$EXISTINGBACKUPS = Get-ChildItem -Path $BACKUPDIRECTORY
$RETAINDAYLIMIT = 5 # Change this to the amount of days you wish to keep


# Remove old backups
Get-ChildItem -Path $BACKUPDIRECTORY -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt (Get-Date).AddDays(-$RETAINDAYLIMIT) } | Remove-Item -Force

# Power off the VM safely
vboxmanage controlvm $VMNAME acpipowerbutton

# Wait until vm is off
While($VMSTATE = (& vboxmanage showvminfo --machinereadable $VMNAME | % { if ($_ -like 'VMState="*"') { $_ } })){
    if($VMSTATE -eq 'VMState="poweroff"'){
        Write-Output "VM Powered off"
        break
    }else{
        Write-Output "VM NOT Powered off"
        Start-Sleep -Seconds 5
    }
}

# Begin the export/backup of the VM
Write-Output "Begining export of $VMNAME"
vboxmanage export Perforce -o "$BACKUPDIRECTORY/$VMNAME-$TIMESTAMP.ova" --ovf20

# Once backup is finished, restart the VM in headless move
Write-Output "Starting $VMNAME"
vboxmanage startvm $VMNAME --type headless