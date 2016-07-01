using System;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Linq;
using System.Collections;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class AnonymousTypes : TypedRule<SwaggerObject>
    {
        public override bool IsValid(SwaggerObject entity)
        {
            bool valid = true;

            if (entity != null && string.IsNullOrEmpty(entity.Reference))
            {
                valid = false;
            }

            return valid;
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.AnonymousTypesDiscouraged;
            }
        }
    }
}
