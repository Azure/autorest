using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class SwaggerObjectValidator : IValidator<SwaggerObject>
    {
        public bool IsValid(SwaggerObject entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(SwaggerObject entity)
        {
            if (string.IsNullOrEmpty(entity.Description) && string.IsNullOrEmpty(entity.Reference))
            {
                // TODO: need to have a way to include warning, error level
                yield return new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Warning,
                    Message = Resources.MissingDescription,
                    Source = entity
                };
            }

            if (!string.IsNullOrEmpty(entity.Default) && entity.Enum != null)
            {
                // THere's a default, and there's an list of valid values. Make sure the default is one 
                // of them.
                if (!entity.Enum.Contains(entity.Default))
                {
                    yield return new ValidationMessage()
                    {
                        Message = Resources.InvalidDefault,
                        Severity = LogEntrySeverity.Error,
                        Source = entity
                    };
                }
            }
            yield break;
        }
    }
}
