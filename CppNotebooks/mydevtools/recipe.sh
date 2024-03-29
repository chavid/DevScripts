#!/bin/bash

Help()
{
   # Display Help
   echo "Search for a recipe."
   echo
   echo "Syntax: recipe.sh [-v|-h]"
   echo "options:"
   echo "h     Print this Help."
   echo "v     Show the currently selected recipe."
   echo
}

# Parse the options
while getopts ":hv" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      v) # verbose
         if [ ! -r /tmp/dev-scripts-recipe-dir-$PPID ]
         then
           echo unknown recipe
           exit
         fi
         cat /tmp/dev-scripts-recipe-dir-$PPID
         exit;;
   esac
done

unset DEV_SCRIPTS_DOCKER_TOPDIR
if [ "$1" != "" ] ; then
  DEV_SCRIPTS_DOCKER_TOPDIR=$1
  nbfiles=`find ${DEV_SCRIPTS_DOCKER_TOPDIR} -iregex '.*dockerfile.*' -type f | wc -l `
else
  DEV_SCRIPTS_DOCKER_TOPDIR="."
  nbfiles=`find ${DEV_SCRIPTS_DOCKER_TOPDIR} -iregex '.*dockerfile.*' -type f | wc -l `
  if [ ${nbfiles} -eq 0 ] ; then
    DEV_SCRIPTS_DOCKER_TOPDIR=${DEV_SCRIPTS_DIR}
    nbfiles=`find ${DEV_SCRIPTS_DOCKER_TOPDIR} -iregex '.*dockerfile.*' -type f | wc -l `
  fi
fi

if [ ${nbfiles} -gt 1 ] ; then
  echo multiple recipes found
elif [ ${nbfiles} -eq 0 ] ; then
  echo no recipe found
else
  DOCKERFILE=`find ${DEV_SCRIPTS_DOCKER_TOPDIR} -iregex '.*dockerfile.*' -type f`
  ORIGINAL_DIR=${PWD}
  cd `dirname ${DOCKERFILE}`
  echo `pwd` &> /tmp/dev-scripts-recipe-dir-$PPID
  cd ${ORIGINAL_DIR}
  echo recipe: `cat /tmp/dev-scripts-recipe-dir-$PPID`
fi
