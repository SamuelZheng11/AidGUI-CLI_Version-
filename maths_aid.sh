#/bin/bash

declare -r localHome=`pwd`;

printSetup()
{
	echo "==========================================================================="
	echo "Welcome to the Maths Authoring Aid"
	echo "==========================================================================="
	mkdir "creations";
}

printMenu(){
	cd "$localHome";
	echo "";
	echo "Please select from one of the following options :"
	echo -e "\t(l)ist existing creations"
	echo -e "\t(p)lay and existing creation"
	echo -e "\t(d)elete and existing creation"
	echo -e "\t(c)reate a new creation"
	echo -e "\t(q)uit authoring tool"
	getUserCommand
}

getUserCommand(){
	read -p "Enter a selection [l/q/d/c/q]: " -n1 userSelection;
	echo "";
	echo "";
	case $userSelection in
	   [lL]) getCreationsList;
			;;
	
	   [pP]) getPlayCreationOptions;
			;;
	
	   [dD]) getDeleteCreationOptions;
			;;
	
	   [cC]) createCreation;
			;;
	
	   [qQ]) echo "Closing visual/audio aid program ";
			echo "";
			read -sp "Press any key to continue" -n1
			echo "";
			exit;
			;;
	
	   *) echo "sorry I do not understand the command \""$userSelection"\". Please select from the option provided only ";
			read -sp "Press any key to continue" -n1;
			echo "";
			printMenu;
			;;
	esac
}

getCreationsList(){
	echo "the Exisiting creations are : ";
	
}

GetPlayCreationOptions(){
	echo "Which creation do you wish to play? : ";

}

getDeleteCreationOptions(){
	echo "Which creation do you want to delete? : ";

}

createCreation(){

	echo "";
	read -p "Please type the name that you want the creation to be called : " creationName;
	
	if [ -d ./creations/"$creationName" ]
	then
		echo "";
		echo "A file with that name already exists, Please choose another name";
		echo "";
		createCreation; 
	else
		mkdir ./creations/"$creationName"	
	fi
	
	makeVideo "$creationName";
}

makeVideo(){

	cd "$localHome"/creations/"$1";
	#back slashes have been used in the ffmpeg command below to notify bash that i am not done
	#with the command yet before going to the next line, i am working on a very small laptop screen :(
	ffmpeg -f lavfi -i color=c=orange:s=320x240:d=3.0 -vf \
	"drawtext=fontfile= "$localHome"/font/font.ttf:fontsize=30: \
	fontcolor=blue:x=(w-text_w)/2:y=(h-text_h)/2:text='$1'" videoOnly.mp4 &> /dev/null
	
	recordVoice "$1";
}

recordVoice(){

	echo ""	
	echo "Please record yourself saying \""$1"\""
	read -p"Press any key to start recording, you will have 3 seconds to record" -n1
	echo ""
	echo "[Recording ...]"
	ffmpeg -f alsa -i hw:0 -t 3 audioOnly.wav &> /dev/null;
	echo "Finished recording"
	echo ""
	read -sp"Would you like to listen to the recording? [y/n]" -n1 listenToRecording
	echo ""
	
	case $listenToRecording in
	
		[yY]) ffplay -t 3 -autoexit audioOnly.wav &> /dev/null;
			;;

		[nN]) #do nothing
			;;
	esac

	echo ""
	read -sp"Is this acceptable? [y/n]" -n1 acceptable
	echo ""

		case $acceptable in
	
		[yY]) finishCreation "$1";
			;;

		[nN]) echo "" 
				echo "ok we will re-record the audio clip"
				rm -f audioOnly.wav &> /dev/null;
				recordVoice "$1";
			;;
	esac
}

finishCreation(){

	ffmpeg -i videoOnly.mp4 -i audioOnly.wav \
	-c:v copy -c:a aac -strict experimental \
	-map 0:v:0 -map 1:a:0 "$1".mp4 &> /dev/null

	printMenu;
}

printSetup;
printMenu;
