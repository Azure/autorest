With the great code model refactor, we're moving to a a streamlined vision for how a `CodeModel` (aka, `ServiceClient`) is turned into code.

##### Caveat: it's important to note, that the new model is still a work in progress, and I'm sure there are many more refinements that can be made.

## Basics of the `CodeModel` 

The `ServiceClient` class has been replaced with the `CodeModel` class -- this is an evolution and refinement of the classes we had before, and a restructuring so that behavior is more predictable and placed where it belongs.

##### Containment
The parent-child relationship between the parts of the model are more enforced now, when a child is added to a parent, the child's reference to the parent is set automatically, which allows for a child to navigate back up the tree.

This also means that when the child needs to disambiguate (ie, ensure that it's `Name` is ok) it can do so in the context of the information that it's parent can provide.

The `CodeModel` class is a container for `Property`s, `MethodGroup`s (aka `Operations`), `ModelTypes`s (as well as `HeaderTypes` and `ErrorTypes`), and `EnumType`s .

The `MethodGroup` contains `Method`s.

The `CompositeType` contains `Property`s

The `Method` contains `Parameter`s

Instead of exposing the child containers directly, children are added to their parents, and the parent privately manages the container. This enables the parent class to be sub-classed and override or add additional behavior on add/insert/remove operations.

``` c#
var codeModel = New<CodeModel>();
codeModel.Name = "myCodeModel";

var childObject = New<CompositeType>("child");
// you can add properties directly to the Composite Type
childObject.Add(New<Property>(new
{
    Name = "childProperty",
    ModelType = New<PrimaryType>(KnownPrimaryType.String)
}));

var customObjectType = New<CompositeType>("sample");
customObjectType.Add(New<Property>(new
{
    Name = "child",
    ModelType = childObject
}));
customObjectType.Add(New<Property>(new
{
    Name = "childList",
    ModelType = New<SequenceType>(new
    {
        ElementType = childObject
    })
}));
customObjectType.Add(New<Property>(new
{
    Name = "childDict",
    ModelType = New<DictionaryType>(new
    {
        ValueType = childObject
    })
}));

// add the composite types to the codeModel
codeModel.Add(customObjectType);
codeModel.Add(childObject);
```

#### Language Specific Implementations 
Since the introduction of the [LODIS](Least-Offensive-Dependency-Injection-System.md) we always want to try and use the most base type when constructing objects, so that the DI engine can use the appropriate type at runtime:

``` c#
  // if this is running in the context of a C# Model Transformer, it will 
  // actually use the derived type for CompositeType (likely CompositeTypeCs)
  var customObjectType = New<CompositeType>("sample");
```

##### Which brings me to a point on naming:
We're driving towards more consistency in naming of types in the `CodeModel`, and to make development clearer and less cluttered with pendantic, unclear names, language specific derivative types should **always** be named as the parent type, with a two or three letter suffix:

Examples:

| Core Type     | CSharp Type   | CSharp Azure Type |
| ------------- |:-------------:| -----------------:|
| CodeModel     | CodeModelCs   | CodeModelCsa      |
| Property      | PropertyCs    | PropertyCsa       |
| Method        | MethodCs      | MethodCsa         |

Suffixes:

| Use          | Suffix |
| ------------ |:------:|
| CSharp       | Cs     |
| CSharp Azure | Csa    |
| Java         | Jv     |
| Java Azure   | Jva    |
| Javascript   | Js     |
| js  Azure    | Jsa    |
| Ruby         | Rb     |
| Ruby Azure   | Rba    |
| Go           | Go     |
| Python       | Py     |
| Python Azure | Pya    |

#### Generator, Transformer and Namer

In order to clarify the purpose for a given class, the behavior has been split up, and responsibilities appropriately delegated:

`CodeGenerator` - It generates code. It does not modify the `CodeModel` in any way. Basically `CodeModel` in , language code out.

`CodeModelTransformer` - This can take a `CodeModel` and `Transform` it -- Takes a Codemodel, and gives back a new one that is changed. This is where language-specific **modifications** to a model take place. Behavior previously in `Normalize` methods go here.

`Namer` - All it does is provide methods to assist in the handling of names of stuff. No, `Normalization` etc.

And the `CodeModel` classes should have things appropriately overridden to provide language specific behavior that doesn't require actual Transformation of the types themselves. A perfect example of this is the `DictionaryType` class. In c# we'd use:

``` c#
public class DictionaryTypeCs : DictionaryType
{
  public DictionaryTypeCs()
  {
    // override the Name OnGet event to return a c# implementation of a Dictionary  
    Name.OnGet += v => $"System.Collections.Generic.IDictionary<string, {ValueType.AsNullableType()}>";
  }
}
```

Neat, clean, No muss, no fuss.

Plus, you'll note the use of the `OnGet` event on the Fixable<string> property -- we don't have to __change__ the value, just return the c# appropriate response. If this model was serialized and handed to another language, it'd still be usable.