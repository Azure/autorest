// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Python.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Generator.Python
{
    public class ModelTemplateModel : CompositeType
    {
        private ModelTemplateModel _parent = null;
        private bool _isException = false;
        private readonly IList<CompositeType> _subModelTypes = new List<CompositeType>();
        
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
                        Documentation = "Polymorphic Discriminator",
                        Type = new PrimaryType.String { Name = "str" }
                    };
                    source.Properties.Add(polymorphicProperty);
                }
            }
            this.LoadFrom(source);
            ServiceClient = serviceClient;
            
            if (ServiceClient.ErrorTypes.Contains(source))
            {
                _isException = true;
            }

            if (source.BaseModelType != null)
            {
                _parent = new ModelTemplateModel(source.BaseModelType, serviceClient);
            }

            if (this.IsPolymorphic)
            {
                foreach (var modelType in ServiceClient.ModelTypes)
                {
                    if (modelType.BaseModelType == source)
                    {
                        _subModelTypes.Add(modelType);
                    }
                }
            }
        }

        public IList<CompositeType> SubModelTypes
        {
            get
            {
                return _subModelTypes;
            }
        }

        public bool IsException
        {
            get { return _isException; }
        }

        public bool IsParameterGroup
        {
            get
            {
                foreach (var prop in this.Properties)
                {
                    if (prop.SerializedName != null)
                    {
                        return false;
                    }
                }
                return true;
            }
        }

        public ServiceClient ServiceClient { get; set; }

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

            string docString = ":param ";

            docString += ModelTemplateModel.GetPropertyDocumentationType(property);
            docString += " " + property.Name + ":";

            string documentation = property.Documentation;
            if (!string.IsNullOrWhiteSpace(property.DefaultValue))
            {
                if (documentation != null && !documentation.EndsWith(".", StringComparison.OrdinalIgnoreCase))
                {
                    documentation += ".";
                }
                documentation += " Default value: " + property.DefaultValue + " .";
            }

            if (!string.IsNullOrWhiteSpace(documentation))
            {
                docString += " " + documentation;
            }
            return docString;
        }

        public IList<string> RequiredFieldsList
        {
            get
            {
                List<string> requiredFields = new List<string>();
                foreach (var property in Properties)
                {
                    if (property.IsRequired)
                    {
                        requiredFields.Add(property.Name);
                    }
                }
                return requiredFields;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "PolymorphicDiscriminator")]
        public string BasePolymorphicDiscriminator
        {
            get
            {
                CompositeType type = this;
                while (type != null)
                {
                    if (!string.IsNullOrEmpty(type.PolymorphicDiscriminator))
                    {
                        return type.PolymorphicDiscriminator;
                    }
                    type = type.BaseModelType;
                }
                throw new InvalidOperationException(string.Format(CultureInfo.InvariantCulture, "No PolymorphicDiscriminator defined for type {0}", this.Name));
            }
        }

        public string SubModelTypeList
        {
            get
            {
                List<string> typeTuple = new List<string>();
                foreach (var modelType in this.SubModelTypes)
                {
                    typeTuple.Add(
                        string.Format(CultureInfo.InvariantCulture, "'{0}': '{1}'",
                            modelType.SerializedName, modelType.Name
                        ));
                }

                return string.Join(", ", typeTuple);
            }
        }

        public virtual string ExceptionTypeDefinitionName
        {
            get
            {
                return this.GetExceptionDefineType();
            }
        }

        private static string GetPythonSerializationType(IType type)
        {
            Dictionary<Type, string> typeNameMapping = new Dictionary<Type, string>()
                        {
                            { typeof(PrimaryType.DateTime), "iso-8601" },
                            { typeof(PrimaryType.DateTimeRfc1123), "rfc-1123" },
                            { typeof(PrimaryType.TimeSpan), "duration" }
                        };
            if (type is PrimaryType)
            {
                if (typeNameMapping.ContainsKey(type.GetType()))
                {
                    return typeNameMapping[type.GetType()];
                }
                else 
                {
                    return type.Name;
                }
            }
            
            SequenceType sequenceType = type as SequenceType;
            if (sequenceType != null)
            {
                IType innerType = sequenceType.ElementType;
                string innerTypeName;
                if (typeNameMapping.ContainsKey(innerType.GetType()))
                {
                    innerTypeName = typeNameMapping[innerType.GetType()];
                }
                else
                {
                    innerTypeName = innerType.Name;
                }
                return "[" + innerTypeName +"]";
            }

            DictionaryType dictType = type as DictionaryType;
            if (dictType != null)
            {
                IType innerType = dictType.ValueType;
                string innerTypeName;
                if (typeNameMapping.ContainsKey(innerType.GetType()))
                {
                    innerTypeName = typeNameMapping[innerType.GetType()];
                }
                else
                {
                    innerTypeName = innerType.Name;
                }
                return "{" + innerTypeName + "}";
            }

            // CompositeType or EnumType
            return type.Name;
        }

        public static string InitializeProperty(Property property)
        {
            if (property == null || property.Type == null)
            {
                throw new ArgumentNullException("property");
            }

            //'id':{'key':'id', 'type':'str'},
            return string.Format(CultureInfo.InvariantCulture, "'{0}': {{'key': '{1}', 'type': '{2}'}},", property.Name, property.SerializedName, GetPythonSerializationType(property.Type));
        }

        public static string InitializeProperty(string objectName, Property property)
        {
            if (property == null || property.Type == null)
            {
                throw new ArgumentNullException("property");
            }

            return string.Format(CultureInfo.InvariantCulture, "{0}.{1} = None", objectName, property.Name);
        }

        public bool NeedsPolymorphicConverter
        {
            get
            {
                return this.IsPolymorphic && BaseModelType != null;
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
                return "property";
            }

            IType type = property.Type;
            string result = "object";

            if (type is PrimaryType)
            {
                result = type.Name;
            }
            else if (type is SequenceType)
            {
                result = "list";
            }
            else if (type is EnumType)
            {
                result = "str";
            }
            else if (type is DictionaryType)
            {
                result = "dict";
            }
            else if (type is CompositeType)
            {
                result = type.Name;
            }

            return result;
       }
    }
}