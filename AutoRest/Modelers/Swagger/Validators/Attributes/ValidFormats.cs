using System;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class ValidFormats : TypeRule<SwaggerObject>
    {
        public override bool IsValid(SwaggerObject entity)
        {
            bool valid = true;
            //formatParams = new object[0];

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
                //formatParams = new object[] { entity.Type, entity.Format };
            }

            return valid;
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.FormatMustExist;
            }
        }
    }
}
