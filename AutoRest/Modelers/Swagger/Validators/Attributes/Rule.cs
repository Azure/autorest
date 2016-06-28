using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Generators.Validation;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public abstract class Rule
    {
        public Rule()
        {

        }

        public abstract bool IsValid(object obj);

        public abstract ValidationException Exception { get; }
    }
}
