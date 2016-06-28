using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Linq;
using System.Collections;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class AnonymousTypes : TypeRule<Schema>
    {
        public override bool IsValid(Schema obj)
        {
            bool valid = true;

            return valid;
        }

        public override ValidationException Exception
        {
            get
            {
                return ValidationException.AnonymousTypesDiscouraged;
            }
        }
    }
}
