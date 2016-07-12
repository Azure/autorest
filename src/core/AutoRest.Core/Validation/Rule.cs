// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System;
using System.Linq;
using System.Globalization;
using AutoRest.Core.Logging;

namespace AutoRest.Core.Validation
{
    /// <summary>
    /// Defines validation logic for an object
    /// </summary>
    public abstract class Rule
    {
        protected Rule()
        {
        }

        /// <summary>
        /// The name of the exception that describes this rule
        /// </summary>
        public abstract ValidationExceptionName Exception { get; }

        /// <summary>
        /// Returns the validation messages resulting from validating this object
        /// </summary>
        /// <param name="entity">The object to validate</param>
        /// <returns></returns>
        public abstract IEnumerable<ValidationMessage> GetValidationMessages(object entity);

        /// <summary>
        /// Creates an exception for the given <paramref name="exceptionName"/>, using the <paramref name="messageValues"/> format parameters
        /// </summary>
        /// <param name="exceptionName"></param>
        /// <param name="messageValues"></param>
        /// <returns></returns>
        protected static ValidationMessage CreateException(ValidationExceptionName exceptionName, params object[] messageValues)
        {
            ValidationMessage validationMessage;
            ValidationExceptionName[] ignore = new ValidationExceptionName[] { };
            if (ignore.Any(id => id == exceptionName))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Info,
                    Message = string.Empty
                };
            }
            else if (ValidationExceptionConstants.Info.Messages.ContainsKey(exceptionName))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Info,
                    Message = string.Format(CultureInfo.InvariantCulture, ValidationExceptionConstants.Info.Messages[exceptionName], messageValues)
                };
            }
            else if (ValidationExceptionConstants.Warnings.Messages.ContainsKey(exceptionName))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Warning,
                    Message = string.Format(CultureInfo.InvariantCulture, ValidationExceptionConstants.Warnings.Messages[exceptionName], messageValues)
                };
            }
            else if (ValidationExceptionConstants.Errors.Messages.ContainsKey(exceptionName))
            {
                validationMessage = new ValidationMessage()
                {
                    Severity = LogEntrySeverity.Error,
                    Message = string.Format(CultureInfo.InvariantCulture, ValidationExceptionConstants.Errors.Messages[exceptionName], messageValues)
                };
            }
            else
            {
                throw new NotImplementedException();
            }

            validationMessage.ValidationException = exceptionName;
            return validationMessage;
        }
    }
}
