VIRTUAL_IMPORTS = "_virtual_imports"

def _get_real_short_path(file):
    # For some reason, files from other archives have short paths that look like:
    # ../com_google_protobuf/_virtual_imports/descriptor_proto/google/protobuf/descriptor.proto
    # gbean is pretty sure we are doing something wrong here...
    if file.is_source:
        return file.short_path
    # generated file, i.e. an imported file
    # so we strip the prefixes from the path
    short_path = file.short_path
    if VIRTUAL_IMPORTS in short_path:
        # given a short path like
        # ../com_google_protobuf/_virtual_imports/descriptor_proto/google/protobuf/descriptor.proto
        # we want to extract google/protobuf/descriptor.proto

        # strip off _virtual_imports
        virtual_path = short_path.index(VIRTUAL_IMPORTS) + len(VIRTUAL_IMPORTS)
        short_path = short_path[virtual_path + 1:]

        # now strip off the packaged name
        next_slash = short_path.index("/")
        short_path = short_path[next_slash + 1:]
    return short_path

def _protos_impl(ctx):
    """Rule to copy all protos to a single output directory."""
    proto_files = []
    for dep in ctx.attr.deps:
        proto_files.extend(dep[ProtoInfo].transitive_sources.to_list())

    outputs = []
    for f in proto_files:
        short_path = _get_real_short_path(f)
        print(short_path)
        out = ctx.actions.declare_file(short_path)
        outputs.append(out)
        ctx.actions.run_shell(
            outputs = [out],
            inputs = depset([f]),
            arguments = [f.path, out.path],
            command = "cp $1 $2",
        )
    return [
        DefaultInfo(
            files = depset(outputs),
            data_runfiles = ctx.runfiles(files = outputs),
        ),
    ]

protos = rule(
    implementation = _protos_impl,
    attrs = {
        "deps": attr.label_list(providers = [ProtoInfo]),
    },
)
