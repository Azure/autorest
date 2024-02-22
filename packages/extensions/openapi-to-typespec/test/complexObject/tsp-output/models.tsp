import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace ComplexModelClient;

model CatalogArray {
  /**
   * Array of products
   */
  productArray?: Product[];
}

/**
 * The product documentation.
 */
model Product {
  /**
   * Unique identifier representing a specific product for a given latitude &
   * longitude. For example, uberX in San Francisco will have a different product_id
   * than uberX in Los Angeles.
   */
  @encodedName("application/json", "product_id")
  productId?: string;

  /**
   * Description of product.
   */
  description?: string;

  /**
   * Display name of product.
   */
  @encodedName("application/json", "display_name")
  displayName?: string;

  /**
   * Capacity of product. For example, 4 people.
   */
  capacity?: string = "100";

  /**
   * Image URL representing the product.
   */
  image?: string;
}

@error
model Error {
  status?: int32;
  message?: string;
}

model CatalogDictionaryOfArray {
  /**
   * Dictionary of Array of product
   */
  productDictionaryOfArray?: Record<Product[]>;
}

model CatalogDictionary {
  /**
   * Dictionary of products
   */
  productDictionary?: Record<Product>;
}

model CatalogArrayOfDictionary {
  /**
   * Array of dictionary of products
   */
  productArrayOfDictionary?: Record<Product>[];
}
