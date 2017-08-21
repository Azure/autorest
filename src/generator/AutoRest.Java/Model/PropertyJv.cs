using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;
using AutoRest.Extensions;
using Newtonsoft.Json;

namespace AutoRest.Java.Model
{
    public class PropertyJv : Property
    {
        public PropertyJv()
        {
        }

        public override string SerializedName
        {
            get => Extensions.ContainsKey(SwaggerExtensions.FlattenOriginalTypeName) ? base.SerializedName : base.SerializedName?.Replace(".", "\\\\.")?.Replace("\\\\\\\\", "\\\\");
            set => base.SerializedName = value;
        }


        [JsonIgnore]
        public bool WantNullable => IsXNullable ?? !IsRequired;

        public override IModelType ModelType
        {
            get
            {
                if (base.ModelType == null)
                {
                    return null;
                }
                return WantNullable 
                    ? base.ModelType 
                    : (base.ModelType as IModelTypeJv).NonNullableVariant;
            }
            set
            {
                base.ModelType = value;
            }
        }

        [JsonIgnore]
        public string ClientForm
        {
            get
            {
                if (ModelType.IsPrimaryType(KnownPrimaryType.Base64Url))
                {
                    return string.Format("this.{0}.decodedBytes()", Name, CultureInfo.InvariantCulture);
                }
                else if (ModelType.IsPrimaryType(KnownPrimaryType.UnixTime))
                {
                    return "new DateTime(this." + Name + " * 1000L, DateTimeZone.UTC)";
                }
                else if (ModelType.Name != ((IModelTypeJv)ModelType).ResponseVariant.Name)
                {
                    return string.Format("this.{0}.{1}()", Name, ((IModelTypeJv)ModelType).ResponseVariant.Name.ToCamelCase(), CultureInfo.InvariantCulture);
                }
                else
                {
                    return Name;
                }
            }
        }

        [JsonIgnore]
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

        [JsonIgnore]
        public virtual IEnumerable<string> Imports
        {
            get
            {
                var imports = new List<string>(ModelType.ImportSafe()
                        .Where(c => !c.StartsWith(
                            string.Join(
                                ".",
                                Parent?.CodeModel?.Namespace.ToLowerInvariant(),
                                "models"),
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
