using System;
using System.Linq;
using AutoRest.Core.Model;

namespace AutoRest.CSharp.LoadBalanced.Strategies
{
    public class WrappedPropertyTypeSelectionStrategy : PropertyTypeSelectionStrategy
    {
        private static string[] _datePostfixes = new[] {"When", "Time", "Date"};
        private static string[] _guidPostfixes = new[] { "By", "UserId", "Token" };
        private static string[] _moneyPostfixes = new[] { "Cost", "Rate", "Amount", "Price", "Discount", "Fee", "Percent" };
        private readonly Type[] _moneyTypes = new[] { typeof(int), typeof(float), typeof(double) };

        public override bool IsDateTime(Property property)
        {
            if(IsDateText(property))
            {
                return true;
            }

            return base.IsDateTime(property);
        }

        public override bool IsMoney(Property property)
        {
            if (property.ModelType.Name == "string" && _moneyPostfixes.Any(
                p => property.Name.RawValue.ToUpper().EndsWith(p.ToUpper())))
            {
                return true;
            }

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
            if(IsDateText(property))
            {
                return "AutoRest.CSharp.LoadBalanced.Json.DateTimeStringConverter";
            }

            if (IsGuid(property))
            {
                return "AutoRest.CSharp.LoadBalanced.Json.GuidStringConverter";
            }

            if (IsMoney(property))
            {
                return "AutoRest.CSharp.LoadBalanced.Json.MoneyStringConverter";
            }

            if (IsInt32Value(property))
            {
                return "AutoRest.CSharp.LoadBalanced.Json.Int32ValueConverter";
            }

            var typeConverterName = base.GetConverterTypeName(property);

            if (string.IsNullOrWhiteSpace(typeConverterName))
            {
                return typeConverterName;
            }

            // TODO: this is where we can put the custom wrapper related type converters
            return null;
        }


        protected bool IsDateText(Property property)
        {
            return property.ModelType.Name == "string" && _datePostfixes.Any(
                       p => property.Name.RawValue.ToUpper().EndsWith(p.ToUpper()));
        }
    }
}
