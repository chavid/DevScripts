#!/bin/bash

#git clone -b llvmorg-8.0.0 https://github.com/llvm/llvm-project.git

cd llvm-project
./llvm/utils/docker/build_docker_image.sh \
    -s debian8 -d `cat ../image-name.txt` -t `cat ../image-tag.txt` \
    --branch llvmorg-`cat ../image-tag.txt` \
    -p clang -i install-clang -i install-clang-resource-headers \
    -- \
    -DCMAKE_BUILD_TYPE=Release

# docker build  -f Dockerfile -t `cat image.txt` .
# --force-rm --no-cache