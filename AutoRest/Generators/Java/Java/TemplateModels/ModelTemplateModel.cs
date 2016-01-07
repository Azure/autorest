// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java
{
    public class ModelTemplateModel : CompositeType
    {
        private ModelTemplateModel _parent = null;
        
        public ModelTemplateModel(CompositeType source, ServiceClient serviceClient)
        {
            this.LoadFrom(source);
            ServiceClient = serviceClient;
            if(source.BaseModelType != null)
            {
                _parent = new ModelTemplateModel(source.BaseModelType, serviceClient);
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

        public string EvaluatedPolymorphicDiscriminator
        {
            get
            {
                if (!string.IsNullOrEmpty(this.PolymorphicDiscriminator))
                {
                    return this.PolymorphicDiscriminator;
                }
                else if (this._parent != null)
                {
                    return _parent.EvaluatedPolymorphicDiscriminator;
                }
                else
                {
                    return "";
                }
            }
        }

        public IEnumerable<CompositeType> SubTypes
        {
            get
            {
                if (IsPolymorphic) {
                    foreach (CompositeType type in ServiceClient.ModelTypes) {
                        if (type.BaseModelType != null &&
                            type.BaseModelType.SerializedName == this.SerializedName)
                        {
                            yield return type;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Returns list of properties that needs to be explicitly deserializes for a model.
        /// </summary>
        public IEnumerable<Property> SpecialProperties
        {
            get
            {
                foreach (var property in ComposedProperties)
                {
                    if (isSpecial(property.Type))
                    {
                        yield return property;
                    }
                }
            }
        }

        private bool isSpecial(IType type)
        {
            if (type == PrimaryType.DateTime || type == PrimaryType.Date || type == PrimaryType.DateTimeRfc1123 || type == PrimaryType.ByteArray || type is CompositeType)
            {
                return true;
            }
            else if (type is SequenceType)
            {
                return isSpecial(((SequenceType)type).ElementType);
            }
            else if (type is DictionaryType)
            {
                return isSpecial(((DictionaryType)type).ValueType);
            }
            return false;
        }

        public virtual IEnumerable<String> ImportList {
            get
            {
                HashSet<String> classes = new HashSet<string>();
                foreach (var property in this.Properties)
                {
                    if (property.Type is SequenceType)
                    {
                        classes.Add("java.util.List");
                    }
                    else if (property.Type is DictionaryType)
                    {
                        classes.Add("java.util.Map");
                    }
                    else if (property.Type is PrimaryType)
                    {
                        var importedFrom = JavaCodeNamer.GetJavaType(property.Type as PrimaryType);
                        if (importedFrom != null)
                        {
                            classes.Add(importedFrom);
                        }
                    }

                    if (this.Properties.Any(p => !p.GetJsonProperty().IsNullOrEmpty()))
                    {
                        classes.Add("com.fasterxml.jackson.annotation.JsonProperty");
                    }
                }
                // For polymorphism
                if (IsPolymorphic)
                {
                    classes.Add("com.fasterxml.jackson.annotation.JsonTypeInfo");
                    classes.Add("com.fasterxml.jackson.annotation.JsonTypeName");
                    if (SubTypes.Any())
                    {
                        classes.Add("com.fasterxml.jackson.annotation.JsonSubTypes");
                    }
                }
                return classes.AsEnumerable();
            }
        }

        public virtual string ExceptionTypeDefinitionName
        {
            get
            {
                if (this.Extensions.ContainsKey(Microsoft.Rest.Generator.Extensions.NameOverrideExtension))
                {
                    var ext = this.Extensions[Microsoft.Rest.Generator.Extensions.NameOverrideExtension] as Newtonsoft.Json.Linq.JContainer;
                    if (ext != null && ext["name"] != null)
                    {
                        return ext["name"].ToString();
                    }
                }
                return this.Name + "Exception";
            }
        }
    }
}