using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;

namespace AutoRest.Java.Model
{
    public class PropertyJv : Property
    {
        protected string _package;

        public PropertyJv(Property property, string package)
            : base()
        {
            this.LoadFrom(property);
            this._package = package.ToLower(CultureInfo.InvariantCulture);
        }

        public string ClientForm
        {
            get
            {
                if (ModelType.IsPrimaryType(KnownPrimaryType.Base64Url))
                {
                    return string.Format("this.{0}.getDecodedBytes()", Name, CultureInfo.InvariantCulture);
                }
                else if (ModelType.IsPrimaryType(KnownPrimaryType.UnixTime))
                {
                    return "new DateTime(this." + Name + " * 1000L, DateTimeZone.UTC)";
                }
                else if (ModelType.Name != ((IModelTypeJv)ModelType).ResponseVariant.Name)
                {
                    return string.Format("this.{0}.get{1}()", Name, ((IModelTypeJv)ModelType).ResponseVariant, CultureInfo.InvariantCulture);
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
                if (ModelType.IsPrimaryType(KnownPrimaryType.Base64Url))
                {
                    return string.Format("Base64Url.encode({0})", Name, CultureInfo.InvariantCulture);
                }
                else if (ModelType.IsPrimaryType(KnownPrimaryType.UnixTime))
                {
                    return string.Format("{0}.toDateTime(DateTimeZone.UTC).getMillis() / 1000", Name, CultureInfo.InvariantCulture);
                }
                else if (ModelType.Name != ((IModelTypeJv)ModelType).ResponseVariant.Name)
                {
                    return string.Format("new {0}({1})", ModelType.Name, Name, CultureInfo.InvariantCulture);
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
                var imports = new List<string>(ModelType.ImportSafe()
                        .Where(c => !c.StartsWith(
                            string.Join(".", _package, "models"),
                            StringComparison.OrdinalIgnoreCase)));
                if (ModelType.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123)
                    || ModelType.IsPrimaryType(KnownPrimaryType.Base64Url))
                {
                    imports.AddRange(ModelType.ImportSafe());
                    imports.AddRange(((IModelTypeJv)ModelType).ResponseVariant.ImportSafe());
                }
                return imports;
            }
        }
    }
}
