using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AutoRest.Core.Model;
using AutoRest.CSharp.LoadBalanced.Model;

namespace AutoRest.CSharp.LoadBalanced.Strategies
{
    public class WrappedPropertyTypeSelectionStrategy : PropertyTypeSelectionStrategy
    {
        private static string[] _datePostfixes = new[] {"When", "Time", "Date"};
        private static string[] _guidPostfixes = new[] { "By", "UserId", "Token" };
        private static string[] _moneyPostfixes = new[] { "Cost", "Rate", "Amount", "Price", "Discount", "Fee", "Percent" };
		private static string[] _booleanSuffixes = new[] { "IsBreakfastIncluded", "allotmentAutoToPup" "Flag", "IsSelected", "IsActive", "IsNonHotelAccomodationMode" };

        public override bool IsDateTime(Property property)
        {
            if(IsDateText(property))
            {
                return true;
            }

            return base.IsDateTime(property);
        }

		public bool IsBoolean(PropertyInfo property)
        {
            return _booleanSuffixes.Any(s => property.Name.EndsWith(s)) && property.PropertyType == typeof(int);
        }
		
        public override bool IsMoney(Property property)
        {
            if (property.ModelType.Name == "string" && _moneyPostfixes.Any(
                p => property.Name.RawValue.ToUpper().EndsWith(p.ToUpper())))
            {
                return true;
            }
            //"type" : "integer", "format" : "int32",
            return base.IsMoney(property);
        }

        public override bool IsGuid(Property property)
        {
            if (property.ModelType.Name == "string" && _guidPostfixes.Any(
                p => property.Name.RawValue.ToUpper().EndsWith(p.ToUpper())))
            {
                return true;
            }

            return base.IsGuid(property);
        }

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

            if (IsDateText(property))
            {
                attributeBuilder.Append("DateTimeStringConverter)");
            }
            //else if (IsGuid(property))
            //{
            //    attributeBuilder.Append("GuidStringConverter)");
            //}
            else if (IsMoney(property))
            {
                attributeBuilder.Append("MoneyConverter");
                var options = new List<string>();

                if (property.ModelType.Name == "string")
                {
                    options.Add("MoneyConverterOptions.SendAsText");
                }

                if (property.IsNullable())
                {
                    options.Add("MoneyConverterOptions.IsNullable");
                }

                if (options.Any())
                {
                    attributeBuilder.Append("), ").Append(string.Join(" | ", options));
                }
                else
                {
                    attributeBuilder.Append(")");
                }
            }
            else if (IsInt32Value(property))
            {
                attributeBuilder.Append("Int32ValueConverter)");
            }
			else if (IsBoolean(property))
            {
                attributeBuilder.Append("BooleanStringConverter)");
            }
            else
            {
                var typeConverterName = base.GetConverterTypeName(property);

                if (string.IsNullOrWhiteSpace(typeConverterName))
                {
                    return null;
                }

                attributeBuilder.Append($"{typeConverterName})");
            }

            attributeBuilder.Append(")");

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

        protected bool IsDateText(Property property)
        {
            return property.ModelType.Name == "string" && _datePostfixes.Any(
                       p => property.Name.RawValue.ToUpper().EndsWith(p.ToUpper()));
        }
    }
}
