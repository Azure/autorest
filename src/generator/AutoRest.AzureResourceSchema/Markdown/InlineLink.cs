// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.AzureResourceSchema.Markdown
{
    public class InlineLink : MarkdownElement
    {
        string _s;
        string _dest;

        public InlineLink(string destination, string format, params object[] arg)
        {
            if (string.IsNullOrEmpty(destination))
                throw new ArgumentException(nameof(destination));
            if (string.IsNullOrEmpty(format))
                throw new ArgumentException(nameof(format));

            _s = string.Format(format, arg);
            _dest = destination;
        }

        public override string ToMarkdown()
        {
            return $"[{_s}]({_dest})";
        }
    }
}
