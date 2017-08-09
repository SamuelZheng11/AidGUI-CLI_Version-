#/bin/bash

declare -r localHome=`pwd`;

printSetup()
{
	echo "==========================================================================="
	echo "Welcome to the Maths Authoring Aid"
	echo "==========================================================================="
	
	if [ ! -d "$localHome"/creations ]
	then
		mkdir ""$localHome"/creations";	
	fi
}

printMenu(){
	cd "$localHome";
	echo "";
	echo "Please select from one of the following options :"
	echo ""
	echo -e "\t(l)ist existing creations"
	echo -e "\t(p)lay and existing creation"
	echo -e "\t(d)elete and existing creation"
	echo -e "\t(c)reate a new creation"
	echo -e "\t(q)uit authoring tool"
	echo ""
	getUserCommand
}

getUserCommand(){
	read -p "Enter a selection [l/p/d/c/q]: " -n1 userSelection;
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
	
	   [qQ]) comfirmQuit;
			;;
	
	   *) echo "sorry I do not understand the command \""$userSelection"\". Please select from the option provided only ";
			read -sp "Press any key to continue" -n1;
			echo "";
			printMenu;
			;;
	esac
}

displayCreationList(){
	local index=1;

	for creationDIR in `ls "$localHome"/creations | sort` 
	do
		echo -e "\t$index) `basename "$creationDIR"`";
		((index++));
	done
}

getCreationAtIndex(){
	local index=1;
	for creationDIR in `ls "$localHome"/creations | sort`
	do
   		if [ $1 -eq $index ]
		then
			comfirmUserSelection="`basename "$creationDIR"`";
		fi
		((index++));
	done
}

getCreationsList(){
	if [ ! `ls "$localHome"/creations | wc -l` -eq 0 ]
	then
		echo "the Exisiting creations are : ";
		displayCreationList;
	else
		echo "sorry no creations currently exist"
	fi

	read -sp"Please press any key to return to the menu" -n1;
	printMenu;
}

checkIsValidNumber(){

	echo "$1" | grep [0-9]-* &> /dev/null

	if [ "$?" -eq 0 ]
	then
		
		if [ ! `ls "$localHome"/creations | wc -l` -lt $1 &> /dev/null ]
		then 
			isValidNumber=true;
			return;
		fi
		isValidNumber=false
		echo ""
		echo "Please select a number from inside the range"
		echo ""
		return;
	fi
	isValidNumber=false
	echo ""
	echo "Sorry that is not a number, please select a number"
	echo ""

}

getPlayCreationOptions(){
	if [ ! `ls "$localHome"/creations | wc -l` -eq 0 ]
	then
		echo "Which creation do you wish to play? : ";
		displayCreationList;
		echo ""
		cd "$localHome"/creations;
		echo "Please select the number that corresponds with the creation you would like to play"
		read playCreationNumber;
	else
		read -p"Sorry no current creations exist, would you like to create one? [y/n] " -n1 createCreationChoice
		echo ""		
	
		case $createCreationChoice in
			[yY]) createCreation;
				;;

			[nN]) echo ""
				echo "Returning to main menu"
				read -sp"Press any key to contiune" -n1;
				printMenu;
				;;
			*) 
				echo "sorry I do not understand the command ";
				echo ""
				getPlayCreationOptions;
		esac
	fi

	checkIsValidNumber $playCreationNumber;
	if ! $isValidNumber
	then
		getPlayCreationOptions;
	fi

	getCreationAtIndex $playCreationNumber;
	echo ""
	read -p"you have choosen \""$comfirmUserSelection"\", would you like to play this? [y/n] " -n1 playCreationChoice

		case $playCreationChoice in
			[yY]) ffplay -t 3 -autoexit "$localHome"/creations/"$comfirmUserSelection"/"$comfirmUserSelection".* &> /dev/null;
				echo ""
				read -sp"Returning to menu press any key to contiune" -n1
				printMenu;
				;;

			[nN]) echo ""
				echo "ok returning to main menu"
				read -sp"Press any key to contiune" -n1;
				printMenu;
				;;
			*) echo "sorry I do not understand the command ";
				getPlayCreationOptions;
		esac
}

getDeleteCreationOptions(){
	if [ ! `ls "$localHome"/creations | wc -l` -eq 0 ]
	then
		echo "Which creation do you wish to delete? : ";
		displayCreationList;
		echo ""
		cd "$localHome"/creations;
		echo "Please select the number that corresponds with the creation you would like to delete " 
		read deleteCreationNumber;
	else
		echo ""
		echo "You do not have any creations, therefore we cannot delete any"
		echo ""
		read -sp"returning to main menu, press any key to continue" -n1
		printMenu;
	fi

	checkIsValidNumber $deleteCreationNumber;
	if ! $isValidNumber
	then
		getDeleteCreationOptions;
	fi

	getCreationAtIndex $deleteCreationNumber;
	echo ""
	echo "you have choosen \""$comfirmUserSelection"\"";
	echo "WARNING REMOVING THIS CREATION WILL PERMENATLY DELETE THE CREATION FOREVER"
	echo ""
	read -p"are you sure you want to delete \""$comfirmUserSelection"\" (enter excatly as shown) [\"yes\"/\"no\"] " deleteCreationChoice

		case $deleteCreationChoice in
			yes) cd "$localHome"/creations/"$comfirmUserSelection"
				rm -f *;
				cd ..;
				rmdir $comfirmUserSelection
				;;

			no) echo "Returning to main menu"
				read -sp"Press any key to contiune" -n1;
				printMenu;
				;;
			*) echo "sorry I do not understand the command";
				getDeleteCreationOptions;
		esac
	echo ""
	echo ""$comfirmUserSelection" has been deleted"
	echo ""
	read -sp"Returning to main menu, press any key to contiune" -n1
	printMenu;
}

createCreation(){

	echo "";
	read -p "Please type the name that you want the creation to be called : " creationName;
	
	if [ -d "$localHome"/creations/"$creationName" ]
	then
		echo "";
		echo "A file with that name already exists, Please choose another name";
		echo "";
		createCreation; 
	else
		mkdir "$localHome"/creations/"$creationName"	
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
	read -p"Would you like to listen to the recording? [y/n]" -n1 listenToRecording
	echo ""
	
	case $listenToRecording in
		[yY]) ffplay -t 3 -autoexit audioOnly.wav &> /dev/null;
			;;

		[nN]) #do nothing
			;;
	esac

	echo ""
	read -p"do you want to (f)inish the creation or (r)e-record? [f/r] " -n1 acceptable
	echo ""
	

		case $acceptable in
		[fF]) finishCreation "$1";
			;;

		[rR]) echo "" 
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

	echo "Creation has been made"
	printMenu;
}

comfirmQuit(){
	read -p"Are you sure you want to quit Maths Authoring Aid? [y/n] " -n1 quitChoice

		case $quitChoice in
			[yY]) echo ""
				echo "Closing visual/audio aid program ";
				echo "";
				read -sp "Press any key to continue" -n1
				echo "";
				exit;
				;;

			[nN]) echo ""
				echo "ok returning to main menu"
				read -sp"Press any key to contiune" -n1;
				printMenu;
				;;
	
			*)	echo ""
				echo "sorry I do not understand the command ";
				comfirmQuit;
		esac
}

printSetup;
printMenu;
