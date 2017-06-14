// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.AzureResourceSchema.Markdown
{
    public class Codeblock : MarkdownElement
    {
        private string _lang;
        private string _code;

        public Codeblock(string content)
        {
            if (string.IsNullOrEmpty(content))
                throw new ArgumentException(nameof(content));

            _code = content;
        }

        public Codeblock(string language, string content) : this(content)
        {
            if (string.IsNullOrEmpty(language))
                throw new ArgumentException(nameof(language));

            _lang = language;
        }

        public override string ToMarkdown()
        {
            if (!string.IsNullOrEmpty(_lang))
            {
                return $"```{_lang}{Environment.NewLine}{_code}{Environment.NewLine}```";
            }

            return string.Format("```{0}{1}{2}```", Environment.NewLine, _code, Environment.NewLine);
        }
    }
}
