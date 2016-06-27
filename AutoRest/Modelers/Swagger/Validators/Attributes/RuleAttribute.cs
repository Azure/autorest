using Microsoft.Rest.Generators.Validation;
using System;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public abstract class RuleAttribute : Attribute
    {
        public abstract ValidationException Exception { get; }

        public abstract bool IsSatisfiedBy(object obj, out object[] formatParams);
    }
}
