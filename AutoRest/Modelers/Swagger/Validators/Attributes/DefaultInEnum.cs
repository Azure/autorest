using System;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class DefaultInEnum : TypeRule<SwaggerObject>
    {
        public override bool IsValid(SwaggerObject entity)
        {
            bool valid = true;

            if (!string.IsNullOrEmpty(entity.Default) && entity.Enum != null)
            {
                // There's a default, and there's an list of valid values. Make sure the default is one 
                // of them.
                if (!entity.Enum.Contains(entity.Default))
                {
                    valid = false;
                }
            }
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
