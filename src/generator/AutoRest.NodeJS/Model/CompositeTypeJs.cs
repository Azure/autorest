// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.NodeJS.TemplateModels
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
                        Type = new PrimaryType(KnownPrimaryType.String)
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

        public IEnumerable<Property> SerializableProperties
        {
            get { return this.Properties.Where(p => !string.IsNullOrEmpty(p.SerializedName)); }
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

        private class PropertyWrapper
        {
            public Property Property { get; set; }
            public List<string> RecursiveTypes { get; set; }

            public PropertyWrapper() { RecursiveTypes = new List<string>(); }
        }

        public IEnumerable<Property> DocumentationPropertyList
        {
            get
            {
                var traversalStack = new Stack<PropertyWrapper>();
                var visitedHash = new Dictionary<string, PropertyWrapper>();
                var retValue = new Stack<Property>();

                foreach (var property in Properties.Where(p => !p.IsConstant))
                {
                    var tempWrapper = new PropertyWrapper()
                    {
                        Property = property,
                        RecursiveTypes = new List<string> () { Name }
                    };
                    traversalStack.Push(tempWrapper);
                }

                while (traversalStack.Count() != 0)
                {
                    var wrapper = traversalStack.Pop();
                    if (wrapper.Property.Type is CompositeType)
                    {
                        if (!visitedHash.ContainsKey(wrapper.Property.Name))
                        {
                            if (wrapper.RecursiveTypes.Contains(wrapper.Property.Type.Name))
                            {
                                retValue.Push(wrapper.Property);
                            }
                            else
                            {
                                traversalStack.Push(wrapper);
                                foreach (var subProperty in ((CompositeType)wrapper.Property.Type).Properties)
                                {
                                    if (subProperty.IsConstant)
                                    {
                                        continue;
                                    }
                                    var individualProperty = new Property();
                                    individualProperty.Name = wrapper.Property.Name + "." + subProperty.Name;
                                    individualProperty.Type = subProperty.Type;
                                    individualProperty.Documentation = subProperty.Documentation;
                                    //Adding the parent type to recursive list
                                    var recursiveList = new List<string>() { wrapper.Property.Type.Name };
                                    if (subProperty.Type is CompositeType)
                                    {
                                        //Adding parent's recursive types to the list as well
                                        recursiveList.AddRange(wrapper.RecursiveTypes);
                                    }
                                    var subPropertyWrapper = new PropertyWrapper()
                                    {
                                        Property = individualProperty,
                                        RecursiveTypes = recursiveList
                                    };
                                    
                                    traversalStack.Push(subPropertyWrapper);
                                }
                            }

                            visitedHash.Add(wrapper.Property.Name, wrapper);
                        }
                        else
                        {
                            retValue.Push(wrapper.Property);
                        }
                    }
                    else
                    {
                        retValue.Push(wrapper.Property);
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
            var sample = ComposedProperties.FirstOrDefault(p => 
            p.Type is SequenceType ||
            p.Type is DictionaryType && (p.Type as DictionaryType).ValueType is SequenceType);
            return sample != null;
        }

        public bool ContainsPropertiesInCompositeType()
        {
            var sample = ComposedProperties.FirstOrDefault(p => ContainsCompositeType(p.Type));
            return sample != null;
        }

        private bool ContainsCompositeType(IType type)
        {
            bool result = false;
            //base condition
            if (type is CompositeType || 
                type is SequenceType && (type as SequenceType).ElementType is CompositeType || 
                type is DictionaryType && (type as DictionaryType).ValueType is CompositeType)
            {
                result = true;
            }
            else if (type is SequenceType)
            {
                result = ContainsCompositeType((type as SequenceType).ElementType);
            }
            else if (type is DictionaryType)
            {
                result = ContainsCompositeType((type as DictionaryType).ValueType);
            }
            return result;
        }

        public bool ContainsDurationProperty()
        {
            Property prop = ComposedProperties.FirstOrDefault(p =>
                (p.Type is PrimaryType && (p.Type as PrimaryType).Type == KnownPrimaryType.TimeSpan) ||
                (p.Type is SequenceType && (p.Type as SequenceType).ElementType.IsPrimaryType(KnownPrimaryType.TimeSpan)) ||
                (p.Type is DictionaryType && (p.Type as DictionaryType).ValueType.IsPrimaryType(KnownPrimaryType.TimeSpan)));
            return prop != null;
        }

        /// <summary>
        /// Returns the TypeScript string to define the specified property, including its type and whether it's optional or not
        /// </summary>
        /// <param name="property">Model property to query</param>
        /// <param name="inModelsModule">Pass true if generating the code for the models module, thus model types don't need a "models." prefix</param>
        /// <returns>TypeScript property definition</returns>
        public static string PropertyTS(Property property, bool inModelsModule) 
        {
            if (property == null) 
            {
                throw new ArgumentNullException("property");
            }

            string typeString = property.Type.TSType(inModelsModule);

            if (! property.IsRequired)
                return property.Name + "?: " + typeString;
            else return property.Name + ": " + typeString;
        }

        public virtual string ConstructModelMapper()
        {
            var modelMapper = this.ConstructMapper(SerializedName, null, false, true);
            var builder = new IndentedStringBuilder("  ");
            builder.AppendLine("return {{{0}}};", modelMapper);
            return builder.ToString();
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
        /// Provides the property documentation string along with default value if any.
        /// </summary>
        /// <param name="property">Parameter to be documented</param>
        /// <returns>Parameter documentation string along with default value if any 
        /// in correct jsdoc notation</returns>
        public static string GetPropertyDocumentationString(Property property)
        {
            if (property == null)
            {
                throw new ArgumentNullException("property");
            }

            string summary = property.Summary;

            if (!string.IsNullOrWhiteSpace(summary) && !summary.EndsWith(".", StringComparison.OrdinalIgnoreCase))
            {
                summary += ".";
            }

            string documentation = property.Documentation;
            if (!string.IsNullOrWhiteSpace(property.DefaultValue))
            {
                if (documentation != null && !documentation.EndsWith(".", StringComparison.OrdinalIgnoreCase))
                {
                    documentation += ".";
                }
                documentation += " Default value: " + property.DefaultValue + " .";
            }

            string docString = string.Join(" ", (new[] {summary, documentation}).Where(s => !string.IsNullOrEmpty(s)));
            return docString;
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
            string typeName = "object";
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
                typeName = "string";
            }

            return typeName.ToLower(CultureInfo.InvariantCulture);
        } 
    }
}