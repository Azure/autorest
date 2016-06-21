using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Modeler.Swagger.Properties;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class ResponseValidator : SwaggerBaseValidator, IValidator<OperationResponse>
    {
        public bool IsValid(OperationResponse entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(OperationResponse entity)
        {
            //context.Direction = DataDirection.Response;
            if (entity.Headers != null)
            {
                foreach (var header in entity.Headers.Values)
                {
                    // TODO: validate headers
                    //header.Validate(context);
                }
            }

            if (entity.Reference != null)
            {
                // TODO: validate reference
                //ValidateReference(context);
            }

            if (entity.Schema != null)
            {
                // TODO: validate schema
                //Schema.Validate(context);
            }

            //context.Direction = DataDirection.None;

            yield break;
        }
    }
}
