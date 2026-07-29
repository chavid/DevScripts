
## About `--user`

As a developer, I use containers as providers of consistent sets of external tools.
I want to use them with local files on my computer => I want to mount the local directory (as /work).

I want to be able to run a container as any user (with --user). Such user will not pre-exist in the container. Also, some tools will want to access the home directory of the user => I need to mount this home directory and set HOME accordingly in the container.



