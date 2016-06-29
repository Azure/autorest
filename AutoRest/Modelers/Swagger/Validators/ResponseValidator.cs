using Microsoft.Rest.Modeler.Swagger.Model;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class ResponseValidator : SwaggerBaseValidator, IValidator<OperationResponse>
    {
        public ResponseValidator(SourceContext source) : base(source)
        {
        }

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
