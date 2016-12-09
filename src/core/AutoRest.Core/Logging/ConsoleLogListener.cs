using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Core.Logging
{
    public class ConsoleLogListener : ILogListener
    {
        private static IDictionary<LogMessageSeverity, ConsoleColor> colors = new Dictionary<LogMessageSeverity, ConsoleColor>
        {
            { LogMessageSeverity.Debug, ConsoleColor.Gray },
            { LogMessageSeverity.Fatal, ConsoleColor.Red },
            { LogMessageSeverity.Error, ConsoleColor.Red },
            { LogMessageSeverity.Warning, ConsoleColor.Yellow },
            { LogMessageSeverity.Info, ConsoleColor.White },
        };

        private static ConsoleColor GetColorForSeverity(LogMessageSeverity severity)
        {
            ConsoleColor color;
            if (!colors.TryGetValue(severity, out color))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "No color defined for severity {0}", severity));
            }
            return color;
        }

        public ConsoleLogListener(
            LogMessageSeverity minSeverityForStdout = LogMessageSeverity.Info,
            LogMessageSeverity minSeverityForStderr = LogMessageSeverity.Error,
            bool verbose = false)
        {
            MinSeverityForStdout = minSeverityForStdout;
            MinSeverityForStderr = minSeverityForStderr;
            Verbose = verbose;
        }

        public LogMessageSeverity MinSeverityForStdout { get; }

        public LogMessageSeverity MinSeverityForStderr { get; }

        public bool Verbose { get; }

        public void Log(LogMessage message)
        {
            if (message.Severity >= MinSeverityForStdout || message.Severity >= MinSeverityForStderr)
            {
                var original = Console.ForegroundColor;
                Console.ForegroundColor = GetColorForSeverity(message.Severity);
                // Write the severity and message to console
                var targetStream = message.Severity >= MinSeverityForStderr ? Console.Error : Console.Out;

                targetStream.WriteLine($"{message.Severity.ToString().ToUpperInvariant()}: {message.Message}");
                targetStream.WriteLine($"\tPath: {message.Path.XPath}");
                if (message.VerboseData != null)
                {
                    targetStream.WriteLine(message.VerboseData);
                    targetStream.WriteLine();
                }
                Console.ForegroundColor = original;
            }
        }
    }
}
