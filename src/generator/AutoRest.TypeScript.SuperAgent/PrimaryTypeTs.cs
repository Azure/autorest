using System.Collections.Generic;
using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public class PrimaryTypeTs : PrimaryType, IImplementationNameAware
    {
        public static readonly KnownPrimaryType[] NumericTypes = { KnownPrimaryType.Double, KnownPrimaryType.Decimal, KnownPrimaryType.Int, KnownPrimaryType.Long };
        public static readonly KnownPrimaryType[] TextTypes = { KnownPrimaryType.String, KnownPrimaryType.Uuid };
        public static readonly KnownPrimaryType[] DateTypes = { KnownPrimaryType.Date, KnownPrimaryType.DateTime, KnownPrimaryType.DateTimeRfc1123, KnownPrimaryType.UnixTime };
        public const string NumberTypeName = "number";
        public const string TextTypeName = "string";
        public const string DateTypeName = "Date";
        public const string BoolTypeName = "boolean";
        public const string AnyTypeName = "any";
        private static readonly Dictionary<KnownPrimaryType, string> TypeNameMappings;

        static PrimaryTypeTs()
        {
            TypeNameMappings = new Dictionary<KnownPrimaryType, string> {{KnownPrimaryType.Boolean, BoolTypeName} };

            foreach (var type in NumericTypes)
            {
                TypeNameMappings.Add(type, NumberTypeName);
            }

            foreach (var type in TextTypes)
            {
                TypeNameMappings.Add(type, TextTypeName);
            }

            foreach (var type in DateTypes)
            {
                TypeNameMappings.Add(type, DateTypeName);
            }
        }

        public PrimaryTypeTs(KnownPrimaryType primaryType) : base(primaryType)
        {
            Name.OnGet += v => ImplementationName;
        }

        protected PrimaryTypeTs()
        {
            Name.OnGet += v => ImplementationName;
        }

        public virtual string ImplementationName
        {
            get
            {
                string name;
                return TypeNameMappings.TryGetValue(KnownPrimaryType, out name) ? name : AnyTypeName;
            }
        }
    }
}
