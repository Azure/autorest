using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Class, Inherited = true)]
    public class DefaultInEnumAttribute : RequiredAttribute
    {
        public override bool IsSatisfiedBy(object obj, out object[] formatParams)
        {
            bool valid = true;

            var entity = obj as SwaggerObject;
            if (!string.IsNullOrEmpty(entity.Default) && entity.Enum != null)
            {
                // There's a default, and there's an list of valid values. Make sure the default is one 
                // of them.
                if (!entity.Enum.Contains(entity.Default))
                {
                    valid = false;
                }
            }
            formatParams = null;
            return valid;
        }

        public override ValidationException Exception
        {
            get
            {
                return ValidationException.DefaultMustAppearInEnum;
            }
        }
    }
}
