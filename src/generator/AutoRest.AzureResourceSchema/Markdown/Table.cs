// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoRest.AzureResourceSchema.Markdown
{
    public class Table : MarkdownElement
    {
        private IEnumerable<string> _headers;
        private List<IEnumerable<string>> _rows;

        public Table(IEnumerable<string> headers)
        {
            if (headers == null)
                throw new ArgumentNullException(nameof(headers));
            if (!headers.Any())
                throw new ArgumentException("Collection contained no elements.", "headers");

            _headers = headers;
            _rows = new List<IEnumerable<string>>();
        }

        public void AddRow(IEnumerable<string> row)
        {
            if (row == null)
                throw new ArgumentNullException(nameof(row));
            if (!row.Any())
                throw new ArgumentException("Collection contained no elements.", "row");

            _rows.Add(row);
        }

        public override string ToMarkdown()
        {
            var sb = new StringBuilder();

            // write table header
            AppendRow(sb, _headers);

            sb.Append("| ");
            foreach (var h in _headers)
                sb.Append(" ---- |");
            sb.AppendLine();

            foreach (var row in _rows)
                AppendRow(sb, row);

            // now write the rows
            return sb.ToString();
        }

        private void AppendRow(StringBuilder sb, IEnumerable<string> row)
        {
            sb.Append("| ");
            foreach (var r in row)
                sb.AppendFormat(" {0} |", r);

            sb.AppendLine();
        }
    }
}
