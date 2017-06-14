using System;

namespace AutoRest.Core.Logging
{
    public class SignalingLogListener : ILogListener
    {
        public SignalingLogListener(
            Category minSeverityForSignal, 
            Action<LogMessage> signal)
        {
            MinSeverityForSignal = minSeverityForSignal;
            Signal = signal;
        }

        public Category MinSeverityForSignal { get; }

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
