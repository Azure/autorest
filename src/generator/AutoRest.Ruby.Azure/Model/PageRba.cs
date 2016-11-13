// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.Ruby.Azure.Model
{
    public class PageRba : CompositeTypeRba
    {
        public PageRba(CompositeType source,  string nextLinkName, string itemName)
        {
            this.LoadFrom(source);
            this.NextLinkName = nextLinkName;
            this.ItemName = itemName;
        }

        public string NextLinkName { get; private set; }

        public string ItemName { get; private set; }

        public CompositeType ItemType
        {
            get
            {
                if (Properties == null)
                {
                    return null;
                }
                Property property = Properties.FirstOrDefault(p => p.ModelType is SequenceType);
                if (property != null)
                {
                    return ((SequenceType)property.ModelType).ElementType as CompositeType;
                }
                else
                {
                    return null;
                }
            }
        }
    }
}