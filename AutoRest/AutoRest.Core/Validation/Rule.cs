using System.Collections.Generic;
using System;
using System.Linq;
using Microsoft.Rest.Generator.Logging;
using System.Globalization;

namespace Microsoft.Rest.Generator
{
    /// <summary>
    /// Defines validation logic for an object
    /// </summary>
    public abstract class Rule
    {
        protected Rule()
        {
        }

        public abstract IEnumerable<ValidationMessage> GetValidationMessages(object entity);

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1021:AvoidOutParameters", MessageId = "1#")]
        public virtual IEnumerable<ValidationMessage> GetValidationMessages(object entity, out object[] formatParameters)
        {
            formatParameters = new object[0];
            return GetValidationMessages(entity);
        }

        public abstract ValidationExceptionName Exception { get; }

        protected static ValidationMessage CreateException(SourceContext source, ValidationExceptionName exceptionId, params object[] messageValues)
        {
            ValidationMessage validationMessage;
            ValidationExceptionName[] ignore = new ValidationExceptionName[] { };
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
