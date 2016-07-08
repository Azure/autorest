// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Ruby;
using AutoRest.Ruby.Azure.TemplateModels;
using AutoRest.Extensions;

namespace AutoRest.Ruby.Azure
{
    public class PageTemplateModel : AzureModelTemplateModel
    {
        public PageTemplateModel(CompositeType source, ISet<CompositeType> allTypes, string nextLinkName, string itemName)
            : base(source, allTypes)
        {
            this.NextLinkName = nextLinkName;
            this.ItemName = itemName;
            this.NextLinkParameter = BuildNextLinkParameter();
        }

        public string NextLinkName { get; private set; }

        public Parameter NextLinkParameter { get; private set; }

        public string ItemName { get; private set; }

        public CompositeType ItemType
        {
            get
            {
                if (Properties == null)
                {
                    return null;
                }
                Property property = Properties.FirstOrDefault(p => p.Type is SequenceType);
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

        public Parameter BuildNextLinkParameter()
        {
            RubyCodeNamer rubyCodeNamer = new RubyCodeNamer();
            Parameter param = new Parameter
            {
                Name = rubyCodeNamer.GetPropertyName(NextLinkName),
                SerializedName = NextLinkName,
                Type = new PrimaryType(KnownPrimaryType.String),
                Documentation = "The NextLink from the previous successful call to List operation.",
                IsRequired = true,
                Location = ParameterLocation.Path
            };
            param.Extensions[SwaggerExtensions.SkipUrlEncodingExtension] = true;
            return param;
        }
    }
}