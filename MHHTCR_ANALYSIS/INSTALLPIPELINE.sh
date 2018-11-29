#!/bin/bash
#This will install the entire PIPELINE needed for TCR Sequencing Analysis
#Run this script while inside the folder the script is found (PIPELINE)
set -o xtrace
set -o errexit



HOMEDIR=$HOME/sequencing
FILES_PROGRAMS=$HOME/sequencing/files_programs/
VDJDIR=$HOME/sequencing/files_programs/vdjtools/vdjtools.jar
MIXCR=$FILES_PROGRAMS/mixcr/mixcr.jar

#Create the folders needed
if [ ! -d $HOMEDIR ]; then mkdir -p $HOMEDIR; fi;
if [ ! -d $FILES_PROGRAMS ]; then mkdir -p $FILES_PROGRAMS; fi;
if [ ! -d $FILES_PROGRAMS/vdjtools ]; then mkdir -p $FILES_PROGRAMS/vdjtools; fi;
if [ ! -d $FILES_PROGRAMS/mixcr ]; then mkdir -p $FILES_PROGRAMS/mixcr; fi;

#There might not be a .bashrc so this will copy it from the folder where most dist. have it. Probably better to write this in a if statement, so that it only copies it if there is no .bashrc
cp /etc/skel/.bashrc ~

#Adding bin2, mixcr and vdjtools to the $PATH variable
echo 'export PATH=$PATH:~/bin2' >> ~/.bashrc
echo 'export PATH=$PATH:~/sequencing/files_programs/mixcr' >> ~/.bashrc
echo 'export PATH=$PATH:~/sequencing/files_programs/vdjtools' >> ~/.bashrc
source ~/.bashrc

#Move the programs to the right folders
#cp vdjtools.jar $FILES_PROGRAMS/vdjtools
#cp -r mixcr/* $FILES_PROGRAMS/mixcr
cp -r bin2 $HOME

#give permission to run the programs
chmod +x $HOME/bin2
#chmod +x $VDJDIR
#chmod +x $MIXCR

#Install R if not installed
sudo apt-get -y install r-base-core

#Install java if not installed
sudo apt-get -y install openjdk-8-jre-headless

#Instll figlet (for nice texts in terminal)
sudo apt-get -y install figlet

#Install rename function
sudo apt-get -y install rename

#Install all R-dependencies and libraries for VDJtools
#java -jar $VDJDIR Rinstall

#Install tcR and treemap
#sudo Rscript ./Install_R_libraries.R



echo " "
echo " "
echo "INSTALLATION COMPLETE."
echo " "
echo "Read the manual and make sure to install VDJtools and MIXCR"



