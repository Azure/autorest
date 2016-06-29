using System;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class DescriptionRequired : TypeRule<SwaggerObject>
    {
        public override bool IsValid(SwaggerObject obj)
        {
            bool valid = false;

            var swagObj = obj as SwaggerObject;
            if (swagObj != null)
            {
                valid = !string.IsNullOrEmpty(swagObj.Description) || !string.IsNullOrEmpty(swagObj.Reference);
            }

            return valid;
        }

        public override ValidationException Exception
        {
            get
            {
                return ValidationException.DescriptionRequired;
            }
        }
    }
}
