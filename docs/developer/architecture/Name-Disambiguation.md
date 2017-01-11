Previously, Name conflict resolution happened all in the `Normalization` process.

Now, as items in the `CodeModel` object graph are added to the model, it disambiguates as it goes.

When a child's parent reference is changed, the child will disambiguate it's name and should ask it's children to do the same.

ie, in the `Method` class, the parent reference is the `MethodGroup` property:

``` c#
[JsonIgnore]
[NoCopy]
public MethodGroup MethodGroup
{
    get { return _parent; }
    set
    {
        // when the reference to the parent is set
        // we should disambiguate the name 
        // it is imporant that this reference gets set before 
        // the item is actually added to the containing collection.

        if (!ReferenceEquals(_parent, value))
        {
            _parent = value;
            // only perform disambiguation if this item is not already 
            // referencing the parent 
            Disambiguate();

            // and if we're adding ourselves to a new parent, better make sure 
            // our children are disambiguated too.
            Children.Disambiguate();
        }
    }
}

/// the implementation of Disambiguate 
public virtual void Disambiguate()
{
    // basic behavior : get a unique name for this method.
    var originalName = Name;

    // call the active CodeNamer, ask for a unique name for this
    var name = CodeNamer.Instance.GetUnique(
      originalName,              // the desired name
      this,                      // who is asking
      Parent.IdentifiersInScope, // the Identifiers in my parent's scope
      Parent.Children.Except(this.SingleItemAsEnumerable())); // my parent's children (except me!)

    if (name != originalName)
    {
        Name = name;
    }
}

```

