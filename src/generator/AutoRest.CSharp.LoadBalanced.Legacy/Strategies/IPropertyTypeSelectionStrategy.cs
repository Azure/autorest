using System.Collections.Generic;
using AutoRest.Core.Model;
using AutoRest.CSharp.LoadBalanced.Legacy.Model;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Strategies
{
    public interface IPropertyTypeSelectionStrategy
    {
        bool IsDateTime(Property property);

        bool IsUrl(Property property);

        bool IsDictionary(Property property);

        #region wrappers.proto

        bool IsUInt64Value(Property property);

        bool IsInt32Value(Property property);

        bool IsUInt32Value(Property property);

        bool IsBoolValue(Property property);

        bool IsStringValue(Property property);

        bool IsBytesValue(Property property);

        #endregion 

        bool IsMoney(Property property);

        bool IsGuid(Property property);

        bool IsBooleanString(Property property);

        bool IsBoolean(Property property);

        string GetConverterTypeName(Property property);

        string GetJsonSerializationAttribute(Property property, bool isCouchbaseModel);

        string GetPropertyTypeName(Property property);

        IEnumerable<Property> GetPropertiesWhichRequireInitialization(CompositeTypeCs compositeType);
        IEnumerable<Property> FilterProperties(Property[] properties);

        bool IsCollection(CompositeTypeCs compositeType);
    }
}