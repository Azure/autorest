using System;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Linq;
using System.Collections;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class AnonymousParameterTypes : TypedRule<SwaggerParameter>
    {
        public override bool IsValid(SwaggerParameter entity)
        {
            bool valid = true;

            if (entity != null && entity.Schema != null)
            {
                var anonymousTypesRule = new AnonymousTypes();
                valid = anonymousTypesRule.IsValid(entity.Schema);
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
