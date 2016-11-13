// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.AzureResourceSchema.Markdown
{
    public class Anchor : MarkdownElement
    {
        private string _id;

        public Anchor(string id)
        {
            if (string.IsNullOrEmpty(id))
                throw new ArgumentException(nameof(id));

            _id = id;
        }

        public override string ToMarkdown()
        {
            return $"<a id=\"{_id}\" />";
        }
    }
}
