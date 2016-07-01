using System;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Linq;
using System.Collections;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class RequiredPropertiesMustExist : TypedRule<Schema>
    {
        public override IEnumerable<ValidationMessage> GetValidationMessages(Schema entity)
        {
            // TODO: this doesn't take into account allOf, $ref or extends. This needs to take into account all
            // possible properties for this schema
            if (entity != null && entity.Required != null)
            {
                foreach (var req in entity.Required.Where(r => !string.IsNullOrEmpty(r)))
                {
                    Schema value = null;
                    if (entity.Properties == null || !entity.Properties.TryGetValue(req, out value))
                    {
                        yield return CreateException(Exception, req);
                    }
                }
            }
            yield break;
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.RequiredPropertiesMustExist;
            }
        }
    }
}
