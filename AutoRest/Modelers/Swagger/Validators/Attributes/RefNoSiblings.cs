using System;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class RefNoSiblings : TypeRule<SwaggerObject>
    {
        public override bool IsValid(SwaggerObject entity)
        {
            bool valid = true;

            if (!string.IsNullOrEmpty(entity.Reference) &&
                (
                entity.Description != null ||
                entity.Items != null ||
                entity.Type != null
                ))
            {
                valid = false;
            }

            return valid;
        }

        public override ValidationException Exception
        {
            get
            {
                return ValidationException.RefsMustNotHaveSiblings;
            }
        }
    }
}
