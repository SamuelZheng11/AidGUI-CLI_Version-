printf "===========================================================================\n"
printf "Welcome to the Maths Authoring Aid\n"
printf "===========================================================================\n"
printf "Please select from one of the following options :\n"
printf "\t(l)ist existing creations\n"
printf "\t(p)lay and existing creation\n"
printf "\t(d)elete and existing creation\n"
printf "\t(c)reate a new creation\n"
printf "\t(q)uit authoring tool\n"
printf "Enter a selection [l//q//d//c//q]: "

listCreations="l"
playCreations="p"
deleteCreations="d"
createCreations="c"
quit="q"

read userSelection
if [ "$userSelection" == "$listCreations" ];
then
  printf "\nthe Exisiting creations are :\n "
fi

