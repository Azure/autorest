using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Modeler.Swagger.Properties;
using Microsoft.Rest.Generator.Validation;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class ResponsesValidator : SwaggerBaseValidator, IValidator<Dictionary<string, OperationResponse>>
    {
        public bool IsValid(Dictionary<string, OperationResponse> entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(Dictionary<string, OperationResponse> entity)
        {
            if (entity == null || entity.Count == 0)
            {
                yield return new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Error,
                    Message = string.Format(CultureInfo.InvariantCulture, Resources.NoResponses),
                    Source = entity
                };
            }
            else
            {
                foreach (var response in entity)
                {
                    var responseValidator = new ResponseValidator();
                    foreach (var exception in responseValidator.ValidationExceptions(response.Value))
                    {
                        yield return exception;
                    }
                }
            }
        }
    }
}
