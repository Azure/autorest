using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Generators.Validation;
using System;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public abstract class TypeRule<T> : Rule where T: class
    {
        public TypeRule()
        {
        }

        public override bool IsValid(object obj)
        {
            var entity = obj as T;
            return IsValid(entity);
        }

        public abstract bool IsValid(T obj);
    }
}
