// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace AutoRest.Core.Validation
{
    public class ValidationMessage
    {
        private IList<string> _path = new List<string>();

        public ValidationExceptionName ValidationException { get; set; }

        public string Message { get; set; }

        public LogEntrySeverity Severity { get; set; }

        public IList<string> Path
        {
            get { return this._path; }
        }

        public override string ToString()
        {
            return string.Format(CultureInfo.InvariantCulture, "{0}: {1}\n    Location: Path: {2}", ValidationException, Message, string.Join("->", Path.Reverse()));
        }
    }
}
