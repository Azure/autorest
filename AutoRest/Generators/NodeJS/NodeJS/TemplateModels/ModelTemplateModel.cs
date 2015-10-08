// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.NodeJS.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Generator.NodeJS
{
    public class ModelTemplateModel : CompositeType
    {
        private readonly IScopeProvider _scope = new ScopeProvider();
        private ModelTemplateModel _parent = null;
        
        public ModelTemplateModel(CompositeType source, ServiceClient serviceClient)
        {
            if (!string.IsNullOrEmpty(source.PolymorphicDiscriminator))
            {
                if (!source.Properties.Any(p => p.Name == source.PolymorphicDiscriminator))
                {
                    var polymorphicProperty = new Property
                    {
                        IsRequired = true,
                        Name = source.PolymorphicDiscriminator,
                        SerializedName = source.PolymorphicDiscriminator,
                        Documentation = "Polymorhpic Discriminator",
                        Type = PrimaryType.String
                    };
                    source.Properties.Add(polymorphicProperty);
                }
            }
            this.LoadFrom(source);
            ServiceClient = serviceClient;
            if (source.BaseModelType != null)
            {
                _parent = new ModelTemplateModel(source.BaseModelType, serviceClient);
            }
        }

        public IScopeProvider Scope
        {
            get { return _scope; }
        }

        public ServiceClient ServiceClient { get; set; }

        public virtual IEnumerable<string> Usings
        {
            get { return Enumerable.Empty<string>(); }
        }

        public IEnumerable<Property> ComposedProperties
        {
            get
            {
                if(this._parent != null)
                {
                    return _parent.ComposedProperties
                                  .Union(this.Properties);
                }
                return this.Properties;
            }
        }

        public bool IsPolymorphic
        {
            get
            {
                if(!string.IsNullOrEmpty(this.PolymorphicDiscriminator))
                {
                    return true;
                }
                else if(this._parent != null)
                {
                    return _parent.IsPolymorphic;
                }

                return false;
            }
        }

        public IEnumerable<Property> DocumentationPropertyList
        {
            get
            {
                var traversalStack = new Stack<Property>();
                var visitedHash = new Dictionary<string, Property>();
                var retValue = new Stack<Property>();

                foreach (var property in Properties)
                {
                    traversalStack.Push(property);
                }

                while (traversalStack.Count() != 0)
                {
                    var property = traversalStack.Pop();
                    if (!(property.Type is CompositeType))
                    {
                        retValue.Push(property);
                    }

                    if (property.Type is CompositeType)
                    {
                        if (!visitedHash.ContainsKey(property.Name))
                        {
                            traversalStack.Push(property);
                            foreach (var subProperty in ((CompositeType)property.Type).Properties)
                            {
                                var individualProperty = new Property();
                                individualProperty.Type = subProperty.Type;
                                individualProperty.Name = property.Name + "." + subProperty.Name;
                                individualProperty.Documentation = subProperty.Documentation;
                                traversalStack.Push(individualProperty);
                            }

                            visitedHash.Add(property.Name, property);
                        }
                        else
                        {
                            retValue.Push(property);
                        }
                    }
                }

                return retValue.ToList();
            }
        }

        public static string ConstructPropertyDocumentation(string propertyDocumentation)
        {
            var builder = new IndentedStringBuilder("  ");
            return builder.AppendLine(propertyDocumentation)
                          .AppendLine(" * ").ToString();
        }

        public bool ContainsPropertiesInSequenceType()
        {
            var sample = ComposedProperties.FirstOrDefault(p => p.Type is SequenceType);
            return sample != null;
        }

        public bool ContainsPropertiesInCompositeType()
        {
            var sample = ComposedProperties.FirstOrDefault(p => 
                p.Type is CompositeType || p.Type is SequenceType && (p.Type as SequenceType).ElementType is CompositeType);
            return sample != null;
        }

        /// <summary>
        /// Returns the TypeScript string to define the specified property, including its type and whether it's optional or not
        /// </summary>
        /// <param name="property">Model property to query</param>
        /// <param name="inModelsModule">Pass true if generating the code for the models module, thus model types don't need a "models." prefix</param>
        /// <returns>TypeScript property definition</returns>
        public static string PropertyTS(Property property, bool inModelsModule) {
            if (property == null) {
                throw new ArgumentNullException("property");
            }

            string typeString = property.Type.TSType(inModelsModule);

            if (! property.IsRequired)
                return property.Name + "?: " + typeString;
            else return property.Name + ": " + typeString;
        }

        public string InitializeProperty(string objectName, string valueName, Property property)
        {
            if (property == null || property.Type == null)
            {
                throw new ArgumentNullException("property");
            }

            return property.Type.InitializeType(_scope, objectName + "." + property.Name, valueName + "." + property.Name);
        }

        public string SerializeProperty(string objectName, string serializedName, Property property)
        {
            if (property == null || property.Type == null)
            {
                throw new ArgumentNullException("property");
            }

            var propertyName = string.Format(CultureInfo.InvariantCulture, 
                "{0}['{1}']", objectName, property.Name);
            var serializedPropertyName = string.Format(CultureInfo.InvariantCulture,
                "{0}['{1}']", serializedName, property.SerializedName.Replace(".", "']['"));

            return property.Type.SerializeType(_scope, propertyName, serializedPropertyName, property.IsRequired, "models");
        }

        public string DeserializeProperty(string objectName, string valueName, Property property)
        {
            if (property == null || property.Type == null)
            {
                throw new ArgumentNullException("property");
            }

            var propertyName = string.Format(CultureInfo.InvariantCulture,
                "{0}['{1}']", objectName, property.Name);
            var deserializedPropertyName = string.Format(CultureInfo.InvariantCulture,
                "{0}['{1}']", valueName, property.SerializedName.Replace(".", "']['"));

            return property.Type.DeserializeType(_scope, propertyName, deserializedPropertyName, "models");
        }

        /// <summary>
        /// Provides the property name in the correct jsdoc notation depending on 
        /// whether it is required or optional
        /// </summary>
        /// <param name="property">Parameter to be documented</param>
        /// <returns>Parameter name in the correct jsdoc notation</returns>
        public static string GetPropertyDocumentationName(Property property)
        {
            if (property == null)
            {
                throw new ArgumentNullException("property");
            }
            if (property.IsRequired)
            {
                return property.Name;
            }
            else
            {
                return string.Format(CultureInfo.InvariantCulture, "[{0}]", property.Name);
            }
        }

        /// <summary>
        /// Provides the type of the property
        /// </summary>
        /// <param name="property">Parameter to be documented</param>
        /// <returns>Parameter name in the correct jsdoc notation</returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase")]
        public static string GetPropertyDocumentationType(Property property)
        {
            if (property == null)
            {
                throw new ArgumentNullException("property");
            }
            string typeName = PrimaryType.Object.Name;
            if (property.Type is PrimaryType)
            {
                typeName = property.Type.Name;
            }
            else if (property.Type is SequenceType)
            {
                typeName = "array";
            }
            else if (property.Type is EnumType)
            {
                typeName = PrimaryType.String.Name;
            }

            return typeName.ToLower(CultureInfo.InvariantCulture);
        }
    }
}