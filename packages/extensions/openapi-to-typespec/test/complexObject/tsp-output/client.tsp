import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using ComplexModelClient;

@@clientName(Product.product_id, "productId");
@@clientName(Product.display_name, "displayName");

@@clientName(Attributes.nbf, "notBefore");

@@clientName(list, "list");
@@clientName(create, "create");
@@clientName(update, "update");
