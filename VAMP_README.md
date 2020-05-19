ZetaSQL GRPC Service
====================

This repository is a fork of Google's ZetaSQL project.

A few things have been added

* A C++ GRPC Service, and cloudbuild tooling
  to build a Docker container for it.
* A `protos/` directory which contains bazel build instructions to
  collect the protobuf files used by `zetasql/server` into
  a single output directory for generating client libraries.
* An `async` Python GRPC client library, with type hints, and
  the tooling to generate it.

We've tried to do this in a manner that makes pulling the upstream changes as
painless as possible, e.g. via adding files instead of editing existing ones.


Versioning
----------

The upstream Google repository has established a version tagging scheme that we
try to closely follow. It is of the form `YYYY.MM.BUILD_NO` - a four digit year
followed by the two digit month, and finally the build number for the month.

Our versioning will follow the same scheme, with an extra revision number on
the end indicating our own build number.

For example, if the last upstream version was `2020.03.1` and we have made
zero changes since merging that tag into this repository, the tag is the same.

If we need to release a change between upstream releases, we will add an
additional build number to the end, the example given would become
`20202.03.1.1` indicating that there has been 1 update on top of the
`2020.03.1` upstream release.

The python client library is versioned using a normalized PEP440 format of
this tag, e.g. `2020.03.1.1` becomes `2020.3.1.1`.

Service
-------

The remote grpc service is a simple wrapper around the `local_service`
C++ code provided by Google.

By default, it listens on port `127.0.0.1:5000`, and there is a command flag
to change this `--listen-address` that also supports unix sockets.

Dependencies
--------

To build locally on macOS you will need the following packages installed.

```console
brew install autoconf
brew install automake
brew install c-ares
brew install clang-format
brew install cmake
brew install gnu-sed
brew install icu4c
brew install libtool
# Install Bazel
brew tap bazelbuild/tap
brew install bazelbuild/tap/bazel
# Install Openjdk8 from cask
brew cask install adoptopenjdk/openjdk/adoptopenjdk8
# Makes running bazel easier
brew install bazelisk
brew install ruby
```

In addition make sure you have Xcode installed.

Commands
--------

There are a few new bazel build targets:

```console
bazelisk build //zetasql/server # builds the server
bazelisk build //protos:local_service # builds protos for local_service and outputs to bazel-bin
```

To build the docker container locally:

```console
docker build -t zetasql -f Dockerfile.server .
```

This build is very large and will take 15-30 minutes depending on your
hardware. The build is purposefully constrained so that bazel does not bust the
memory limits of the docker environment and cause OOM errors.


Python GRPC Library
-------------------

Right now this is built and released by hand. Versioning is done automatically
and closely follows the upstream tags, but normalized by setuptools.

```console
pyenv install 3.7
pyenv virtualenv 3.7
pyenv activate 3.7
pip install -r requirements.txt
./gen_py_proto.sh
pip wheel . -w wheels
```

Then upload the wheel under the upstream tag as a Github
release manually, and our client applications pull from that release.

TODO
----

* Automate the python library build and release into cloudbuild.
* Publish it to an internal artifactory for proper distribution.
* When the bazel ecosystem settles down, use bazel to build everything...
* Decide upon release cadence and methodology.
