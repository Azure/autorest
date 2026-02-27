import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace ComplexModelClient;

model CatalogArray {
  /** Array of products */
  productArray?: Product[];
}

/** The product documentation. */
model Product {
  /**
   * Unique identifier representing a specific product for a given latitude &
   * longitude. For example, uberX in San Francisco will have a different product_id
   * than uberX in Los Angeles.
   */
  product_id?: string;

  /** Description of product. */
  description?: string;

  /** Display name of product. */
  display_name?: string;

  /** Capacity of product. For example, 4 people. */
  capacity?: string = "100";

  /** Image URL representing the product. */
  image?: string;
}

@error
model Error {
  status?: int32;
  message?: string;
}

model CatalogDictionaryOfArray {
  /** Dictionary of Array of product */
  productDictionaryOfArray?: Record<Product[]>;
}

model CatalogDictionary {
  /** Dictionary of products */
  productDictionary?: Record<Product>;
}

model CatalogArrayOfDictionary {
  /** Array of dictionary of products */
  productArrayOfDictionary?: Record<Product>[];
}

model Attributes {
  /** Determines whether the object is enabled. */
  enabled?: boolean;

  /** Not before date in seconds since 1970-01-01T00:00:00Z. */
  @encode("unixTimestamp", int32)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  nbf?: utcDateTime;
}
