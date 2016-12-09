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
    public class Logger
    {
        public static Logger Instance
        {
            get
            {
                if (!Singleton<Logger>.HasInstance)
                {
                    Singleton<Logger>.Instance = new Logger();
                }
                return Singleton<Logger>.Instance;
            }
        }

        protected Logger()
        {
            if (!Context.IsActive)
            {
                throw new Exception("A context must be active before creating a logger.");
            }
            if (Singleton<Logger>.HasInstanceInCurrentActivation)
            {
                throw new Exception("The current context already has a logger. (Did you mean to create a nested context?)");
            }
        }

        /// <summary>
        /// Adds given listener to the current context.
        /// </summary>
        public void AddListener(ILogListener listener)
        {
            SingletonList<ILogListener>.Add(listener);
        }
        
        public void Log(LogMessage message)
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
        public void Log(LogMessageSeverity severity, string message, params object[] args)
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
        public void Log(string message, params object[] args)
        {
            Log(LogMessageSeverity.Info, message, args);
        }
    }
}