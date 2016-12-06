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
        /// Logs a message of specified severity.
        /// </summary>
        /// <param name="message">Message to log. May include formatting.</param>
        /// <param name="args">Optional arguments to use if message includes formatting.</param>
        public static void Log(LogEntrySeverity severity, string message, params object[] args)
        {
            Entries.Add(new LogEntry(severity, string.Format(CultureInfo.InvariantCulture, message, args)));
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

        public static void WriteMessages(TextWriter writer, LogEntrySeverity severity)
        {
            WriteMessages(writer, severity, false);
        }

        public static void WriteMessages(TextWriter writer, LogEntrySeverity severity, bool verbose)
        {
            WriteMessages(writer, severity, verbose, Console.ForegroundColor);
        }

        public static void WriteMessages(TextWriter writer, LogEntrySeverity severity, bool verbose, ConsoleColor color)
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
                Console.ForegroundColor = original;
            }
        }
    }
}