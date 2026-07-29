#!/bin/bash
# Flask opère sur le port 5000
docker run -it --rm -v $PWD/..:/work -w /work `cat image-name.txt`:`cat image-tag.txt` $*

 