using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Class, Inherited = true)]
    public class ValidFormatsAttribute : RuleAttribute
    {
        public override bool IsSatisfiedBy(object obj, out object[] formatParams)
        {
            bool valid = true;
            formatParams = new object[0];

            var entity = obj as SwaggerObject;
            if (entity != null)
            {
                try
                {
                    // TODO: our SwaggerObject typing system needs expanding. Currently, there's no
                    // information about how formats, etc. 
                    entity.ToType();
                }
                catch (NotImplementedException)
                {
                    valid = false;
                }
                formatParams = new object[] { entity.Type, entity.Format };
            }

            return valid;
        }

        public override ValidationException Exception
        {
            get
            {
                return ValidationException.FormatMustExist;
            }
        }
    }
}
