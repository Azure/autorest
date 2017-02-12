using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public class PrimaryTypeTs : PrimaryType, IImplementationNameAware
    {
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
                switch (KnownPrimaryType)
                {
                    case KnownPrimaryType.Boolean:
                        return "boolean";

                    case KnownPrimaryType.Double:
                    case KnownPrimaryType.Decimal:
                    case KnownPrimaryType.Int:
                    case KnownPrimaryType.Long:
                        return "number";

                    case KnownPrimaryType.String:
                        return "string";

                    case KnownPrimaryType.Date:
                    case KnownPrimaryType.DateTime:
                    case KnownPrimaryType.DateTimeRfc1123:
                    case KnownPrimaryType.UnixTime:
                        return "Date";

                    default:
                        return "any";
                }
            }
        }
    }
}
