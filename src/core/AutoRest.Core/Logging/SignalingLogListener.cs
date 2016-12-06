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
            LogMessageSeverity minSeverityForSignal, 
            Action<LogMessage> signal)
        {
            MinSeverityForSignal = minSeverityForSignal;
            Signal = signal;
        }

        public LogMessageSeverity MinSeverityForSignal { get; }

        public Action<LogMessage> Signal { get; }

        public void Log(LogMessage message)
        {
            if (message.Severity >= MinSeverityForSignal)
            {
                Signal(message);
            }
        }
    }
}
