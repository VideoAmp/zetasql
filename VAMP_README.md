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

Service
-------

The remote grpc service is a simple wrapper around the `local_service`
C++ code provided by Google.

By default, it listens on port `127.0.0.1:5000`, and there is a command flag
to change this `--listen-address` that also supports unix sockets.


Commands
--------

There are a few new bazel build targets:

	$ bazel build //zetasql/server # builds the server
	$ bazel build //protos # collects protos file

To build the docker container locally:

	$ docker build -t zetasql -f Dockerfile.server .

This build is very large and will take 15-30 minutes depending on your
hardware. The build is purposefully constrained so that bazel does not bust the
memory limits of the docker environment and cause OOM errors.


Python GRPC Library
-------------------

Right now this is built and released by hand. First, update `python/setup.py`
with the version matching the tag of the ZetaSQL release. Then:

	$ pip install --user -r requirements.txt
	$ ./gen_py_proto.sh
	$ cd python
	$ pip wheel .

Then we commit, push (merge) and upload the wheel under a new tag as a Github
release manually, and our client applications pull from that release.

TODO
----

* Automate the python library build and release into cloudbuild.
* Publish it to an internal artifactory for proper distribution.
* When the bazel ecosystem settles down, use bazel to build everything...
* Decide upon release cadence and methodology.
