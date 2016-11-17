#! /bin/bash 
Assignment 2
#/bin/bash
#James English

test="testFunction"
input=""
searchFor=""
switch=""
timeCounter=0

if [ $# -ne 1 ]; then 
	echo "Incorrect syntax entered. Must enter in Name of file to look at."
	exit	
fi

input=$1

if [ ! -e  $input ]; then
	echo "File does not Exist exiting script"
	exit
fi

if [ -d $input ]; then
      echo "This is a directory not a file, exiting script."
      echo ""
      exit
fi
 
if [ $input !=  *.html ]; then
	echo "This is not an html file, do you wish to continue (y/n)"
	echo ""
		read newInput
			case "$newInput" in 
				n|N)
				echo "Goodbye"
				exit;;
				y|Y) echo "Going forward with script"
				echo ""
			esac
fi
	
function analyze {
	echo "Your input was"  $input
	echo "Providing Information about" $input
	lineCount=$(cat $input | wc -l)
	wordCount=$(cat $input | wc -w)
	characterCount=$(cat $input | wc -c)
	enumeratorCount=$(grep -o "<li>" $input | wc -l) 
	linkCount=$(grep -o "href=" $input | wc -l)
	echo "There are $characterCount characters in $input"
	echo "There are $lineCount lines in $input"
	echo "There are $wordCount words in $input"
	echo "There are $enumeratorCount enumerators in $input"
	echo "There are $linkCount links in $input"	
}

function replace  {
	echo "copying original file"
	temp=$input
	echo "Making old copy of" ${temp##*/}
	temp=${temp##*/}
	echo "Creating old copy using original file name" ${temp%.html}
	cp $input ${temp%.*}.old
	echo "successfully made copy called $input.old"
	echo ""
	echo "What word would you like to replace"
	echo "" 
	read searchFor
	echo "What would you like to replace $searchFor with?"
	echo ""
	read switch
	echo "Replacing every $searchFor with $switch"
	replaceWord=$(sed "s/$searchFor/$switch/g" $input)
	echo "$replaceWord" > "$input"
	echo "Replaced all instances of $searchFor with $switch" 
}

function timestamp {

	if [ $timeCounter = 0 ]; then 
	echo "Creating a timestamp of $input"
	echo "Please Enter Your Name"
	read name
	temp=$input
	echo "Creating a copy of $input with a .new extension"
	temp=${temp##*/}
	echo "New copy will be made using the original file name" ${temp%.html}
	cp $input ${temp%.*}.new
	newFile=${temp%.*}.new
	echo "Copy of $input was created"
	sed -i "1s/^/<!--"$name" -->\n/" $newFile
	echo "added $name to top of $newFile"
	echo ""
	timeCounter=1
	

	else 
	echo "Already added timestamp, can not do this again"
	fi 	
}

function setPermissions {
	echo "Setting Permissions"
		while [ true ] 
		do
			echo "Select who to change permissions for. g = group, u = user, o = other, a = all"
			echo ""
				read which
					case "$which" in 
					g|G) echo "editing permissions for group"
					break;;
					u|U) echo "editing permissions for a user"
					break;;
					o|O) echo "editing permissions for other"
					break;;
					a|A) echo "editing permissions for all"
					break;;
					*) echo "Must enter g, u, o, or a only"
					echo ""
					;;
					esac
		done

	echo "Set: =, Add: +, or Remove: - Permissions?"
		while [ true ] 
		do
			read choice
				case "$choice"	in 
				=) echo "Setting permissions"
				break;;
				+) echo "Adding permissions"
				break;;
				-) echo "Removing permissions"
				break;;
				*) echo "Must enter + - or = only"
				;;
				esac
		done

	echo "Set permissions to Read (r), Write(w), or Execute(x)"
	echo ""
		while [ true ] 
		do 
			read permission
				case "$permission" in 
				r|R) echo "Setting permisions to read of $input"
				break;;
				w|W) echo "Setting permisions to write for $input"
				break;;
				x|X) echo "Setting permissions to execute for $input"
				break;;
				*) echo "Must enter r, w, or x only"
				;;
				esac
		done 

finalPermissions=$which$choice$permission


chmod $finalPermissions $input 
echo "Your permissions have been applied to $input"
}


PS3=" Enter your choice from the menu "
  
options=("Analyze" "Timestamp" "Find and Replace" "Set Permissions" "Quit")

opt=""

until [ "$opt" == "Quit" ]; do 
	select opt in "${options[@]}"
	do 
		case $opt in 
			"Analyze")
			analyze 
			break
			;;
			"Timestamp")
			timestamp 
			break	  
			;;
			"Find and Replace")
			replace 
			break
			;;

			"Set Permissions")
			setPermissions 
			break
			;;
		
			"Quit")
			break
			;;
			*) echo "invalid option, please enter 1, 2, 3, 4, or 5." ;;
	esac
done
done