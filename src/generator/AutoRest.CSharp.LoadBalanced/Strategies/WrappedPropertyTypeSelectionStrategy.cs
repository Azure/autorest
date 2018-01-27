using System.Collections.Generic;
using System.Linq;
using System.Text;
using AutoRest.Core.Model;
using AutoRest.CSharp.LoadBalanced.Model;

namespace AutoRest.CSharp.LoadBalanced.Strategies
{
    public class WrappedPropertyTypeSelectionStrategy : PropertyTypeSelectionStrategy
    {
        public override bool IsUInt64Value(Property property)
        {
            return false;
        }

        public override bool IsInt32Value(Property property)
        {
            return false;
        }

        public override bool IsUInt32Value(Property property)
        {
            return false;
        }

        public override bool IsBoolValue(Property property)
        {
            return false;
        }

        public override bool IsStringValue(Property property)
        {
            return false;
        }

        public override bool IsBytesValue(Property property)
        {
            return false;
        }

        public override string GetConverterTypeName(Property property)
        {
            var attributeBuilder = new StringBuilder();
            attributeBuilder.Append("JsonConverter(typeof(");
            
                var typeConverterName = base.GetConverterTypeName(property);

                if (string.IsNullOrWhiteSpace(typeConverterName))
                {
                    return null;
                }

                attributeBuilder.Append($"{typeConverterName})");

            attributeBuilder.Append("))");

            return attributeBuilder.ToString();
        }

        public override bool IsCollection(CompositeTypeCs compositeType)
        {
            if (!compositeType.Name.Value.EndsWith("List"))
            {
                return false;
            }

            var properties = compositeType.GetFilteredProperties().Where(p => p.ModelType is SequenceTypeCs);
            
            return properties.Count() == 1;
        }

        public override IEnumerable<Property> FilterProperties(Property[] properties)
        {
            // AllFields is not required 
            return base.FilterProperties(properties).Where(p => p.Name.Value != "AllFields");
        }

        public override IEnumerable<Property> GetPropertiesWhichRequireInitialization(CompositeTypeCs compositeType)
        {
            var baseProperties = base.GetPropertiesWhichRequireInitialization(compositeType).ToArray();
            return baseProperties.Where(p => p.Name.Value != "AllFields");
        }
        
    }
}
