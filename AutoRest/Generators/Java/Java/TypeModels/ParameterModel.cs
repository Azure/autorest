using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;

namespace Microsoft.Rest.Generator.Java
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
                else if ((Location != ParameterLocation.Body)
                    && NeedsSpecialSerialization(Type))
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
            if (Location != ParameterLocation.Body && Location != ParameterLocation.FormData)
            {
                var primary = ClientType as PrimaryTypeModel;
                var sequence = ClientType as SequenceTypeModel;
                if (primary != null && !NeedsSpecialSerialization(primary))
                {
                    return source;
                }
                if (primary != null && primary.IsPrimaryType(KnownPrimaryType.ByteArray))
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0} {1} = Base64.encodeBase64String({2});", WireType.Name, _wireName, source);
                }
                else if (sequence != null)
                {
                    return string.Format(CultureInfo.InvariantCulture,
                        "{0} {1} = {2}.getMapperAdapter().serializeList({3}, CollectionFormat.{4});",
                        WireType.Name,
                        _wireName,
                        clientReference,
                        source,
                        CollectionFormat.ToString().ToUpper(CultureInfo.InvariantCulture));
                }
                else
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0} {1} = {2}.getMapperAdapter().serializeRaw({3});",
                        WireType.Name,
                        _wireName,
                        clientReference,
                        source);
                }
            }
            
            return convertClientTypeToWireType(WireType, source, _wireName, clientReference);
        }

        private string convertClientTypeToWireType(ITypeModel wireType, string source, string target, string clientReference, int level = 0)
        {
            IndentedStringBuilder builder = new IndentedStringBuilder();
            if (wireType.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
            {
                builder.AppendLine("DateTimeRfc1123 {0} = new DateTimeRfc1123({1});", target, source);
            }
            else if (wireType.IsPrimaryType(KnownPrimaryType.Stream))
            {
                builder.AppendLine("RequestBody {0} = RequestBody.create(MediaType.parse(\"{1}\"), {2});",
                    target, _method.RequestContentType, source);
            }
            else if (wireType is SequenceTypeModel)
            {
                var sequenceType = wireType as SequenceTypeModel;
                var elementType = sequenceType.ElementTypeModel;
                var itemName = string.Format("item{0}", level == 0 ? "" : level.ToString());
                var itemTarget = string.Format("value{1}", target, level == 0 ? "" : level.ToString());
                builder.AppendLine("{0} {1} = new ArrayList<{2}>();", wireType.Name ,target, elementType.Name)
                    .AppendLine("for ({0} {1} : {2}) {{", elementType.ParameterVariant.Name, itemName, source)
                    .Indent().AppendLine(convertClientTypeToWireType(elementType, itemName, itemTarget, clientReference, level + 1))
                        .AppendLine("{0}.add({1});", target, itemTarget)
                    .Outdent().Append("}");
                _implImports.Add("java.util.ArrayList");
                return builder.ToString();
            }
            else if (wireType is DictionaryTypeModel)
            {
                var dictionaryType = wireType as DictionaryTypeModel;
                var valueType = dictionaryType.ValueTypeModel;
                var itemName = string.Format("entry{0}", level == 0 ? "" : level.ToString());
                var itemTarget = string.Format("value{1}", target, level == 0 ? "" : level.ToString());
                builder.AppendLine("{0} {1} = new HashMap<String, {2}>();", wireType.Name, target, valueType.Name)
                    .AppendLine("for (Map.Entry<String, {0}> {1} : {2}.entrySet()) {{", valueType.ParameterVariant.Name, itemName, source)
                    .Indent().AppendLine(convertClientTypeToWireType(valueType, itemName + ".getValue()", itemTarget, clientReference, level + 1))
                        .AppendLine("{0}.put({1}.getKey(), {2});", target, itemName, itemTarget)
                    .Outdent().Append("}");
                _implImports.Add("java.util.HashMap");
                return builder.ToString();
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
                    imports.AddRange(ClientType.Imports);
                }
                // parameter location
                imports.Add(LocationImport(this.Location));
                return imports;
            }
        }

        private List<string> _implImports;

        public IEnumerable<string> ImplImports
        {
            get
            {
                var imports = new List<string>(ClientType.Imports);
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
                type.IsPrimaryType(KnownPrimaryType.Date) ||
                type.IsPrimaryType(KnownPrimaryType.DateTime) ||
                type.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123) || 
                type.IsPrimaryType(KnownPrimaryType.ByteArray) ||
                type is EnumType || type is CompositeType || type is SequenceType || type is DictionaryType;
        }
    }
}
