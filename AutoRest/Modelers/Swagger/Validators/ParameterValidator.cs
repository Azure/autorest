using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class ParameterValidator : SwaggerObjectValidator, IValidator<SwaggerParameter>
    {
        public ParameterValidator(SourceContext source) : base(source)
        {
        }

        public bool IsValid(SwaggerParameter entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(SwaggerParameter entity)
        {
            //context.Direction = DataDirection.Request;

            foreach (var exception in base.ValidationExceptions(entity))
            {
                yield return exception;
            }

            switch (entity.In)
            {
                case ParameterLocation.Body:
                    {
                        if (entity.Schema == null)
                        {
                            yield return CreateException(entity.Source, ValidationExceptionName.BodyMustHaveSchema);
                        }
                        if ((entity.Type.HasValue && entity.Type != DataType.None) ||
                            !string.IsNullOrEmpty(entity.Format) ||
                            entity.Items != null ||
                            entity.CollectionFormat != Generator.ClientModel.CollectionFormat.None ||
                            !string.IsNullOrEmpty(entity.Default) ||
                            !string.IsNullOrEmpty(entity.Pattern))
                        {
                            yield return CreateException(entity.Source, ValidationExceptionName.BodyMustNotHaveType);
                        }
                        break;
                    }
                case ParameterLocation.Header:
                    {
                        // Header parameters should have a client name explicitly defined.
                        object clientName = null;
                        if (!entity.Extensions.TryGetValue("x-ms-client-name", out clientName) || !(clientName is string))
                        {
                            yield return CreateException(entity.Source, ValidationExceptionName.HeaderShouldHaveClientName);
                        }
                        if (entity.Schema != null)
                        {
                            yield return CreateException(entity.Source, ValidationExceptionName.InvalidSchemaParameter);
                        }
                        break;
                    }
                default:
                    {
                        if (entity.Schema != null)
                        {
                            yield return CreateException(entity.Source, ValidationExceptionName.InvalidSchemaParameter);
                        }
                        break;
                    }
            }

            if (!string.IsNullOrEmpty(entity.Reference))
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
