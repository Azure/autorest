using Microsoft.Rest.Generator;
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
        public SourceContext Source { get; set; }

        public SwaggerBaseValidator(SourceContext source)
        {
            Source = source;
        }

        public bool IsValid(SwaggerBase entity)
        {
            return !ValidationExceptions(entity).Any();
        }

        protected ValidationMessage CreateException(SourceContext source, ValidationExceptionNames exceptionId, params object[] messageValues)
        {
            ValidationMessage validationMessage;
            ValidationExceptionNames[] ignore = new ValidationExceptionNames[] { };
            if (ignore.Any(id => id == exceptionId))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Info,
                    Message = ""
                };
            }
            else if (ValidationExceptionConstants.Info.Messages.ContainsKey(exceptionId))
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
            yield break;
        }
    }
}
