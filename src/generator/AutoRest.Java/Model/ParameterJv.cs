using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;

namespace AutoRest.Java.Model
{
    public class ParameterJv : Parameter
    {
        public ParameterJv()
            : base()
        {
            _implImports = new List<string>();
        }

        public IModelTypeJv ClientType
        {
            get
            {
                return ((IModelTypeJv)ModelType);
            }
        }

        public IModelTypeJv WireType
        {
            get
            {
                if (ModelType.IsPrimaryType(KnownPrimaryType.Stream))
                {
                    var res = new PrimaryTypeJv(KnownPrimaryType.Stream);
                    res.Name.CopyFrom("RequestBody");
                    return res;
                }
                else if (!ModelType.IsPrimaryType(KnownPrimaryType.Base64Url) && 
                    Location != Core.Model.ParameterLocation.Body &&
                    Location != Core.Model.ParameterLocation.FormData && 
                    NeedsSpecialSerialization(ClientType))
                {
                    return new PrimaryTypeJv(KnownPrimaryType.String);
                }
                else
                {
                    return (IModelTypeJv) ModelType;
                }
            }
        }

        public string WireName
        {
            get
            {
                return this.Name.ToCamelCase() + "Converted";
            }
        }

        public bool NeedsConversion
        {
            get
            {
                return ClientType != WireType;
            }
        }

        public string ConvertToWireType(string source, string clientReference)
        {
            if (Location != Core.Model.ParameterLocation.Body && 
                Location != Core.Model.ParameterLocation.FormData && 
                NeedsSpecialSerialization(ModelType))
            {
                var primary = ClientType as PrimaryTypeJv;
                var sequence = ClientType as SequenceTypeJv;
                if (primary != null && primary.IsPrimaryType(KnownPrimaryType.ByteArray))
                {
                    if (WireType.IsPrimaryType(KnownPrimaryType.String))
                    {
                        return string.Format(CultureInfo.InvariantCulture, "{0} {1} = Base64.encodeBase64String({2});", WireType.Name, WireName, source);
                    }
                    else
                    {
                        return string.Format(CultureInfo.InvariantCulture, "{0} {1} = Base64Url.encode({2});", WireType.Name, WireName, source);
                    }
                }
                else if (sequence != null)
                {
                    return string.Format(CultureInfo.InvariantCulture,
                        "{0} {1} = {2}.mapperAdapter().serializeList({3}, CollectionFormat.{4});",
                        WireType.Name,
                        WireName,
                        clientReference,
                        source,
                        CollectionFormat.ToString().ToUpper(CultureInfo.InvariantCulture));
                }
            }
            
            return convertClientTypeToWireType(WireType, source, WireName, clientReference);
        }

        private string convertClientTypeToWireType(IModelTypeJv wireType, string source, string target, string clientReference, int level = 0)
        {
            IndentedStringBuilder builder = new IndentedStringBuilder();
            if (wireType.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
            {
                if (!IsRequired)
                {
                    builder.AppendLine("DateTimeRfc1123 {0} = {1};", target, wireType.DefaultValue)
                        .AppendLine("if ({0} != null) {{", source).Indent();
                }
                builder.AppendLine("{0}{1} = new DateTimeRfc1123({2});", IsRequired ? "DateTimeRfc1123 " : "", target, source);
                if (!IsRequired)
                {
                    builder.Outdent().AppendLine("}");
                }
            }
            else if (wireType.IsPrimaryType(KnownPrimaryType.UnixTime))
            {
                if (!IsRequired)
                {
                    builder.AppendLine("Long {0} = {1};", target, wireType.DefaultValue)
                        .AppendLine("if ({0} != null) {{", source).Indent();
                }
                builder.AppendLine("{0}{1} = {2}.toDateTime(DateTimeZone.UTC).getMillis() / 1000;", IsRequired ? "Long " : "", target, source);
            }
            else if (wireType.IsPrimaryType(KnownPrimaryType.Base64Url))
            {
                if (!IsRequired)
                {
                    builder.AppendLine("Base64Url {0} = {1};", target, wireType.DefaultValue)
                        .AppendLine("if ({0} != null) {{", source).Indent();
                }
                builder.AppendLine("{0}{1} = Base64Url.encode({2});", IsRequired ? "Base64Url " : "", target, source);
                if (!IsRequired)
                {
                    builder.Outdent().AppendLine("}");
                }
            }
            else if (wireType.IsPrimaryType(KnownPrimaryType.Stream))
            {
                if (!IsRequired)
                {
                    builder.AppendLine("RequestBody {0} = {1};", target, wireType.DefaultValue)
                        .AppendLine("if ({0} != null) {{", source).Indent();
                }
                builder.AppendLine("{0}{1} = RequestBody.create(MediaType.parse(\"{2}\"), {3});",
                    IsRequired ? "RequestBody " : "", target, Method.RequestContentType, source);
                if (!IsRequired)
                {
                    builder.Outdent().AppendLine("}");
                }
            }
            else if (wireType is SequenceTypeJv)
            {
                if (!IsRequired)
                {
                    builder.AppendLine("{0} {1} = {2};", WireType.Name, target, wireType.DefaultValue)
                        .AppendLine("if ({0} != null) {{", source).Indent();
                }
                var sequenceType = wireType as SequenceTypeJv;
                var elementType = sequenceType.ElementType as IModelTypeJv;
                var itemName = string.Format(CultureInfo.InvariantCulture, "item{0}", level == 0 ? "" : level.ToString(CultureInfo.InvariantCulture));
                var itemTarget = string.Format(CultureInfo.InvariantCulture, "value{0}", level == 0 ? "" : level.ToString(CultureInfo.InvariantCulture));
                builder.AppendLine("{0}{1} = new ArrayList<{2}>();", IsRequired ? wireType.Name + " " : "", target, elementType.Name)
                    .AppendLine("for ({0} {1} : {2}) {{", elementType.Name, itemName, source)
                    .Indent().AppendLine(convertClientTypeToWireType(elementType, itemName, itemTarget, clientReference, level + 1))
                        .AppendLine("{0}.add({1});", target, itemTarget)
                    .Outdent().Append("}");
                _implImports.Add("java.util.ArrayList");
                if (!IsRequired)
                {
                    builder.Outdent().AppendLine("}");
                }
            }
            else if (wireType is DictionaryTypeJv)
            {
                if (!IsRequired)
                {
                    builder.AppendLine("{0} {1} = {2};", WireType.Name, target, wireType.DefaultValue)
                        .AppendLine("if ({0} != null) {{", source).Indent();
                }
                var dictionaryType = wireType as DictionaryTypeJv;
                var valueType = dictionaryType.ValueType as IModelTypeJv;
                var itemName = string.Format(CultureInfo.InvariantCulture, "entry{0}", level == 0 ? "" : level.ToString(CultureInfo.InvariantCulture));
                var itemTarget = string.Format(CultureInfo.InvariantCulture, "value{0}", level == 0 ? "" : level.ToString(CultureInfo.InvariantCulture));
                builder.AppendLine("{0}{1} = new HashMap<String, {2}>();", IsRequired ? wireType.Name + " " : "", target, valueType.Name)
                    .AppendLine("for (Map.Entry<String, {0}> {1} : {2}.entrySet()) {{", valueType.Name, itemName, source)
                    .Indent().AppendLine(convertClientTypeToWireType(valueType, itemName + ".getValue()", itemTarget, clientReference, level + 1))
                        .AppendLine("{0}.put({1}.getKey(), {2});", target, itemName, itemTarget)
                    .Outdent().Append("}");
                _implImports.Add("java.util.HashMap");
                if (!IsRequired)
                {
                    builder.Outdent().AppendLine("}");
                }
            }
            return builder.ToString();
        }

        public IEnumerable<string> InterfaceImports
        {
            get
            {
                return ClientType.Imports;
            }
        }

        public IEnumerable<string> RetrofitImports
        {
            get
            {
                var imports = new List<string>();
                // type imports
                if (this.Location == Core.Model.ParameterLocation.Body || !NeedsSpecialSerialization(ModelType))
                {
                    imports.AddRange(WireType.Imports);
                }
                // parameter location
                imports.Add(LocationImport(this.Location));
                return imports;
            }
        }

        private List<string> _implImports;
        
        public IEnumerable<string> ClientImplImports
        {
            get
            {
                return ClientType.Imports;
            }
        }

        public IEnumerable<string> WireImplImports
        {
            get
            {
                var imports = new List<string>(WireType.Imports);
                if (Location != Core.Model.ParameterLocation.Body)
                {
                    if (this.ModelType.IsPrimaryType(KnownPrimaryType.ByteArray))
                    {
                        imports.Add("org.apache.commons.codec.binary.Base64");
                    }
                    else if (this.ModelType is SequenceType)
                    {
                        imports.Add("com.microsoft.rest.serializer.CollectionFormat");
                    }
                }
                if (ModelType.IsPrimaryType(KnownPrimaryType.Stream) && Location == Core.Model.ParameterLocation.Body)
                {
                    imports.Add("okhttp3.RequestBody");
                    imports.Add("okhttp3.MediaType");
                }
                return imports;
            }
        }

        private string LocationImport(ParameterLocation parameterLocation)
        {
            if (parameterLocation == Core.Model.ParameterLocation.FormData)
            {
                return "retrofit2.http.Part";
            }
            else if (parameterLocation != Core.Model.ParameterLocation.None)
            {
                return "retrofit2.http." + parameterLocation.ToString();
            }
            else
            {
                return null;
            }
        }

        private bool NeedsSpecialSerialization(IModelType type)
        {
            var known = type as PrimaryType;
            return known != null &&
                type.IsPrimaryType(KnownPrimaryType.ByteArray) ||
                type is SequenceType;
        }
    }
}
