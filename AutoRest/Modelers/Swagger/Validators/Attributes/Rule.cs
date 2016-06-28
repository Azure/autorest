using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Generators.Validation;
using System.Collections.Generic;
using System;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public abstract class Rule
    {
        public Rule()
        {

        }

        public abstract bool IsValid(object obj);

        public virtual bool IsValid(object obj, out object[] formatParams)
        {
            formatParams = new object[0];
            return IsValid(obj);
        }

        public abstract ValidationException Exception { get; }
    }
}
