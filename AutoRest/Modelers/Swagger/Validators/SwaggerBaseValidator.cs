using Microsoft.Rest.Generator.Logging;
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
        public bool IsValid(SwaggerBase entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        protected ValidationMessage CreateException(object entity, ValidationExceptionConstants.Exceptions exceptionId, params object[] messageValues)
        {
            ValidationMessage validationMessage;
            if (ValidationExceptionConstants.Info.Messages.ContainsKey(exceptionId))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Warning,
                    Message = string.Format(CultureInfo.InvariantCulture, ValidationExceptionConstants.Warnings.Messages[exceptionId], messageValues)
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
                    Message = string.Format(CultureInfo.InvariantCulture, ValidationExceptionConstants.Warnings.Messages[exceptionId], messageValues)
                };
            }
            else
            {
                throw new NotImplementedException();
            }

            validationMessage.Source = entity;
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
