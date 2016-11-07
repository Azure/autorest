// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.AzureResourceSchema.Markdown
{
    public class Strong : MarkdownElement
    {
        private string _s;

        public Strong(string content)
        {
            if (string.IsNullOrEmpty(content))
                throw new ArgumentException(nameof(content));

            _s = content;
        }

        public Strong(string format, params object[] arg)
        {
            if (string.IsNullOrEmpty(format))
                throw new ArgumentException(nameof(format));

            _s = string.Format(format, arg);
        }

        public Strong(MarkdownElement md)
        {
            if (md == null)
                throw new ArgumentNullException(nameof(md));

            _s = md.ToString();
        }

        public override string ToMarkdown()
        {
            return string.Format("**{0}**", _s);
        }
    }
}
