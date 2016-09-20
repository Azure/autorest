// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.NodeJS.TemplateModels;
using AutoRest.NodeJS.Azure.Properties;
using System.Globalization;
using System;

namespace AutoRest.NodeJS.Azure.TemplateModels
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

        public IType ItemType { 
            get 
            {
                if (Properties == null)
                {
                    return null;
                }
                var property = Properties.FirstOrDefault(p => p.Type is SequenceType);
                if (property != null)
                {
                    return ((SequenceType)property.Type).ElementType;
                }
                else
                {
                    throw new Exception(string.Format(Resources.PageModelDoesnotHaveAnArrayProperty, Name));
                }
            }
        }

        public string ConstructTSItemTypeName()
        {
            var builder = new IndentedStringBuilder("  ");
            builder.AppendFormat("<{0}>", ClientModelExtensions.TSType(ItemType, true));
            return builder.ToString();
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
