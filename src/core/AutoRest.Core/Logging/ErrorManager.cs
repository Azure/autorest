// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Properties;

namespace AutoRest.Core.Logging
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
                Logger.Entries.Where(e => e.Severity == LogEntrySeverity.Error).Select(e => e.Exception).Where(e => e != null).ToList();
            Logger.Entries.Add(new LogEntry(LogEntrySeverity.Fatal, FormatMessageString(message, args))
            {
                Exception = exception
            });
            if (exception != null)
            {
                errors.Insert(0, exception);
                return new CodeGenerationException(FormatMessageString(message, args), errors.ToArray());
            }
            return new CodeGenerationException(FormatMessageString(message, args), errors.ToArray());
        }

        /// <summary>
        /// Applies string formatting on message if args are not empty.
        /// </summary>
        /// <param name="message">Message</param>
        /// <param name="args">Arguments</param>
        /// <returns>Formatted string</returns>
        private static string FormatMessageString(string message, object[] args)
        {
            if (args != null && args.Length > 0)
            {
                return string.Format(CultureInfo.CurrentCulture, message, args);
            }
            else
            {
                return message;
            }
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