// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.Java.TypeModels;

namespace AutoRest.Java.TemplateModels
{
    public class ModelTemplateModel : CompositeType
    {
        private ModelTemplateModel _parent = null;

        private JavaCodeNamer _namer;
        
        public ModelTemplateModel(CompositeType source, ServiceClient serviceClient)
        {
            this.LoadFrom(source);
            ServiceClient = serviceClient;
            if(source.BaseModelType != null)
            {
                _parent = new ModelTemplateModel(source.BaseModelType, serviceClient);
            }
            _namer = new JavaCodeNamer(serviceClient.Namespace);
            PropertyModels = new List<PropertyModel>();
            Properties.ForEach(p => PropertyModels.Add(new PropertyModel(p, serviceClient.Namespace)));
        }

        protected virtual JavaCodeNamer Namer
        {
            get
            {
                return _namer;
            }
        }

        public ServiceClient ServiceClient { get; set; }

        public List<PropertyModel> PropertyModels { get; protected set; }

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

        public bool NeedsFlatten
        {
            get
            {
                return this.Properties.Any(p => p.WasFlattened());
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
            if (type.IsPrimaryType(KnownPrimaryType.DateTime) || 
                type.IsPrimaryType(KnownPrimaryType.Date) || 
                type.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123) || 
                type.IsPrimaryType(KnownPrimaryType.ByteArray) || 
                type is CompositeType)
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

        public virtual IEnumerable<String> ImportList
        {
            get
            {
                var classes = new HashSet<string>();
                classes.AddRange(PropertyModels.SelectMany(pm => pm.Imports));
                if (this.Properties.Any(p => !p.GetJsonProperty().IsNullOrEmpty()))
                {
                    classes.Add("com.fasterxml.jackson.annotation.JsonProperty");
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
                // For flattening
                if (NeedsFlatten)
                {
                    classes.Add("com.microsoft.rest.serializer.JsonFlatten");
                }
                return classes.AsEnumerable();
            }
        }

        public virtual string ExceptionTypeDefinitionName
        {
            get
            {
                if (this.Extensions.ContainsKey(SwaggerExtensions.NameOverrideExtension))
                {
                    var ext = this.Extensions[SwaggerExtensions.NameOverrideExtension] as Newtonsoft.Json.Linq.JContainer;
                    if (ext != null && ext["name"] != null)
                    {
                        return ext["name"].ToString();
                    }
                }
                return this.Name + "Exception";
            }
        }

        public virtual string ModelsPackage
        {
            get
            {
                return ".models";
            }
        }
    }
}