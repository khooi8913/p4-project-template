#! /bin/bash

function usage() {
    echo "Usage: ./create_project.sh -d TARGET_PATH"
    echo "Example: ./create_project.sh -d /home/khooi8913/projects/p4-router/"
}

directory=""
while getopts "hd:" opt; do 
    case ${opt} in
    h|\?)
    usage
    exit
    ;;

    d) 
    directory=$OPTARG
    ;;

    *)
    usage 
    exit
    ;;
    esac
done

if [[ $directory == "" ]]; then
    echo "Empty directory path"
    exit 1
fi

echo "Creating directory" $directory
[ -d $directory ] && echo "Directory exists!" && echo "Exiting..." && exit 1 || mkdir $directory
echo "Directory" $directory "created successfully!"

# utils
cp -r utils/ $directory && echo "Copying utils..." || echo "An error has occurred!"
project_name=$(basename $directory)

# src
src_directory="$directory/src"
mkdir $src_directory && echo "src directory created successfully." || (echo "An error has occurred!" && exit 1)

# src/Makefile
cp src/Makefile $src_directory && echo "Copying Makefile"

# src/topology.json
cp src/topology.json $src_directory && echo "Copying topology.json"

# src/s1-runtime.json
sed s/"basic"/$project_name/g  src/s1-runtime.json > $src_directory/s1-runtime.json && echo "Creating s1-runtime.json" 

# # src/basic.json
cp src/basic.p4 $src_directory/$project_name.p4 && echo "Creating $project_name.p4" 

# src/controller.py
sed s/"basic"/$project_name/g  src/controller.py > $src_directory/controller.py && echo "Creating controller.py"

# README.md
echo "# $project_name" > $directory/README.md

echo "Done!"