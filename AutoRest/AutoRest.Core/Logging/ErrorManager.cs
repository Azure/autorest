// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.Properties;

namespace Microsoft.Rest.Generator.Logging
{
    /// <summary>
    /// Error manager for code generator.
    /// </summary>
    public static class ErrorManager
    {
        /// <summary>
        /// Logs error and returns CodeGenerationException.
        /// </summary>
        /// <param name="exception">Exception to log and return.</param>
        /// <param name="message">Error message. May include formatting.</param>
        /// <param name="args">Optional args if the message includes formatting.</param>
        /// <returns></returns>
        public static CodeGenerationException CreateError(Exception exception, string message, params object[] args)
        {
            // Rethrow if caught CodeGenerationException
            var codeGenerationException = exception as CodeGenerationException;
            if (codeGenerationException != null)
            {
                return codeGenerationException;
            }

            var errors =
                Logger.Entries.Where(e => e.Severity == LogEntrySeverity.Error).Select(e => e.Exception).ToList();
            Logger.Entries.Add(new LogEntry(LogEntrySeverity.Fatal, string.Format(CultureInfo.CurrentCulture, message, args))
            {
                Exception = exception
            });
            if (exception != null)
            {
                errors.Insert(0, exception);
                return new CodeGenerationException(string.Format(CultureInfo.CurrentCulture, message, args), errors.ToArray());
            }
            return new CodeGenerationException(string.Format(CultureInfo.CurrentCulture, message, args), errors.ToArray());
        }

        /// <summary>
        /// Logs error and returns CodeGenerationException.
        /// </summary>
        /// <param name="message">Error message. May include formatting.</param>
        /// <param name="parameters">Optional args if the message includes formatting.</param>
        /// <returns></returns>
        public static CodeGenerationException CreateError(string message, params object[] parameters)
        {
            return CreateError(null, message, parameters);
        }

        /// <summary>
        /// Throws CodeGenerationException if any errors have been logged.
        /// </summary>
        public static void ThrowErrors()
        {
            var errors =
                Logger.Entries.Where(e => e.Severity == LogEntrySeverity.Error).Select(e => e.Exception).ToArray();
            if (errors.Length > 0)
            {
                throw new CodeGenerationException(Resources.CodeGenerationFailed, errors);
            }
        }
    }
}