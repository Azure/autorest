using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Core.Logging
{
    public class ConsoleLogListener : ILogListener
    {
        public ConsoleLogListener(
            Category minSeverity = Category.Info,
            bool verbose = false)
        {
            MinSeverity = minSeverity;
            Verbose = verbose;
        }

        public Category MinSeverity { get; }

        public bool Verbose { get; }

        public void Log(LogMessage message)
        {
            if (message.Severity >= MinSeverity)
            {
                // Write the severity and message to console
                var targetStream = Console.Error;

                targetStream.WriteLine($"{message.Severity.ToString().ToUpperInvariant()}: {message.Message}");
                if (message.Path != null)
                {
                    targetStream.WriteLine($"\tPath: {message.Path.ReadablePath}");
                }
                if (message.VerboseData != null)
                {
                    targetStream.WriteLine(message.VerboseData);
                    targetStream.WriteLine();
                }
                targetStream.Flush();
            }
        }
    }
}
