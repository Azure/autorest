// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;

namespace AutoRest.Core.Logging
{
    /// <summary>
    /// Aggregator for error, warning, and trace messages.
    /// </summary>
    public static class Logger
    {
        /// <summary>
        /// Instantiates a new instance of the LogEntry class.
        /// </summary>
        static Logger()
        {
            Entries = new List<LogEntry>();
        }

        /// <summary>
        /// Gets a list of LogEntries.
        /// </summary>
        public static IList<LogEntry> Entries { get; private set; }

        /// <summary>
        /// Logs a message of severity LogEntrySeverity.Info.
        /// </summary>
        /// <param name="message">Message to log. May include formatting.</param>
        /// <param name="args">Optional arguments to use if message includes formatting.</param>
        public static void LogInfo(string message, params object[] args)
        {
          lock( typeof( Logger ) ) {
            Entries.Add(new LogEntry(LogEntrySeverity.Info, string.Format(CultureInfo.InvariantCulture, message, args)));
          }
        }

        /// <summary>
        /// An abstraction for the core to output text (ie not err,warning, or info)
        /// </summary>
        /// <param name="message"></param>
        /// <param name="args"></param>
        public static void WriteOutput(string message, params object[] args)
        {
            Console.ResetColor();
            Console.WriteLine(message, args);
        }

        /// <summary>
        /// Logs a message of severity LogEntrySeverity.Warning.
        /// </summary>
        /// <param name="text">Message to log. May include formatting.</param>
        /// <param name="args">Optional arguments to use if the message includes formatting.</param>
        public static void LogWarning(string text, params object[] args)
        {
            Entries.Add(new LogEntry(LogEntrySeverity.Warning, string.Format(CultureInfo.InvariantCulture, text, args)));
        }

        /// <summary>
        /// Logs a message of severity LogEntrySeverity.Error.
        /// </summary>
        /// <param name="exception">Exception that corresponds to an error</param>
        /// <param name="message">Message to log. May include formatting.</param>
        /// <param name="args">Optional arguments to use if the message includes formatting.</param>
        public static void LogError(Exception exception, string message, params object[] args)
        {
            string formattedMessage = String.Format(CultureInfo.InvariantCulture, message, args);
            Entries.Add(exception != null
                ? new LogEntry(LogEntrySeverity.Error, formattedMessage)
                {
                    Exception = new InvalidOperationException(formattedMessage, exception)
                }
                : new LogEntry(LogEntrySeverity.Error, formattedMessage)
                {
                    Exception = new InvalidOperationException(formattedMessage)
                });
            {
            }
        }

        /// <summary>
        /// Logs a message of severity LogEntrySeverity.Error.
        /// </summary>
        /// <param name="message">Message to log. May include formatting.</param>
        /// <param name="args">Optional arguments to use if the message includes formatting.</param>
        public static void LogError(string message, params object[] args)
        {
            LogError(null, message, args);
        }

        public static void WriteMessages(TextWriter writer, LogEntrySeverity severity)
        {
            WriteMessages(writer, severity, false);
        }

        public static void WriteMessages(TextWriter writer, LogEntrySeverity severity, bool verbose)
        {
            if (writer == null)
            {
                throw new ArgumentNullException("writer");
            }
            foreach (var logEntry in Entries.Where(e => e.Severity == severity))
            {
                // Write the severity and message to console
                writer.WriteLine("{0}: {1}",
                    logEntry.Severity.ToString().ToUpperInvariant(),
                    logEntry.Message);
                // If verbose is on and the entry has an exception, show it
                if (logEntry.Exception != null && verbose)
                {
                    writer.WriteLine("{0}", logEntry.Exception);
                }
            }
        }

        public static void WriteMessages(TextWriter writer, LogEntrySeverity severity, bool verbose,ConsoleColor color)
        {
            if (writer == null)
            {
                throw new ArgumentNullException("writer");
            }
            foreach (var logEntry in Entries.Where(e => e.Severity == severity))
            {
                var original = Console.ForegroundColor;
                Console.ForegroundColor = color;
                // Write the severity and message to console
                writer.WriteLine("{0}: {1}",
                    logEntry.Severity.ToString().ToUpperInvariant(),
                    logEntry.Message);
                // If verbose is on and the entry has an exception, show it
                if (logEntry.Exception != null && verbose)
                {
                    writer.WriteLine("{0}", logEntry.Exception);
                }
                Console.ForegroundColor = original;
            }
        }
    }
}