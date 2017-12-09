using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.LoadBalanced.Legacy.Model;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Strategies
{
    public class PropertyTypeSelectionStrategy : IPropertyTypeSelectionStrategy
    {
        private static List<Tuple<Func<Property, bool>, string>> _typeMappings;

        public PropertyTypeSelectionStrategy()
        {
            _typeMappings = new List<Tuple<Func<Property, bool>, string>>
                            {
                                new Tuple<Func<Property, bool>, string>(IsDateTime, "DateTime"),
                                new Tuple<Func<Property, bool>, string>(IsUInt64Value, "long?"),
                                new Tuple<Func<Property, bool>, string>(IsInt32Value, "int?"),
                                new Tuple<Func<Property, bool>, string>(IsUInt32Value, "unint?"),
                                new Tuple<Func<Property, bool>, string>(IsBoolValue, "bool?"),
                                new Tuple<Func<Property, bool>, string>(IsStringValue, "string"),
                                new Tuple<Func<Property, bool>, string>(IsBytesValue, "byte[]?")
                            };
        }


        public virtual bool IsDateTime(Property property)
        {
            return IsDate(property.ModelType) || IsDateTimeRfc1123(property.ModelType) || IsUnixTime(property.ModelType);
        }

        public virtual bool IsUrl(Property property)
        {
            return property.ModelType.IsPrimaryType(KnownPrimaryType.Base64Url);
        }

        public virtual bool IsDictionary(Property property)
        {
            return (property.ModelType as DictionaryType)?.SupportsAdditionalProperties == true;
        }

        #region wrappers.proto

        public virtual bool IsUInt64Value(Property property)
        {
            return false;
        }

        public virtual bool IsInt32Value(Property property)
        {
            return false;
        }

        public virtual bool IsUInt32Value(Property property)
        {
            return false;
        }

        public virtual bool IsBoolValue(Property property)
        {
            return false;
        }

        public virtual bool IsStringValue(Property property)
        {
            return false;
        }

        public virtual bool IsBytesValue(Property property)
        {
            return false;
        }

        #endregion 

        public virtual bool IsMoney(Property property)
        {
            return false;
        }

        public virtual bool IsGuid(Property property)
        {
            return false;
        }

        public virtual bool IsBooleanString(Property property)
        {
            return false;
        }

        public virtual bool IsBoolean(Property property)
        {
            return property.ModelType.IsPrimaryType(KnownPrimaryType.Boolean);
        }

        public virtual string GetConverterTypeName(Property property)
        {
            if (IsDate(property.ModelType))
            {
                return "DateJsonConverter";
            }

            if (IsDateTimeRfc1123(property.ModelType))
            {
                return "DateTimeRfc1123JsonConverter";
            }

            if (IsUnixTime(property.ModelType))
            {
                return "UnixTimeJsonConverter";
            }

            if (IsUrl(property))
            {
                return "Base64UrlJsonConverter";
            }

            return null;
        }

        public string GetJsonSerializationAttribute(Property property, bool isCouchbaseModel)
        {
            
            var typeConverterName = GetConverterTypeName(property);

            if (typeConverterName != null && !isCouchbaseModel)
            {
                return $"[JsonProperty(PropertyName = \"{property.SerializedName}\", NullValueHandling=NullValueHandling.Ignore), {typeConverterName}]";
            }

            return IsDictionary(property) ? "[JsonExtensionData]" : 
                $"[JsonProperty(PropertyName = \"{property.SerializedName}\", NullValueHandling=NullValueHandling.Ignore)]";
        }

        public string GetPropertyTypeName(Property property)
        {
            if (IsMoney(property))
            {
                return "decimal";
            }
            else if (IsBooleanString(property))
            {
                return "bool";
            }
            else
            {
                var typeName = _typeMappings.FirstOrDefault(m => m.Item1(property))?.Item2;
                return !string.IsNullOrWhiteSpace(typeName) ? typeName : property.ModelTypeName;
            }
        }

        public virtual IEnumerable<Property> GetPropertiesWhichRequireInitialization(CompositeTypeCs compositeType)
        {
            return compositeType.ComposedProperties.Where(p => p.ModelType is CompositeType
                                                               && !p.IsConstant
                                                               && p.IsRequired
                                                               && ((CompositeType)p.ModelType).ContainsConstantProperties);
        }

        protected bool IsDate(IModelType modelType)
        {
            return modelType.IsPrimaryType(KnownPrimaryType.Date);
        }

        protected bool IsDateTimeRfc1123(IModelType modelType)
        {
            return modelType.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123);
        }

        protected bool IsUnixTime(IModelType modelType)
        {
            return modelType.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123);
        }

        public virtual IEnumerable<Property> FilterProperties(Property[] properties)
        {
            return properties;
        }

        public virtual bool IsCollection(CompositeTypeCs compositeType)
        {
            return false;
        }
    }
}
