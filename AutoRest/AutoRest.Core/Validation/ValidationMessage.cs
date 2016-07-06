using Microsoft.Rest.Generator.Logging;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Generator
{
    public class ValidationMessage
    {
        private IList<string> _location = new List<string>();

        public IList<string> Location
        {
            get { return this._location; }
        }

        public string Message { get; set; }

        public LogEntrySeverity Severity { get; set; }

        public ValidationExceptionName ValidationException { get; set; }

        public override string ToString()
        {
            return string.Format(CultureInfo.InvariantCulture, "{0}: {1}\n    Location: {2}", ValidationException, Message, string.Join("->", Location.Reverse()));
        }
    }
}
