using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Java.TypeModels
{
    public class PropertyModel : Property
    {
        protected string _package;

        public PropertyModel(Property property, string package)
            : base()
        {
            this.LoadFrom(property);
            this._package = package.ToLower(CultureInfo.InvariantCulture);
        }

        public string ClientForm
        {
            get
            {
                if (Type.IsPrimaryType(KnownPrimaryType.Base64Url))
                {
                    return string.Format("this.{0}.getDecodedBytes()", Name, CultureInfo.InvariantCulture);
                }
                else if (Type.IsPrimaryType(KnownPrimaryType.UnixTime))
                {
                    return "new DateTime(this." + Name + " * 1000L, DateTimeZone.UTC)";
                }
                else if (Type.Name != ((ITypeModel) Type).ResponseVariant.Name)
                {
                    return string.Format("this.{0}.get{1}()", Name, ((ITypeModel)Type).ResponseVariant, CultureInfo.InvariantCulture);
                }
                else
                {
                    return Name;
                }
            }
        }

        public string FromClientForm
        {
            get
            {
                if (Type.IsPrimaryType(KnownPrimaryType.Base64Url))
                {
                    return string.Format("Base64Url.encode({0})", Name, CultureInfo.InvariantCulture);
                }
                else if (Type.IsPrimaryType(KnownPrimaryType.UnixTime))
                {
                    return string.Format("{0}.toDateTime(DateTimeZone.UTC).getMillis() / 1000", Name, CultureInfo.InvariantCulture);
                }
                else if (Type.Name != ((ITypeModel)Type).ResponseVariant.Name)
                {
                    return string.Format("new {0}({1})", Type.Name, Name, CultureInfo.InvariantCulture);
                }
                else
                {
                    return Name;
                }
            }
        }

        public virtual IEnumerable<string> Imports
        {
            get
            {
                var imports = new List<string>(Type.ImportSafe()
                        .Where(c => !c.StartsWith(
                            string.Join(".", _package, "models"),
                            StringComparison.OrdinalIgnoreCase)));
                if (Type.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123)
                    || Type.IsPrimaryType(KnownPrimaryType.Base64Url))
                {
                    imports.AddRange(Type.ImportSafe());
                    imports.AddRange(((ITypeModel) Type).ResponseVariant.ImportSafe());
                }
                return imports;
            }
        }
    }
}
