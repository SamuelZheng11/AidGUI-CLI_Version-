printf "===========================================================================\n"
printf "Welcome to the Maths Authoring Aid\n"
printf "===========================================================================\n"
printf "Please select from one of the following options :\n"
printf "\t(l)ist existing creations\n"
printf "\t(p)lay and existing creation\n"
printf "\t(d)elete and existing creation\n"
printf "\t(c)reate a new creation\n"
printf "\t(q)uit authoring tool\n"
printf "Enter a selection [l//q//d//c//q]: \n"

listCreations="l"
playCreations="p"
deleteCreations="d"
createCreations="c"
quit="q"


loop=true
while [  true ] 
do
        read userSelection
	if [ "$userSelection" == "$listCreations" ];
	then
  		printf "the Exisiting creations are : \n "
	elif [ "$userSelection" == "$playCreations" ];
		then
  		printf "Which creation do you wish to play? : \n "
	elif [ "$userSelection" == "$deleteCreations" ];
		then
  		printf "Which creation do you want to delete? : \n "
	elif [ "$userSelection" == "$createCreations" ];
		then
  		printf "What creation do you wish to make? : \n "
	elif [ "$userSelection" == "$quit" ];
		then
		break;
  		printf "Closing program\n ";
	else 
		printf "not a valid command please enter one of the selections provided above : \n";
	fi
done





	
