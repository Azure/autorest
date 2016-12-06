using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Core.Logging
{
    public class SignalingLogListener : ILogListener
    {
        public SignalingLogListener(
            LogEntrySeverity minSeverityForSignal, 
            Action<LogEntry> signal)
        {
            MinSeverityForSignal = minSeverityForSignal;
            Signal = signal;
        }

        public LogEntrySeverity MinSeverityForSignal { get; }

        public Action<LogEntry> Signal { get; }

        public void Log(LogEntrySeverity severity, string message)
        {
            if (severity >= MinSeverityForSignal)
            {
                Signal(new LogEntry { Severity = severity, Message = message });
            }
        }
    }
}
