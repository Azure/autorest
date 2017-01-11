In the AutoRest code model, we have fair number of properties that are derived from an initial value, yet when serializing/deserializing the code model to `JSON` we'd like to preserve the original value throughout the thru out the pipeline as much as we can, but sometimes we still need to be able to override it, and declare that the value, fixed for all time.

I experimented with several different ways to accomplish this, and came up with a wrapper class called `Fixable` that solves it in the least-invasive means possible, and provides a consistent pattern that still leaves as much power and flexibility in the hands of the developer.

### Creating a Fixable property

In a class, `Fixable<T>` should always be used the same way:

``` c# 

public class Fruit {
  // the backing field should **always** be:
  //  - private 
  //  - readonly
  //  - constructed with the default constructor
  private readonly Fixable<string> _description = new Fixable<string>();

  // the property accessors should **always** be the exact same pattern:
  public Fixable<string> Description 
  {
     get { return _summary; }
     set { _description.CopyFrom(value); }
  }

  public Fruit() {
    // you can set OnGet and OnSet event handlers on the object in the constructor 
    // and generally, you should be using OnGet almost all of the time. OnSet is 
    // only there for very special cases.
    Description.OnGet += value => value?.ToUpper() ?? string.Empty;
  }
}

public class SomeTest {
  [Fact]
  public void TestFruitDescription() {
    var fruit1 = new Fruit();

    // Description can be used pretty much as a regular string property
    fruit1.Description = "Tasty";

    // the value will be returned as upper case because of the OnGet.
    Assert.Equal("TASTY",fruit1.Description");
  }

  [Fact]
  public void TestFruitDescriptionFixed() {
    var fruit2 = new Fruit();

    // Description can be used pretty much as a regular string property
    fruit2.Description.Fixed = "Tasty";

    // the value will be returned, as we explicitly fixed the value to 'Tasty'
    Assert.Equal("Tasty",f.Description");
  }
}

```

The real beauty is that if you serialize the `fruit1` object in JSON, you will see this:

``` JSON
{
  "#description" : "Tasty"
}
```

And the fruit2:

``` JSON
{
  "description" : "Tasty"
}
```

The `#` symbol in the JSON property name indicates the actual value of the field is calculated based on the value given. Without the `#`, the property value is fixed, and will not go thru the `.OnGet` event handler.

This makes it possible to preserve the original value as long as possible where subclasses of `Fruit` can add `.OnGet` event handlers and change the value to whatever they want, yet at any point along the way, if the value should be fixed it's pretty easy to do so.  Even tools that parse the JSON can make changes and still choose to allow the subsequent uses to be tweaked appropriately 

#### Example:

In processing a code model, a `Method` might have a name as `"do-operation"` ... at some point, an external tool may add a duplicate method but prefix it with 'Try-', but still expect the eventual language code generator to make the name the appropriate case for the language.

// original model
``` json 
{
  methods: [
    {  
      "#name" : "do-operation"
    } 
  ] 
}
```

After some processing:

``` json 
{
  methods: [
    {  
      "#name" : "do-operation"
    },
    {  
      "#name" : "Try-do-operation"
    } 
  ] 
}
```

When the C# code generator actually generates the methods, it will apply the Pascal Casing to the methods and you'd end up with

``` c#
public class MyClass {
  public void DoOperation() { ... }
  public void TryDoOperation() { ... }
}
```