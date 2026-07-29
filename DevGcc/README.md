
My ideal development requirements:
- mount the current directory as /work in the image
- can start with `docker run`, `docker run --user`, `podman run`.
- created local files have the right owner/group !

This seems to imply (for podman), that anything in the image should installed
as `root` at the system level. Problem : more and more often, python/pip
installations forbid to be root :(

I currently starts from gcc:15.2.0-trixie (debian 13).



