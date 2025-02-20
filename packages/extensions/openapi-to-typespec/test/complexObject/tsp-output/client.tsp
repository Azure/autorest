import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using ComplexModelClient;

@@clientName(Product.product_id, "productId");
@@clientName(Product.display_name, "displayName");

@@clientName(Attributes.nbf, "notBefore");
