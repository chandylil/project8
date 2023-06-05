#!/bin/bash

#this only works if the target files/directories are in the pwd

if ! [ -d $HOME/.utrash ] # if loop for... if .utrash directory does not exits
then
    mkdir $HOME/.utrash # creates the directory!
fi  
if [ "$1" = "rm" ] # if loop for... first argument is rm
then
    if [ "$2" = "-r" ] && [[ $# = 3 ]] # if loop for... argument is "rm -r dir"
    then
	cp -r "$3" $HOME/.utrash
	rm -fr "$3"
    elif [[ $# = 2 ]] # if loop for... argument is "rm file_name"
    then
	cp "$2" $HOME/.utrash
	rm "$2"
    fi
elif [[ $# = 1 ]] && [ "$1" = "ls" ] # if loop for... argument is "ls"
then
    ls $HOME/.utrash
elif [[ $# = 2 ]] && [ "$1" = "dive" ] # if loop for... argument is "dive [name]"
then
    target="$(find "$HOME/.utrash" -name "$2")"
    if [ -d $target ] # if loop for... trying to pull a directory
    then
	cp -r "$target" $PWD
    else # trying to pull file
	cp "$target" $PWD
    fi
elif [[ $# = 1 ]] && [ "$1" = "dump" ] # if loop for... argument is "dump"
then
    rm -fr $HOME/.utrash/*
elif [[ $# = 1 ]] && [ "$1" = "--help" ]
then
    printf "Usage:\n  utrash rm [file name]  -  removes file, stores copy in trash\n  utrash rm -r [directory name]  -  removes subdirectory, stores copy in trash\n  utrash ls  -  lists files currently in trash\n  utrash dive [name]  -  copies file/directory from trash into PWD\n  utrash dump  -  empties trash (permanent!)\n* Files/directories must be in PWD to be moved to trash *\n"
    else
    printf "Error: unexpected arguements ; use --help command for guidance\n" > /dev/stderr
fi
