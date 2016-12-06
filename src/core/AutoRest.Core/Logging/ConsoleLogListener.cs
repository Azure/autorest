using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Core.Logging
{
    public class ConsoleLogListener : ILogListener
    {
        private static IDictionary<LogEntrySeverity, ConsoleColor> colors = new Dictionary<LogEntrySeverity, ConsoleColor>
        {
            { LogEntrySeverity.Debug, ConsoleColor.Gray },
            { LogEntrySeverity.Fatal, ConsoleColor.Red },
            { LogEntrySeverity.Error, ConsoleColor.Red },
            { LogEntrySeverity.Warning, ConsoleColor.Yellow },
            { LogEntrySeverity.Info, ConsoleColor.White },
        };

        private static ConsoleColor GetColorForSeverity(LogEntrySeverity severity)
        {
            ConsoleColor color;
            if (!colors.TryGetValue(severity, out color))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "No color defined for severity {0}", severity));
            }
            return color;
        }

        public ConsoleLogListener(
            LogEntrySeverity minSeverityForStdout = LogEntrySeverity.Info,
            LogEntrySeverity minSeverityForStderr = LogEntrySeverity.Error)
        {
            MinSeverityForStdout = minSeverityForStdout;
            MinSeverityForStderr = minSeverityForStderr;
        }

        public LogEntrySeverity MinSeverityForStdout { get; }

        public LogEntrySeverity MinSeverityForStderr { get; }

        public void Log(LogEntrySeverity severity, string message)
        {
            if (severity >= MinSeverityForStdout || severity >= MinSeverityForStderr)
            {
                var original = Console.ForegroundColor;
                Console.ForegroundColor = GetColorForSeverity(severity);
                // Write the severity and message to console
                var logMessage = $"{severity.ToString().ToUpperInvariant()}: {message}";
                if (severity >= MinSeverityForStderr)
                {
                    Console.Error.WriteLine(logMessage);
                }
                else
                {
                    Console.WriteLine(logMessage);
                }
                Console.ForegroundColor = original;
            }
        }
    }
}
