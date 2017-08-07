# x-ms-discriminator-value
The x-ms-discriminator-value extension is an add-on to the discriminator feature in swagger. This allows us to provide an alias for the base class type using which one can polymorphically capture from the data. For a detailed explanation about polymorphism in swagger, click [here](https://gist.github.com/leedm777/5730877#polymorphism)

### Example
Consider the petstore example as described in [x-ms-discriminator.yaml]() The service addPet accepts any model of the kind "petKind". The model "Pet" is inherited by models "Cat" and "Dog" which in turn specify the x-ms-discriminator-value as "Microsoft.PetStore.PetType". This translates as types "Cat" and "Dog" will be polymorphically represented by "Microsoft.PetStore.PetType" instead of "petKind"

 	

```
[Newtonsoft.Json.JsonObject("Microsoft.PetStore.PetType")]
public partial class Dog : Pet
{ 
```

### When to use
At times the base class type name may not accurately describe the kind of data you are trying to pass/receive and needs to have a more verbose/different string to represent it.
Conversely certain base types, which may be x-ms-external may have quite a long name and may need to be shortened for better readability in the client code.
In either case, x-ms-discriminator-value is a useful option