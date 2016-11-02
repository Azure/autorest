
Pretty much all the DI systems I've seen have some common irritants/failings that I desperately wanted to avoid:
- Fundamentally changing the object creation pattern that exists in c# -- `new` (ie, using some sort of `Factory.Create()` call to create objects, or other crappy syntax)
- having to manually control/manage "context" or `Factory` instance around, making DI the developer's problem.
- having some sort of painful configuration mechanism or syntax that makes me all stabby.

#### Pattern for object instantiation

In c# we have a couple fairly standard patterns for instantiating objects:

``` c# 
   // create an instance using a default constructor (with no parameters)
   var foo = new Foo();
 
   // create an instance with parameters:
  var foo = new Foo("Bar", 100);

  // or with an object initializer (and default constructor)
  var foo = new Foo {
    Property1 = "Happy",
    Property2 = "Daze"
  };

  // or with an object initializer with a parameterized constructor
  var foo = new Foo( "Bar", 100) {
    Property1 = "Happy",
    Property2 = "Daze"
  };
```

Unfortunately, c# doesn't have the notion of _monkey-patching_ or other ways to interrupt the constructor and return a different or derived implementation at run-time, so people have fallen back to Factory methods:

``` c# 
  // create a Foo or derivative at run-time
  var foo  = FooFactory.Create();

  // add some parameters:
  var foo  = FooFactory.Create("Bar", 100 );

  // add an initializer:
  var foo = FooFactory.Create() { 
   // Uh-oh!
   //  error CS1525: Unexpected symbol `{'
  }; 
``` 

LODIS preserves as much of the pattern as possible, so that code changes are kept to a minimum, and a developer doesn't have to understand any new concepts to follow the code.

The only thing necessary to enable LODIS is to add a `using` at the top of the file:

``` c# 
using static AutoRest.Core.Utilities.DependencyInjection;
```

and then you can use extremely similar patterns, with only small changes:

``` c# 
  // create an instance using a default constructor (with no parameters)
   var foo = New<Foo>();
 
   // create an instance with parameters:
  var foo = New<Foo>("Bar", 100);

  // or with an object initializer (and default constructor)
  var foo = New<Foo>() {
    Property1 = "Happy",
    Property2 = "Daze"
  };

  // or with an object initializer with a parameterized constructor
  var foo = New<Foo>( "Bar", 100) {
    Property1 = "Happy",
    Property2 = "Daze"
  };
``` 

Except now, I can return a different type instead of `Foo`, I can return anything that is inherited from `Foo`.

#### Contexts and Factories

LODIS :tm: supports the notion of a `Context` - essentially the ability to apply a given set of factories are to be used when a particular bit of code is executed. An active `Context`  follows the execution path, works across threads and `Task<>`s and are nestable (so activating a new `Context` will still fall back to an parent `Context` if the current `Context` doesn't have implementations for a given class.

##### Some Examples

No-context example:
``` c# 
// Even if we don't setup a context or factory first,
// we can create objects and it will fall back to 
// using the class itself.
var sc = New<SampleClass>();

// fyi: that creates an anonymous context that doesn't get disposed
// until the process ends.

// verify that we created an object
Assert.NotNull(sc);

```

Empty context:

``` c#
// a more appropriate way is to create an empty context first.
// and explicitly activating it. this will make sure that it 
// gets cleaned up.
using (new Context().Activate())
{
    // Same thing, but now we have a context
    var sc = New<SampleClass>();

    // verify that we created an object
    Assert.NotNull(sc);
```

##### Adding a Factory to a Context

A `Context` can be thought of as a a reusable collection of object factories.

``` c#
// Create a context, initialize it as a list of Factories:
var myContext = new Context
{
    // add/override our own implementations 
    new Factory<EnumType, EnumTypeCs>(),
    new Factory<Method, MethodCs>(),
    new Factory<CompositeType, CompositeTypeCs>(),
    new Factory<Parameter, ParameterTemplateCs>(),
    new Factory<Property, PropertyCs>(),
    new Factory<PrimaryType, PrimaryTypeCs>(),
    new Factory<DictionaryType, DictionaryTypeCs>(),
    new Factory<SequenceType, SequenceTypeCs>(),
    new Factory<MethodGroup, MethodGroupCs>(),
};

using (myContext.Activate() ) {
  // code executed from here will use the factories in the context.
}

// Code executed from here will not use myContext

// oh, and a Context can be reused (it's the 'Activation' that is IDisposable, not the context itself
using (myContext.Activate() ) {
  // code executed from here will use the factories in the context again.
}
```

Sometimes, tho, you'd like to run some code, rather than just substitute 
one type for another:

``` c#
var myContext = new Context {
   new Factory<CodeModel> {() => new CodeModelCs(CodeGenerator.InternalConstructors)},
};

using (myContext.Activate() ) {
   var cm = New<CodeModel>();
   // this is actually running the lambda that we specified above.
}
```

You can even do on-the-fly parameterized constructors:

``` c#
var myContext = new Context {
   new Factory<Person> {(string name,int age) => new Person() { Name = name, BirthYear= DateTime.Now.Year - age }},
};

using (myContext.Activate() ) {
   var person = New<Person>("Garrett", 45 );
   Assert.Equal( 1971, person.Birthyear);
}
```

A `Context` can also have code run at activation time:

``` c#
var myContext = new Context {
   // an action can be specified, which will be run at activation time
   () => { 
      Console.WriteLine("Context Activated!")
   }
   new Factory<Person,SuperHuman>(),
};

using (myContext.Activate() ) {
   // Console will print message!
   var person = New<Person>();
}
```

##### Object Intializers 

A lot of our code uses object intializers, so LODIS supports a similar notion--by adding an extra anonymous object parameter at the end of the `New<>` call:

``` c# 
 // without LODIS:
 var p = new Person(Name, Age) { 
    Address = "123 anywhere street",
    Vehicle = new Car("Pinto")
  };

  // with LODIS
  New<Person>(Name, Age, new{ 
    Address = "123 anywhere street",
    Vehicle = New<Car>("Pinto")
  });
```

##### Context-aware Singltons
One more last feature worth noting, is the Singleton feature:

``` c#
using (myContext.Activate() ) {
   // you can set a singleton for a Type in an active context
   // and it will be available inside this active context.
   Singleton<Settings>.Instance = new Settings(@"c:\foo\settings.txt");

   // and then you can retrieve it and use the same way:
   if ( Singleton<Settings>.Instance.IsHappy == true ) {
     // bla bla bla
   }
}
```
