using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Java.TypeModels
{
    public class ParameterModel : Parameter
    {
        private Method _method;

        public ParameterModel(Parameter parameter, Method method)
            : base()
        {
            this.LoadFrom(parameter);
            this._method = method;
            // Use instance type for optional parameters
            if (!this.IsRequired)
            {
                this.Type = ((ITypeModel) Type).InstanceType();
            }
            _wireName = this.Name.ToCamelCase();
            if (NeedsConversion)
            {
                _wireName += "Converted";
            }
            _implImports = new List<string>();
        }

        public ITypeModel ClientType
        {
            get
            {
                return ((ITypeModel) Type).ParameterVariant;
            }
        }

        public ITypeModel WireType
        {
            get
            {
                if (Type.IsPrimaryType(KnownPrimaryType.Stream))
                {
                    return new PrimaryTypeModel(KnownPrimaryType.Stream) { Name = "RequestBody" };
                }
                else if (!Type.IsPrimaryType(KnownPrimaryType.Base64Url) && Location != ParameterLocation.Body && Location != ParameterLocation.FormData && NeedsSpecialSerialization(ClientType))
                {
                    return new PrimaryTypeModel(KnownPrimaryType.String);
                }
                else
                {
                    return (ITypeModel) Type;
                }
            }
        }

        private string _wireName;

        public string WireName
        {
            get
            {
                return _wireName;
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
            if (Location != ParameterLocation.Body && Location != ParameterLocation.FormData && NeedsSpecialSerialization(ClientType))
            {
                var primary = ClientType as PrimaryTypeModel;
                var sequence = ClientType as SequenceTypeModel;
                if (primary != null && primary.IsPrimaryType(KnownPrimaryType.ByteArray))
                {
                    if (WireType.IsPrimaryType(KnownPrimaryType.String))
                    {
                        return string.Format(CultureInfo.InvariantCulture, "{0} {1} = Base64.encodeBase64String({2});", WireType.Name, _wireName, source);
                    }
                    else
                    {
                        return string.Format(CultureInfo.InvariantCulture, "{0} {1} = Base64Url.encode({2});", WireType.Name, _wireName, source);
                    }
                }
                else if (sequence != null)
                {
                    return string.Format(CultureInfo.InvariantCulture,
                        "{0} {1} = {2}.mapperAdapter().serializeList({3}, CollectionFormat.{4});",
                        WireType.Name,
                        _wireName,
                        clientReference,
                        source,
                        CollectionFormat.ToString().ToUpper(CultureInfo.InvariantCulture));
                }
            }
            
            return convertClientTypeToWireType(WireType, source, _wireName, clientReference);
        }

        private string convertClientTypeToWireType(ITypeModel wireType, string source, string target, string clientReference, int level = 0)
        {
            IndentedStringBuilder builder = new IndentedStringBuilder();
            if (wireType.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
            {
                if (!IsRequired)
                {
                    builder.AppendLine("DateTimeRfc1123 {0} = {1};", target, wireType.DefaultValue(_method))
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
                    builder.AppendLine("Long {0} = {1};", target, wireType.DefaultValue(_method))
                        .AppendLine("if ({0} != null) {{", source).Indent();
                }
                builder.AppendLine("{0}{1} = {2}.toDateTime(DateTimeZone.UTC).getMillis() / 1000;", IsRequired ? "Long " : "", target, source);
            }
            else if (wireType.IsPrimaryType(KnownPrimaryType.Base64Url))
            {
                if (!IsRequired)
                {
                    builder.AppendLine("Base64Url {0} = {1};", target, wireType.DefaultValue(_method))
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
                    builder.AppendLine("RequestBody {0} = {1};", target, wireType.DefaultValue(_method))
                        .AppendLine("if ({0} != null) {{", source).Indent();
                }
                builder.AppendLine("{0}{1} = RequestBody.create(MediaType.parse(\"{2}\"), {3});",
                    IsRequired ? "RequestBody " : "", target, _method.RequestContentType, source);
                if (!IsRequired)
                {
                    builder.Outdent().AppendLine("}");
                }
            }
            else if (wireType is SequenceTypeModel)
            {
                if (!IsRequired)
                {
                    builder.AppendLine("{0} {1} = {2};", WireType.Name, target, wireType.DefaultValue(_method))
                        .AppendLine("if ({0} != null) {{", source).Indent();
                }
                var sequenceType = wireType as SequenceTypeModel;
                var elementType = sequenceType.ElementTypeModel;
                var itemName = string.Format(CultureInfo.InvariantCulture, "item{0}", level == 0 ? "" : level.ToString(CultureInfo.InvariantCulture));
                var itemTarget = string.Format(CultureInfo.InvariantCulture, "value{0}", level == 0 ? "" : level.ToString(CultureInfo.InvariantCulture));
                builder.AppendLine("{0}{1} = new ArrayList<{2}>();", IsRequired ? wireType.Name + " " : "", target, elementType.Name)
                    .AppendLine("for ({0} {1} : {2}) {{", elementType.ParameterVariant.Name, itemName, source)
                    .Indent().AppendLine(convertClientTypeToWireType(elementType, itemName, itemTarget, clientReference, level + 1))
                        .AppendLine("{0}.add({1});", target, itemTarget)
                    .Outdent().Append("}");
                _implImports.Add("java.util.ArrayList");
                if (!IsRequired)
                {
                    builder.Outdent().AppendLine("}");
                }
            }
            else if (wireType is DictionaryTypeModel)
            {
                if (!IsRequired)
                {
                    builder.AppendLine("{0} {1} = {2};", WireType.Name, target, wireType.DefaultValue(_method))
                        .AppendLine("if ({0} != null) {{", source).Indent();
                }
                var dictionaryType = wireType as DictionaryTypeModel;
                var valueType = dictionaryType.ValueTypeModel;
                var itemName = string.Format(CultureInfo.InvariantCulture, "entry{0}", level == 0 ? "" : level.ToString(CultureInfo.InvariantCulture));
                var itemTarget = string.Format(CultureInfo.InvariantCulture, "value{0}", level == 0 ? "" : level.ToString(CultureInfo.InvariantCulture));
                builder.AppendLine("{0}{1} = new HashMap<String, {2}>();", IsRequired ? wireType.Name + " " : "", target, valueType.Name)
                    .AppendLine("for (Map.Entry<String, {0}> {1} : {2}.entrySet()) {{", valueType.ParameterVariant.Name, itemName, source)
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
                if (this.Location == ParameterLocation.Body || !NeedsSpecialSerialization(Type))
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
                if (Location != ParameterLocation.Body)
                {
                    if (this.Type.IsPrimaryType(KnownPrimaryType.ByteArray))
                    {
                        imports.Add("org.apache.commons.codec.binary.Base64");
                    }
                    else if (this.Type is SequenceType)
                    {
                        imports.Add("com.microsoft.rest.serializer.CollectionFormat");
                    }
                }
                if (Type.IsPrimaryType(KnownPrimaryType.Stream) && Location == ParameterLocation.Body)
                {
                    imports.Add("okhttp3.RequestBody");
                    imports.Add("okhttp3.MediaType");
                }
                return imports;
            }
        }

        private string LocationImport(ParameterLocation parameterLocation)
        {
            if (parameterLocation == ParameterLocation.FormData)
            {
                return "retrofit2.http.Part";
            }
            else if (parameterLocation != ParameterLocation.None)
            {
                return "retrofit2.http." + parameterLocation.ToString();
            }
            else
            {
                return null;
            }
        }

        private bool NeedsSpecialSerialization(IType type)
        {
            var known = type as PrimaryType;
            return known != null &&
                type.IsPrimaryType(KnownPrimaryType.ByteArray) ||
                type is SequenceType;
        }
    }
}
