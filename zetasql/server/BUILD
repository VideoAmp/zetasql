# ZetaSQL Server
package(default_visibility = ["//visibility:public"])

cc_binary(
    name = "server",
    srcs = ["server.cc"],
    deps = [
        "//zetasql/local_service:local_service_grpc",
        "@com_github_grpc_grpc//:grpc++",
        "@com_google_absl//absl/flags:flag",
        "@com_google_absl//absl/flags:parse",
        "@com_google_absl//absl/strings:str_format",
    ],
)
