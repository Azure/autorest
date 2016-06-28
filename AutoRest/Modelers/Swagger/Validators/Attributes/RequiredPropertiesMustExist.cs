using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class RequiredPropertiesMustExist : TypeRule<Schema>
    {
        public override bool IsValid(Schema entity, out object[] formatParams)
        {
            bool valid = true;

            if (entity != null && entity.Required != null)
            {
                foreach (var req in entity.Required.Where(r => !string.IsNullOrEmpty(r)))
                {
                    Schema value = null;
                    if (entity.Properties == null || !entity.Properties.TryGetValue(req, out value))
                    {
                        valid = false;
                    }
                }
            }

            formatParams = new object[] { string.Empty };
            return valid;
        }

        public override ValidationException Exception
        {
            get
            {
                return ValidationException.RequiredPropertiesMustExist;
            }
        }
    }
}
