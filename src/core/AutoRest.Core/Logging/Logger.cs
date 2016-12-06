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
        
        public static void Log(LogMessage message)
        {
            foreach (var listener in SingletonList<ILogListener>.RecursiveInstances)
            {
                listener.Log(message);
            }
        }

        /// <summary>
        /// Logs a message of specified severity.
        /// </summary>
        /// <param name="message">Message to log. May include formatting.</param>
        /// <param name="args">Optional arguments to use if message includes formatting.</param>
        public static void Log(LogMessageSeverity severity, string message, params object[] args)
        {
            if (args != null && args.Length > 0)
            {
                message = string.Format(CultureInfo.InvariantCulture, message, args);
            }
            Log(new LogMessage(severity, message));
        }

        /// <summary>
        /// Logs an info message.
        /// </summary>
        /// <param name="message">Message to log. May include formatting.</param>
        /// <param name="args">Optional arguments to use if message includes formatting.</param>
        public static void Log(string message, params object[] args)
        {
            Log(LogMessageSeverity.Info, message, args);
        }
    }
}