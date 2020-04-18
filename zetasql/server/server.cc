#include <csignal>
#include <grpcpp/server.h>
#include <grpcpp/server_builder.h>
#include <grpcpp/server_posix.h>
#include "zetasql/local_service/local_service_grpc.h"
#include "absl/strings/str_format.h"
#include "absl/flags/flag.h"
#include "absl/flags/parse.h"


namespace zsql = ::zetasql::local_service;

ABSL_FLAG(std::string, listen_address, "127.0.0.1:5000", "server listen address");

static const ::std::string LISTEN_ADDRESS;


static grpc::Server* GetServer() {
  static grpc::Server* server = []() {
    static zsql::ZetaSqlLocalServiceGrpcImpl* service =
      new zsql::ZetaSqlLocalServiceGrpcImpl();
    grpc::ServerBuilder builder;
    builder.AddListeningPort(absl::GetFlag(FLAGS_listen_address),
      grpc::InsecureServerCredentials());
    builder.RegisterService(service);
    builder.SetMaxMessageSize(INT_MAX);
    return builder.BuildAndStart().release();
  }();
  return server;
}

void signal_handler(int signal_num) {
  GetServer()->Shutdown();
}

int main(int argc, char** argv) {
  absl::ParseCommandLine(argc, argv);
  ::std::cout << absl::StreamFormat("ZetaSQL Service Running on %s\n",
    absl::GetFlag(FLAGS_listen_address));

  auto server = GetServer();
  signal(SIGINT, signal_handler);
  signal(SIGTERM, signal_handler);

  server->Wait();
  ::std::cout << "Shutting down...\n";
  return 0;
}
