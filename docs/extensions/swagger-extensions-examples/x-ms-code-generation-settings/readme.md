# x-ms-code-generation-settings
The x-ms-code-generation-settings allows options like code headers, date-time offset and generating internal constructors for the operations

### Example
Consider the petstore example as described in [x-ms-discriminator.yaml]() The service Pet_GetPetById takes in the id in of the pet and gets details about it. The code generated will have internal constructors when the corresponding flag is set to "true"

 	

```
internal PetOperations(PetStoreInc client)
{
    if (client == null) 
    {
```