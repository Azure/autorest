using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Linq;
using System.Collections;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class AnonymousTypes : TypeRule<SwaggerObject>
    {
        public override bool IsValid(SwaggerObject entity)
        {
            bool valid = true;

            if (string.IsNullOrEmpty(entity.Reference))
            {
                valid = false;
            }

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
