using System;
using Microsoft.Rest.Generators.Validation;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Class, Inherited = true)]
    public class DescriptionRequiredAttribute : RequiredAttribute
    {
        public override ValidationException Exception
        {
            get
            {
                return ValidationException.DescriptionRequired;
            }
        }
    }
}
