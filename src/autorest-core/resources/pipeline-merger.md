# Default Configuration - Multi API Version Pipeline

This takes the output of the openapi2/openapi3 loaded documents,
and joins the collections back into a single pipeline (it splits at load time.)

The final step is the `flat-openapi-document/identity`, which is the pipeline input
for Multi-API version generators (ie, based using `imodeler2` ).

`flat-openapi-document` documents have `Map`s replaced with arrays,
with an `_key_` field that represented the key in the original `Map`.


Avoiding conflicts is done thru additional metadata specified in the
`x-ms-metadata` extension node.


``` yaml


```
