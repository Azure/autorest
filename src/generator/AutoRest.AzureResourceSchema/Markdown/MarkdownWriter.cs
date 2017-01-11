// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.IO;

namespace AutoRest.AzureResourceSchema.Markdown
{
    public class MarkdownWriter
    {
        private TextWriter _tw;

        public MarkdownWriter(TextWriter textWriter)
        {
            if (textWriter == null)
                throw new ArgumentNullException(nameof(textWriter));

            _tw = textWriter;
        }

        public void Write(string format, params object[] arg)
        {
            _tw.Write(format, arg);
        }

        public void Write(IMarkdown markdownItem)
        {
            _tw.Write(markdownItem);
        }

        public void Write(IEnumerable<IMarkdown> markdownItems)
        {
            foreach (var markdownItem in markdownItems)
                _tw.Write(markdownItem);
        }

        public void WriteLine()
        {
            _tw.WriteLine();
        }

        public void WriteLine(IMarkdown markdownItem)
        {
            _tw.WriteLine(markdownItem);
        }

        public void WriteLine(string format, params object[] arg)
        {
            _tw.WriteLine(format, arg);
        }
    }
}
