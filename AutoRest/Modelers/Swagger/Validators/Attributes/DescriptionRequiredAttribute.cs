using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Class, Inherited = true)]
    public class DescriptionRequiredAttribute : RequiredAttribute
    {
        public override bool IsSatisfiedBy(object obj, out object[] formatParams)
        {
            bool valid = false;

            var swagObj = obj as SwaggerObject;
            if (swagObj != null)
            {
                valid = !string.IsNullOrEmpty(swagObj.Description) || !string.IsNullOrEmpty(swagObj.Reference);
            }

            formatParams = null;
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
