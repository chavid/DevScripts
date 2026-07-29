
Those commands are meant to be launched within the `docker` directory. Each time a significant change is made to the `Dockerfile`, please increase the version number in `image.txt`.

* build.sh : build a local image.
* run.sh : run the local image, mounting `..` as `/work`.
* push.sh : once image is stable and shareable, push it to `gitlab.in2p3.fr`.


# llvm-project/llvm/utils/docker/build_docker_image.sh

## Usage
```
build_docker_image.sh [options] [-- [cmake_args]...]
```

## General options
```
    -h|--help               show this help message
```

## Docker-specific options
```
    -s|--source             image source dir (i.e. debian8, nvidia-cuda, etc)
    -d|--docker-repository  docker repository for the image
    -t|--docker-tag         docker tag for the image
```

Required: --source and --docker-repository.

## Checkout arguments options
```
    -b|--branch         svn branch to checkout, i.e. 'trunk',
                        'branches/release_40'
                        (default: 'trunk')
    -r|--revision       svn revision to checkout
    -c|--cherrypick     revision to cherry-pick. Can be specified multiple times.
                        Cherry-picks are performed in the sorted order using the
                        following command:
                        'svn patch <(svn diff -c $rev)'.
    -p|--llvm-project   name of an svn project to checkout. Will also add the
                        project to a list LLVM_ENABLE_PROJECTS, passed to CMake.
                        For clang, please use 'clang', not 'cfe'.
                        Project 'llvm' is always included and ignored, if
                        specified.
                        Can be specified multiple times.
    -c|--checksums      name of a file, containing checksums of llvm checkout.
                        Script will fail if checksums of the checkout do not
                        match.
```

## Build-specific options
```
    -i|--install-target name of a cmake install target to build and include in
                        the resulting archive. Can be specified multiple times.
```

Required: at least one `--install-target`.

## CMake options

All options after '--' are passed to CMake invocation.

## Examples

For example, running:

```sh
$ build_docker_image.sh -s debian8 -d mydocker/debian8-clang -t latest \ 
  -p clang -i install-clang -i install-clang-headers
```

will produce two docker images:

* `mydocker/debian8-clang-build:latest`: an intermediate image used to compile clang.
* `mydocker/clang-debian8:latest`: a small image with preinstalled clang.

Please note that this example produces a not very useful installation, since it
doesn't override CMake defaults, which produces a Debug and non-boostrapped
version of clang.

To get a 2-stage clang build, you could use this command:

```sh
$ ./build_docker_image.sh -s debian8 -d mydocker/clang-debian8 -t "latest" \ 
    -p clang -i stage2-install-clang -i stage2-install-clang-headers \ 
    -- \ 
    -DLLVM_TARGETS_TO_BUILD=Native -DCMAKE_BUILD_TYPE=Release \ 
    -DBOOTSTRAP_CMAKE_BUILD_TYPE=Release \ 
    -DCLANG_ENABLE_BOOTSTRAP=ON \ 
    -DCLANG_BOOTSTRAP_TARGETS="install-clang;install-clang-headers"
```
