using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Validation;
using Microsoft.Rest.Generators.Validation;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, AllowMultiple = true, Inherited = true)]
    public class RuleAttribute : Attribute
    {
        private Rule Rule;

        public RuleAttribute(Type type)
        {
            if (typeof(Rule).IsAssignableFrom(type))
            {
                Rule = (Rule)Activator.CreateInstance(type);
            }
        }

        public virtual IEnumerable<ValidationMessage> GetValidationMessages(object obj)
        {
            if (Rule != null)
            {
                object[] outParams;
                if (!Rule.IsValid(obj, out outParams))
                {
                    yield return CreateException(null, Rule.Exception, outParams);
                }
            }
            yield break;
        }

        protected ValidationMessage CreateException(SourceContext source, ValidationException exceptionId, params object[] messageValues)
        {
            ValidationMessage validationMessage;
            ValidationException[] ignore = new ValidationException[] { };
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
