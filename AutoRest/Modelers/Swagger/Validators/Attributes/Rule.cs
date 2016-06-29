using System.Collections.Generic;
using System;
using Microsoft.Rest.Generator;
using System.Linq;
using Microsoft.Rest.Generator.Logging;
using System.Globalization;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public abstract class Rule
    {
        public Rule()
        {

        }

        public abstract IEnumerable<ValidationMessage> GetValidationMessages(object obj);

        public virtual IEnumerable<ValidationMessage> GetValidationMessages(object obj, out object[] formatParams)
        {
            formatParams = new object[0];
            return GetValidationMessages(obj);
        }

        public abstract ValidationException Exception { get; }

        protected ValidationMessage CreateException(SourceContext source, ValidationException exceptionId, params object[] messageValues)
        {
            ValidationMessage validationMessage;
            ValidationException[] ignore = new ValidationException[] {};
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
                    Severity = LogEntrySeverity.Info,
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
                    Severity = LogEntrySeverity.Error,
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

    }
}
