#!/bin/bash

#this only works if the target files/directories are in the pwd

if ! [[ -d $HOME/.utrash ]] # if .utrash directory does not exist
then
    mkdir $HOME/.utrash # creates the directory!
fi  

if [[ "$1" = "rm" ]] && [[ $# -ge 2 ]] # first argument is rm
then
    if [[ "$2" = "-r" ]] && [[ $# -eq 3 ]] # argument is "rm -r dir"
    then
	if ! [[ -d $PWD/$3 ]] # checking that directory exists
	then
	    printf "Error: directory not found; check that the directory is in the PWD\n" > /dev/stderr
	else # copy directory into trash, remove from pwd
	    cp -r "$3" $HOME/.utrash
	    rm -fr "$3"
	fi
    elif [[ $# -eq 2 ]] # argument is "rm file_name"
    then
	if ! [[ -f $PWD/$2 ]]
	then
	    printf "Error: file not found; check that file is in the PWD\n" > /dev/stderr
	else # copy file into trash, remove from pwd
	    cp "$2" $HOME/.utrash
	    rm "$2"
	fi
    fi
elif [[ $# = 1 ]] && [[ "$1" = "ls" ]] # argument is "ls"
then
    ls $HOME/.utrash
elif [[ $# = 2 ]] && [[ "$1" = "dive" ]] # argument is "dive [name]"
then
    target="$(find "$HOME/.utrash" -name "$2")" # gets path to file in .utrash
    if [[ -d $target ]] # trying to pull a directory
    then
	cp -r "$target" $PWD
	# if i wanted to delete it from the trash, i would add: rm -r $target
    elif [[ -f $target ]] # trying to pull a file
    then
	cp "$target" $PWD
	# if i wanted to delete it from the trash, i would add: rm $target
    else # if the target is not in the utrash directory
	printf "Error: file/directory not found in utrash; try the './utrash ls' command to check trash contents\n" > /dev/stderr
    fi
elif [[ $# = 1 ]] && [ "$1" = "dump" ] # argument is "dump"
then # remove everything in the .utrash directory
    rm -fr $HOME/.utrash/*
elif [[ $# = 1 ]] && [ "$1" = "--help" ] # the --help info
then
    printf "Usage:\n  utrash rm [file name]  -  removes file, stores copy in trash\n  utrash rm -r [directory name]  -  removes subdirectory, stores copy in trash\n  utrash ls  -  lists files currently in trash\n  utrash dive [name]  -  copies file/directory from trash into PWD\n  utrash dump  -  empties trash (permanent!)\n* Files/directories must be in PWD to be moved to trash *\n"
    else # if the arguments do not match any expected arguments
    printf "Error: unexpected arguements ; use --help command for guidance\n" > /dev/stderr
fi
