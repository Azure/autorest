// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.AzureResourceSchema.Markdown
{
    public class Codeblock : MarkdownElement
    {
        private string _s;

        public Codeblock(string content)
        {
            if (string.IsNullOrEmpty(content))
                throw new ArgumentException(nameof(content));

            _s = content;
        }

        public override string ToMarkdown()
        {
            return string.Format("```{0}{1}{2}```", Environment.NewLine, _s, Environment.NewLine);
        }
    }
}
