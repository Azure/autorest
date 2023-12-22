import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace ComplexModelClient;

model CatalogArray {
  @doc("Array of products")
  productArray?: Product[];
}

@doc("The product documentation.")
model Product {
  @doc("""
Unique identifier representing a specific product for a given latitude &
longitude. For example, uberX in San Francisco will have a different product_id
than uberX in Los Angeles.
""")
  @projectedName("json", "product_id")
  productId?: string;

  @doc("Description of product.")
  description?: string;

  @doc("Display name of product.")
  @projectedName("json", "display_name")
  displayName?: string;

  @doc("Capacity of product. For example, 4 people.")
  capacity?: string;

  @doc("Image URL representing the product.")
  image?: string;
}

@error
model Error {
  status?: int32;
  message?: string;
}

model CatalogDictionaryOfArray {
  @doc("Dictionary of Array of product")
  productDictionaryOfArray?: Record<Product[]>;
}

model CatalogDictionary {
  @doc("Dictionary of products")
  productDictionary?: Record<Product>;
}

model CatalogArrayOfDictionary {
  @doc("Array of dictionary of products")
  productArrayOfDictionary?: Record<Product>[];
}
