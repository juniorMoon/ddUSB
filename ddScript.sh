#!/bin/bash

#IMPORTANT: Don’t provide path to the exact partition, for example:
##sudo dd if=/home/slick/Downloads/debian-7.4.0-amd64-CD-1.iso of=/dev/sdb1

#splash page and message
cat ./splash

#check if running as root
varWho="$(id -u)"

if [ "$varWho" -ge 1 ]; then
  echo "Please run as root"
  exit 1
fi

##menu
echo "	"
echo "What would you like to do?"
echo "	"
echo "  1) Create an Image/Bootable USB"
echo "  2) See all drives on your system"
echo "  3) Format a drive/USB to Fat32"
echo " 99) Exit"
echo "	"

read varMenuOpt
case $varMenuOpt in
    1)
     echo " "
     echo "Are you writing to a file or a drive?"
     echo "  1) File - usually for creating ISOs"
     echo "  2) Drive - usually for creating bootable USBs"
     echo " "

     read varfiledrive

     case $varfiledrive in
       1)
        echo "	"
        echo "Please enter the input file path (e.g. /location/to/My/ISO)."
        echo "	"
        read -e varif

        echo "	"
        echo "Now enter the output file destination"
        echo "	"
        read -e varof

        echo "	"
        echo "Thanks."
        echo "	"

        sleep 1s

        echo "Are these paths correct?"
        echo "  "
        echo "(Enter y or n)"
        echo "	"
        echo "Input file: $varif"
        echo "Output file: $varof"
        echo "	"

        read varVerify

        if [ $varVerify == "n" ]; then
            echo "	"
            echo "Then, try again."
            echo "	"

            sleep 2s

            echo "Please enter the input file path (e.g. /location/to/My/ISO)."
            echo "	"
            read -e varif

            echo "	"
            echo "Now enter the output file destination"
            echo "	"
            read -e varof

            echo "	"
            echo "Thanks."
            echo "	"

            sleep 1s

            echo "Are these paths correct?"
            echo "  "
            echo "(Enter y or n)"
            echo "	"
            echo "Input file: $varif"
            echo "Output file: $varof"
            echo "	"

            read varVerify

            if [ $varVerify == "n" ]; then
              echo "	"
              echo "Get the correct paths and try again later."
              echo "  "
              echo "Goodbye..."
              exit 1
            fi
        fi

        echo "We will now write the files to the disk"
        echo "NOTE: Please do not poweroff or suspend PC while the copying is in progress."

        sleep 2s

        dd if=$varif of=$varof status=progress

        echo "	"
        echo "Thanks for using our Utility"
        echo "Goodbye..."
        sleep 1.5s
        exit
       ;;
       2)
        echo "  "
        echo "Please enter the input file path (e.g. /location/to/My/ISO)."
        echo " "
        read -e vardrvif

        echo " "
        echo "Thanks."
        sleep 1s

        echo " "
        echo "Here's a list of your drives:"
        echo " "

        lsblk

        echo " "
        echo "What is the name of the drive that you would like to write to?"
        echo " NOTE: Please provide the drive and NOT the partition"
        echo " (e.g. sdb,sdc,sdd, etc.)"
        echo " "

        read -e vardrvof

        echo " "
        echo "Thanks."
        echo " "

        sleep 1s

        echo "You have chosen to write to $vardrvof."
        echo "  "
        echo " WARNING: This will format the drive. Formatting this drive"
        echo " will erase ALL data on the drive."
        echo " This process is irreversable."
        echo "  "
        echo " Are you sure that you want to use $vardrvof?"
        echo "  "
        echo "(Enter y or n)"
        echo "	"

        read vardrvverify

        if [[ $vardrvverify == n ]]; then
          echo "	"
          echo "Canclled..."
          echo " "
          exit
        fi

        echo "  "
        echo "OK."
        echo " "

        sleep 1s

        echo "What would you like to name your drive?"
        echo "	"
        read vardrvname

        echo "  "
        echo "OK."
        echo " "

        sleep 1s

        echo " "
        echo "Here is your summary:"
        echo -e "1. You have chosen to use the source of: \e[01;32m$vardrvif\e[0m."
        echo -e "2. You have chosen to write to write to: \e[01;32m$vardrvof\e[0m."
        echo -e "3. You have chosen to name your drive: \e[01;32m$vardrvname\e[0m."
        echo "  "
        echo "Is this correct?"
        echo " "
        echo "(Enter y or n)"
        echo "	"

        read vardrvnameverify

        if [[ $vardrvnameverify == n ]]; then
          echo "	"
          echo "Canclled..."
          echo " "
          exit
        fi

        echo " "
        echo "Sounds Good."
        echo " "

        echo "Starting the formatting process."
        echo "Do not remove the drive at any time until formatting is complete."
        echo " "

        umount /dev/$vardrvof
        mkfs.vfat -n $vardrvname -I /dev/$vardrvof

        echo " "
        echo "Formatting complete."

        sleep 1s

        vardrvifsize=$(du -h $vardrvif | awk '{print $1}')

        echo " "
        echo "Source total file size is: $vardrvifsize."
        echo "Writing to drive..."

        dd if=$vardrvif of=/dev/$vardrvof status=progress

        echo " "
        echo "Writing complete."
        echo "NOTE: If you dont see your drive after the process is complete,"
        echo "you may need to manually mount it using: mount /dev/device /path/to/mount/point"
        echo "  "
        echo "Enjoy your Bootable USB!"

        exit
       ;;

       *)
        echo "invalid option"
        exit
       ;;
     esac
    ;;
    2)
     echo "	"
     echo "Here are all drives and partitions on the system:"
     echo "	"
     lsblk
     echo "	"
     echo "Goodbye..."
     echo "	"
     exit
    ;;
    3)
     echo "Here's a list of your drives:"
     echo " "

     lsblk

     echo " "
     echo "What is the name of the drive that you wish to format?"
     echo " NOTE: Please provide the drive and NOT the partition"
     echo " (e.g. sdb,sdc,sdd, etc.)"
     echo " "

     read varformdrv

     echo " "
     echo "Thanks."
     echo " "

     sleep 1s

     echo "You have chosen to format $varformdrv to fat32."
     echo " WARNING: formatting this drive will erase ALL data on the drive."
     echo " This process is irreversable."
     echo " Are you sure that you want to format $varformdrv?"
     echo " "
     echo "(Enter y or n)"

     read varformverify

     echo "	"
     if [[ $varformverify == n ]]; then
       echo "Canclled..."
       echo " "
       exit
     fi

     echo " "
     echo "OK."
     echo " "

     sleep 1s

     echo "What would you like to name your drive?"
     echo "	"
     read varformname

     echo " "
     echo "you have chosen to name your drive: $varformname."
     echo "Is this correct?"
     echo " "
     echo "(Enter y or n)"
     echo " "

     read varformnameverify

     if [[ $varformnameverify == n ]]; then
       echo "	"
       echo "Canclled..."
       echo " "
       exit
     fi

     echo " "
     echo "Sounds Good."
     echo " "

     sleep 1s

     echo "Starting the formatting process."
     echo "Do not remove the drive at any time until formatting is complete."
     echo " "

     umount /dev/$varformdrv
     mkfs.vfat -n $varformname -I /dev/$varformdrv

     echo " "
     echo "Formatting complete."
     echo "Goodbye.."
     exit
    ;;
    99)
     echo "Goodbye..."
     echo "	"
     exit
    ;;
    *)
     echo "Invalid option"
     exit
    ;;
esac

#EOF
