#!/bin/bash

set -e
export LANG=zh_CN.utf8

#Longene Dir
LONGENE_DIR=/opt/longene
#Wine Program Main Dir
#WINPREFIX Dir
WINEPREFIX_DIR=$HOME/.longene/qq2012
#Wine APP Dir
WINEAPP_DIR=$LONGENE_DIR/qq2012
#Current App Dir
QQ2012_DIR=$LONGENE_DIR/qq2012

#Current User
#RUNUSER="`basename $HOME `"
RUNUSER=`whoami`
PACKAGE_NAME=wine-qq2012-longeneteam

#QQ_USER_DIR="$WINEPREFIX_DIR/drive_c/Program\ Files/Tencent/QQ"

function runhelp
{
echo "************************************************************************"
echo "*	Wine-QQ2012-By Longene Team -- build 20120531" 
echo "*	Contact Us By http://www.longene.org" 
echo "*	"
echo "*	Commands:"
echo "*	-u/--uninstall	Uninstall Wine-QQ2012 if you don't like"
echo "*	-d/--debug	Open debug channel. Log file is in your home directory"
echo "*	-h/--help	The fucking help information as now you are reading"
echo "*	-k/--kill	execute wineserver -k to kill all wine programs"
echo "*	-reg/--regedit	start regedit editor"
echo "*	-cfg/--winecfg	start winecfg"
echo "************************************************************************"
}

function uninstallpackage
{
	echo "* Remove wine-qq2012-longene..."
	read -p "* Are you sure? (Y/N)" ANSW
	if [ "$ANSW" = "Y" -o "$ANSW" = "y" -o -z $ANSW  ];then
		sudo dpkg -P $PACKAGE_NAME
	echo "* Done!"
	
	else 
		exit 0
	fi
}

function check_owner
{
	WINEPREFIX_DIR_USER=`stat -c %U $WINEPREFIX_DIR`	
	if [ "$RUNUSER" != "$WINEPREFIX_DIR_USER" ];then
		sudo chown $RUNUSER $WINEPREFIX_DIR
		echo "*	Modifying the owner of $WINEPREFIX_DIR"
	fi
}


function check_firstrun
{
#	echo "Check firstrun...."	
	if [ ! -e $WINEPREFIX_DIR/firstrun ];then
		echo "* Seems the first time to run. Here we go!"
		$QQ2012_DIR/qq2012_gtk
		echo "Bingoo" >$WINEPREFIX_DIR/firstrun
	fi	
}

function runapp
{
	if [ -e "$WINEPREFIX_DIR/drive_c/Program Files/Tencent/QQ/Bin/QQ.exe"  ];then
		check_owner
		check_firstrun
		export WINEDEBUG=-all
		export WINEPREFIX=$WINEPREFIX_DIR
		exec wine  $WINEPREFIX_DIR/drive_c/Program\ Files/Tencent/QQ/Bin/QQ.exe
	else
		echo "* QQ.exe is not found! Unzip package needed."
		echo "* Unzip ...... Please be patient to wait"
		mkdir -p $HOME/.longene
		tar -zxf $QQ2012_DIR/qq2012.tar.gz -C $HOME/.longene
		echo "* Done, Enjoy it!"
		runapp
	fi
}

function debugapp
{
	echo "*	Starting debug channel......."
	echo "*	Log file will be created in your Home:/Longene_qq2012.log"
	echo "*	You can upload the log on our site for help: http://www.longene.org"
	
	#find $LONGENE_DIR -type f -exec $QQ2012_DIR/md5sum {} +  >$HOME/Longene_qq2012.log 
	#echo "*********************************************" >>$HOME/Longene_qq2012.log
	export WINEPREFIX=$WINEPREFIX_DIR 
	exec wine $WINEPREFIX_DIR/drive_c/Program\ Files/Tencent/QQ/Bin/QQ.exe  >$HOME/Longene_qq2012.log 2>&1
}

case $1 in 
	"--uninstall"| "-u")
		uninstallpackage
		;;
	"--debug"| "-d")
		debugapp
		;;
	"--kill"| "-k")
		env WINEPREFIX=$WINEPREFIX_DIR wineserver -k
		;;
	"--regedit"| "-reg")
		env WINEPREFIX=$WINEPREFIX_DIR wine regedit
		;;
	"--winecfg"| "-cfg")
		env WINEPREFIX=$WINEPREFIX_DIR winecfg
		;;
	"--help"| "-h")
		runhelp
		;;
	*)
		if [ -z $1 ];then		
			runapp
		else
			echo "Invalid option:$1"
			runhelp			
		fi
		;;
esac 
