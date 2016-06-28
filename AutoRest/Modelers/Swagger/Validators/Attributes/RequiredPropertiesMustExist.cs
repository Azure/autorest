using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Linq;
using System.Collections;
using Microsoft.Rest.Generator.Validation;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class RequiredPropertiesMustExist : TypeRule<Schema>
    {
        public override IEnumerable<ValidationMessage> GetValidationMessages(Schema entity)
        {
            if (entity != null && entity.Required != null)
            {
                foreach (var req in entity.Required.Where(r => !string.IsNullOrEmpty(r)))
                {
                    Schema value = null;
                    if (entity.Properties == null || !entity.Properties.TryGetValue(req, out value))
                    {
                        yield return CreateException(null, Exception, req);
                    }
                }
            }
            yield break;
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
