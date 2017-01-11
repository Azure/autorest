// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Text;

namespace AutoRest.AzureResourceSchema.Markdown
{
    public class Paragraph : MarkdownElement
    {
        private StringBuilder _sb;

        public Paragraph()
        {
            _sb = new StringBuilder();
            _sb.AppendLine();
        }

        public Paragraph(string content) : this()
        {
            Append(content);
        }

        public Paragraph(string format, params object[] arg) : this()
        {
            Append(format, arg);
        }

        public Paragraph(MarkdownElement md) : this()
        {
            Append(md);
        }

        public void Append(string content)
        {
            _sb.Append(content);
        }

        public void Append(string format, params object[] arg)
        {
            _sb.AppendFormat(format, arg);
        }

        public void Append(MarkdownElement md)
        {
            _sb.Append(md.ToString());
        }

        public override string ToMarkdown()
        {
            // TODO: word wrapping?
            _sb.AppendLine();
            return _sb.ToString();
        }
    }
}
