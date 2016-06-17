using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class SwaggerBaseValidator : IValidator<SwaggerBase>
    {
        public bool IsValid(SwaggerBase entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(SwaggerBase entity)
        {
            object clientName = null;
            if (entity.Extensions.TryGetValue("x-ms-client-name", out clientName))
            {
                var ext = clientName as Newtonsoft.Json.Linq.JContainer;
                if (ext != null && (ext["name"] == null || string.IsNullOrEmpty(ext["name"].ToString())))
                {
                    // TODO: need to have a way to include warning, error level
                    yield return new ValidationMessage()
                    {
                        Severity = LogEntrySeverity.Warning,
                        Message = Resources.EmptyClientName,
                        Source = entity
                    };
                }
                else if (string.IsNullOrEmpty(clientName as string))
                {
                    // TODO: need to have a way to include warning, error level
                    yield return new ValidationMessage()
                    {
                        Severity = LogEntrySeverity.Warning,
                        Message = Resources.EmptyClientName,
                        Source = entity
                    };
                }
            }

            yield break;
        }
    }
}
