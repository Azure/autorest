// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core.Logging
{
    /// <summary>
    /// Aggregator for error, warning, and trace messages.
    /// </summary>
    public static class Logger
    {
        /// <summary>
        /// Adds given listener to the current context.
        /// </summary>
        public static void AddListener(ILogListener listener)
        {
            SingletonList<ILogListener>.Add(listener);
        }

        /// <summary>
        /// Logs a message of specified severity.
        /// </summary>
        /// <param name="message">Message to log. May include formatting.</param>
        /// <param name="args">Optional arguments to use if message includes formatting.</param>
        public static void Log(LogEntrySeverity severity, string message, params object[] args)
        {
            foreach (var listener in SingletonList<ILogListener>.RecursiveInstances)
            {
                listener.Log(severity, string.Format(CultureInfo.InvariantCulture, message, args));
            }
        }

        /// <summary>
        /// Logs an info message.
        /// </summary>
        /// <param name="message">Message to log. May include formatting.</param>
        /// <param name="args">Optional arguments to use if message includes formatting.</param>
        public static void Log(string message, params object[] args)
        {
            Log(LogEntrySeverity.Info, message, args);
        }
    }
}