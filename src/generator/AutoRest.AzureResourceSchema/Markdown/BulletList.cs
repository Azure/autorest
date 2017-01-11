// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoRest.AzureResourceSchema.Markdown
{
    public class BulletList : MarkdownElement
    {
        private IEnumerable<string> _items;

        public BulletList(IEnumerable<string> items)
        {
            if (items == null)
                throw new ArgumentNullException(nameof(items));
            if (!items.Any())
                throw new ArgumentException("Collection contains no elements.", "items");

            _items = items;
        }

        public override string ToMarkdown()
        {
            var sb = new StringBuilder();

            foreach (var item in _items)
                sb.AppendLine(string.Format("- {0}", item));

            return sb.ToString();
        }
    }
}
