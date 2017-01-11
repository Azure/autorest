// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Text;

namespace AutoRest.AzureResourceSchema.Markdown
{
    public class Header : MarkdownElement
    {
        private int _level;
        private string _s;

        public Header(string format, params object[] arg) : this(1, format, arg)
        {
            // empty
        }

        public Header(int level, string format, params object[] arg)
        {
            if (level < 1)
                throw new ArgumentOutOfRangeException("Header level cannot be less than one.");
            if (string.IsNullOrEmpty(format))
                throw new ArgumentException(nameof(format));

            _level = level;
            _s = string.Format(format, arg);
        }

        public override string ToMarkdown()
        {
            var sb = new StringBuilder(_s.Length + _level + 1);
            for (var i = 0; i < _level; ++i)
                sb.Append("#");

            sb.Append(" ");
            sb.Append(_s);

            return sb.ToString();
        }
    }
}
