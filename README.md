
# General description

DevDocker provides a set of utility commands, which help a developer to manage his stacks of developments tools, thanks to dedicated containers.

When running such a container, the default is to mount the current working directory, and run the container as the current working user, so that any change to the working directory will be done with the relevant identity (from the host point of view).

WARNING: in the short explanations below, we expect you are already familiar with docker ecosystem.


# News

## 2026-07-30

- former `drun -u` is now the default, and `drun -r` (as "root") is used to run without the default option `--user`.
- a new `/myhome` can now be added to the image during `dbuild`, that can be used as a HOME when running `docker run` with the default `--user` option. 

## 2023-01-20

- alias `dbash` is renamed `drun`.
- `drun` (alias to `run.sh`), `dbuild` (alias to `build.sh`) and `drecipe` (alias to `recipe.sh`) have been given few options, including `-h` to print a short help.
- new recipe `Python3`.


# General use

Starting from a bash shell, and staying into any directory, one should source `<DevDocker>/env.bash`. This will make available the following commands:
- `drecipe`: alias to the `recipe.sh` script, which recursively search for a `Dockerfile` ; a subdirectory can be provided as argument, where to search for the recipe ; if not, the script scan the current directory, then the `<DevDocker>` one.
- `dbuild`: alias to the `build.sh` script, building the docker image and tagging it with the name within `Dockertag`.
- `drun`: alias to the `run.sh` script, will start a new interactive container, from the docker image whose name is taken from `Dockertag`, mount the current working directory as `/work`, and add `-user $(id -u):$(id -g) -e HOME=/myhome`, so that any modification made to `/work` will be done with the correct uid.

Some other commands  are available after in the orginal bash shell, once `env.bash` has been sourced, and may also be available in the containers:
- `count`: count the code lines in the current directory and subdirectories.
- `oval`: automatically run regression tests and/or various set of commands.


# Files 

Docker related, in `bin` subdirectory:
* `recipe.sh`: script used to find a recipe.
* `build.sh`: script used to build the image.
* `push.sh`: script used to push the image.
* `pull.sh`: script used to pull the image.
* `run.sh`: script used to run the image.

Other utilities, in `home/bin` subdirectory
- `count.sh`: count the code lines in the current directory and subdirectories.
- `oval.py`: automatically run regression tests and/or various set of commands.

In other subdirectories:
* `Dockerfile` : docker recipe.
* `Dockertag` : name to be given to the corresponding docker image.
 

# Recipe tips

## Myhome

`dbuild` first make a recursive copy of `<DevDocker>/home` in the current selected recipe directory, renamed `myhome`, so that it can be used in the corresponding `Dockerfile`:

```
COPY myhome /myhome
RUN chmod -R 777 /myhome
```

Note : `/myhome` is meant to serve as a HOME when starting the container with `--user`. Because we do not know the user id in advance, `/myhome` is made writable to anyone.

## Pip may be a problem

When things are installed as root with `pip` in a recipe, if you run the container as
non-root, you may encounter access right problems, especially when running notebooks. 

## Root or not root

If we want the same image to be also used with apptainer, it seems it is a bad practice to define a non-root user.


# Quick and dirty recipes for `oval`

Typing `oval` or `oval l` will display the list of targets, as described in in ovalfile.py.
Each target is the association between a name and a shell command.

Typing `oval r <name>` will execute the shell command associated with the given name
One can execute several ones sequentially: `oval r <name1> <name2>...`

Typing `oval fo <name>` show the filtered part of `<name>.out`.
Typing `oval v  <name>` copy the log file `<name>.out` into the ref file `<name>.ref`.
Typing `oval d  <name>` compare the log file `<name>.out` with the ref file `<name>.ref`.
Typing `oval fo <name>` show the filtered part of `<name>.out`.
Typing `oval fr <name>` show the filtered part of `<name>.ref`.
Typing `oval c  <name>` crypt `<name>.ref` into `<name>.md5`.

One can use wildcards: `oval r <pattern1> <pattern2>...`
The only wildcard character is `%`.
One can check how a given pattern expands : `oval l <pattern>`.

On top of the targets, the configuration `ovalfile.py` can include a list of filters.
When one run several targets, only the ouput lines which match one of the filters
are displayed.


# Ressources

- https://www.redhat.com/sysadmin/arguments-options-bash-scripts
- https://fr.wikibooks.org/wiki/Programmation_Bash/Tests
- https://www.golinuxcloud.com/bash-getopts/


