import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace AutoRestUrlTestService;

@fixed
enum UriColor {
  `red color`,
  `green color`,
  `blue color`,
}

@error
model Error {
  status?: int32;
  message?: string;
}
