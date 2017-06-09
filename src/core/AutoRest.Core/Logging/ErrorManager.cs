// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Globalization;

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
        public static CodeGenerationException CreateError(string message, params object[] args)
        {
            Logger.Instance.Log(Category.Fatal, FormatMessageString(message, args));
            return new CodeGenerationException(FormatMessageString(message, args));
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
    }
}