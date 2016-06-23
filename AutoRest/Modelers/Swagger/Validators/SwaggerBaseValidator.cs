using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger
{
    public class SwaggerBaseValidator : IValidator<SwaggerBase>
    {
        public SourceContext Source { get; set; }

        public SwaggerBaseValidator(SourceContext source)
        {
            Source = source;
        }

        public bool IsValid(SwaggerBase entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        protected ValidationMessage CreateException(SourceContext source, ValidationException exceptionId, params object[] messageValues)
        {
            ValidationMessage validationMessage;
            if (ValidationExceptionConstants.Info.Messages.ContainsKey(exceptionId))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Warning,
                    Message = string.Format(CultureInfo.InvariantCulture, ValidationExceptionConstants.Info.Messages[exceptionId], messageValues)
                };
            }
            else if (ValidationExceptionConstants.Warnings.Messages.ContainsKey(exceptionId))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Warning,
                    Message = string.Format(CultureInfo.InvariantCulture, ValidationExceptionConstants.Warnings.Messages[exceptionId], messageValues)
                };
            }
            else if (ValidationExceptionConstants.Errors.Messages.ContainsKey(exceptionId))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Warning,
                    Message = string.Format(CultureInfo.InvariantCulture, ValidationExceptionConstants.Errors.Messages[exceptionId], messageValues)
                };
            }
            else
            {
                throw new NotImplementedException();
            }

            validationMessage.Source = source;
            validationMessage.ValidationException = exceptionId;
            return validationMessage;
        }

        public IEnumerable<ValidationMessage> ValidationExceptions(SwaggerBase entity)
        {
            object clientName = null;
            if (entity != null && entity.Extensions != null && entity.Extensions.TryGetValue("x-ms-client-name", out clientName))
            {
                var ext = clientName as Newtonsoft.Json.Linq.JContainer;
                if (ext != null && (ext["name"] == null || string.IsNullOrEmpty(ext["name"].ToString())))
                {
                    yield return CreateException(entity.Source, ValidationException.ClientNameMustNotBeEmpty);
                }
                else if (string.IsNullOrEmpty(clientName as string))
                {
                    yield return CreateException(entity.Source, ValidationException.ClientNameMustNotBeEmpty);
                }
            }

            yield break;
        }
    }
}
