using System;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class DescriptionRequired : TypedRule<SwaggerObject>
    {
        public override bool IsValid(SwaggerObject entity)
        {
            bool valid = false;

            if (entity != null)
            {
                valid = !string.IsNullOrEmpty(entity.Description) || !string.IsNullOrEmpty(entity.Reference);
            }

            return valid;
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.DescriptionRequired;
            }
        }
    }
}
