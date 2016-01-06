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

namespace Microsoft.Rest.Generator.Azure.NodeJS
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
                var sequence = (SequenceType)Properties.FirstOrDefault(p => p.Type is SequenceType).Type;
                return sequence.ElementType as CompositeType;
            }
        }

        public override string ConstructModelMapper()
        {
            var modelMapper = this.ConstructMapper(SerializedName, false, null, null, true, true);
            var builder = new IndentedStringBuilder("  ");
            builder.AppendLine("return {{{0}}};", modelMapper);
            return builder.ToString();
            /*var builder = new IndentedStringBuilder("  ");
            builder.AppendLine("type: {")
                     .Indent()
                     .AppendLine("name: 'Composite',")
                     .AppendLine("className: '{0}',", this.Name)
                     .AppendLine("modelProperties: {").Indent();
            var composedPropertyList = new List<Property>(ComposedProperties);
            for (var i = 0; i < composedPropertyList.Count; i++)
            {
                var prop = composedPropertyList[i];
                if (prop.Name.Contains("nextLink") && NextLinkName == null)
                {
                    continue;
                }
                builder.AppendLine("{0}: {{", prop.Name).Indent();
                if (prop.IsRequired)
                {
                    builder.AppendLine("required: true,");
                }
                else
                {
                    builder.AppendLine("required: false,");
                }

                if (prop.SerializedName != null)
                {
                    if(prop.Name == ItemName)
                    {
                        builder.AppendLine("serializedName: '',");
                    }
                    else
                    {
                        builder.AppendLine("serializedName: '{0}',", prop.SerializedName);
                    }
                    
                }
                if (prop.DefaultValue != null)
                {
                    builder.AppendLine("defaultValue: '{0}',", prop.DefaultValue);
                }
                if (prop.Constraints.Count > 0)
                {
                    builder.AppendLine("constraints: {").Indent();
                    var constraints = prop.Constraints;
                    var keys = constraints.Keys.ToList<Constraint>();
                    for (int j = 0; j < keys.Count; j++)
                    {
                        var constraintValue = constraints[keys[j]];
                        if (keys[j] == Constraint.Pattern)
                        {
                            constraintValue = string.Format("'{0}'", constraintValue);
                        }
                        if (j != keys.Count - 1)
                        {
                            builder.AppendLine("{0}: {1},", keys[j], constraintValue);
                        }
                        else
                        {
                            builder.AppendLine("{0}: {1}", keys[j], constraintValue);
                        }
                    }
                    builder.Outdent().AppendLine("}");
                }
                builder = prop.Type.ConstructType(builder);
                // end of a particular property

                if (i != composedPropertyList.Count - 1 && NextLinkName != null)
                {
                    builder.Outdent().AppendLine("},");
                }
                else
                {
                    builder.Outdent().AppendLine("}");
                }

            }
            // end of modelProperties and type
            builder.Outdent().AppendLine("}").Outdent().Append("}");
            return builder.ToString();*/
        }
    }
}
