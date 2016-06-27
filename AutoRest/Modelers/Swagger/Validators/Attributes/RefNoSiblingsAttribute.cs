using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Class, Inherited = true)]
    public class RefNoSiblingsAttribute : RequiredAttribute
    {
        public override bool IsSatisfiedBy(object obj, out object[] formatParams)
        {
            bool valid = true;

            var entity = obj as SwaggerObject;

            if (!string.IsNullOrEmpty(entity.Reference) &&
                (
                entity.Description != null ||
                entity.Items != null ||
                entity.Type != null
                ))
            {
                valid = false;
            }

            formatParams = new object[0];
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
