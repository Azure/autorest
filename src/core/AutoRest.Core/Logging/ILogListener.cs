using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Core.Logging
{
    public interface ILogListener
    {
        void Log(LogEntrySeverity severity, string message);
    }
}
