import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AutoRestUrlTestService;

enum UriColor {
  /**
   * red color
   */
  `red color`,

  /**
   * green color
   */
  `green color`,

  /**
   * blue color
   */
  `blue color`,
}

@error
model Error {
  status?: int32;
  message?: string;
}
