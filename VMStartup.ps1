# YOU MAY NEED TO ADD "vboxmanage" TO YOUR SYSTEM VARIABLES
# CREATE A TASK SCHEDULER TASK THAT WILL EXECUTE ON SYSTEM STARTUP

$VMARRAY = 'VM1','VM2' # Use the exact name of the VM in VirtualBox

foreach($vm in $VMARRAY){
    vboxmanage startvm $vm --type headless
}

