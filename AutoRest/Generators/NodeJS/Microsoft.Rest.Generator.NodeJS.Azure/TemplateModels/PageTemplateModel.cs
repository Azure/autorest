// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.NodeJS;
using Microsoft.Rest.Generator.NodeJS.TemplateModels;

namespace Microsoft.Rest.Generator.NodeJS.Azure
{
    public class PageTemplateModel : ModelTemplateModel
    {
        public PageTemplateModel(CompositeType source, ServiceClient serviceClient, string nextLinkName, string itemName) 
            : base(source, serviceClient)
        {
            this.NextLinkName = nextLinkName;
            this.ItemName = itemName;
        }

        public string NextLinkName { get; private set; }

        public string ItemName { get; private set; }

        public CompositeType ItemType { 
            get 
            {
                if (Properties == null)
                {
                    return null;
                }
                var property = Properties.FirstOrDefault(p => p.Type is SequenceType);
                if (property != null)
                {
                    return ((SequenceType)property.Type).ElementType as CompositeType;
                }
                else
                {
                    return null;
                }
            }
        }

        public override string ConstructModelMapper()
        {
            var modelMapper = this.ConstructMapper(SerializedName, null, true, true);
            var builder = new IndentedStringBuilder("  ");
            builder.AppendLine("return {{{0}}};", modelMapper);
            return builder.ToString();
        }
    }
}
