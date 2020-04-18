#!/bin/bash

BUILD_DIR=./python
mkdir $BUILD_DIR

./bazel-out/host/bin/external/com_google_protobuf/protoc \
	--python_out=$BUILD_DIR \
	--mypy_out=$BUILD_DIR \
	--proto_path=$BUILD_DIR \
    -Ibazel-bin/protos \
    bazel-bin/protos/zetasql/local_service/*.proto \
    bazel-bin/protos/zetasql/proto/*.proto \
    bazel-bin/protos/zetasql/public/*.proto \
    bazel-bin/protos/zetasql/public/proto/*.proto \
    bazel-bin/protos/zetasql/resolved_ast/*.proto

./bazel-out/host/bin/external/com_google_protobuf/protoc \
	--python_grpc_out=$BUILD_DIR \
	--proto_path=$BUILD_DIR \
    -Ibazel-bin/protos \
    bazel-bin/protos/zetasql/local_service/local_service.proto

touch $BUILD_DIR/zetasql/py.typed

# give our subpackages __init__.py files...
find $BUILD_DIR/zetasql -type d -not -path $BUILD_DIR/zetasql -exec touch {}/__init__.py \;
