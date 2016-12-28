using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;
using Newtonsoft.Json;

namespace AutoRest.Java.Model
{
    public class ResponseJv : Response
    {
        protected List<string> _interfaceImports = new List<string>();
        protected List<string> _implImports = new List<string>();

        public ResponseJv()
        {
        }

        public ResponseJv(IModelTypeJv body, IModelTypeJv headers)
            : base(body, headers)
        {
        }

        #region types

        [JsonIgnore]
        public bool NeedsConversion
        {
            get
            {
                return 
                    ((BodyWireType == null ? BodyClientType != null : !BodyWireType.StructurallyEquals(BodyClientType)) && BodyClientType.Name != "void") ||
                    (HeaderWireType == null ? HeaderClientType != null : !HeaderWireType.StructurallyEquals(HeaderClientType));
            }
        }

        [JsonIgnore]
        public virtual IModelTypeJv BodyClientType
        {
            get
            {
                return BodyWireType.ResponseVariant;
            }
        }

        private IModelTypeJv _bodyWireType;

        [JsonIgnore]
        public IModelTypeJv BodyWireType
        {
            get
            {
                if (_bodyWireType == null)
                {
                    if (Body == null)
                    {
                        _bodyWireType = new PrimaryTypeJv(KnownPrimaryType.None);
                    }
                    else
                    {
                        _bodyWireType = (IModelTypeJv) Body;
                    }
                }
                return _bodyWireType;
            }
        }

        [JsonIgnore]
        public IModelTypeJv HeaderClientType
        {
            get
            {
                if (Headers == null)
                {
                    return null;
                }
                else
                {
                    return HeaderWireType.ResponseVariant;
                }
            }
        }

        [JsonIgnore]
        public IModelTypeJv HeaderWireType
        {
            get
            {
                if (Headers == null)
                {
                    return null;
                }
                return (IModelTypeJv)Headers;
            }
        }

        public string ConvertBodyToClientType(string source, string target)
        {
            return convertToClientType(BodyWireType, source, target);
        }

        public string ConvertHeaderToClientType(string source, string target)
        {
            return convertToClientType(HeaderWireType, source, target);
        }

        #endregion

        #region template strings

        [JsonIgnore]
        public string ClientResponseType
        {
            get
            {
                if (Headers == null)
                {
                    return "ServiceResponse";
                }
                else
                {
                    return "ServiceResponseWithHeaders";
                }
            }
        }

        public string WrapResponse(string responseTypeString)
        {
            if (Headers == null)
            {
                return string.Format(CultureInfo.InvariantCulture, "{0}<{1}>", ClientResponseType, responseTypeString);
            }
            else
            {
                return string.Format(CultureInfo.InvariantCulture, "{0}<{1}, {2}>", ClientResponseType, responseTypeString, GenericHeaderClientTypeString);
            }
        }

        [JsonIgnore]
        public string ClientResponseTypeString
        {
            get
            {
                return WrapResponse(GenericBodyClientTypeString);
            }
        }

        [JsonIgnore]
        public virtual string ObservableClientResponseTypeString
        {
            get
            {
                return ClientResponseTypeString;
            }
        }

        [JsonIgnore]
        public virtual string ClientCallbackTypeString
        {
            get
            {
                return GenericBodyClientTypeString;
            }
        }

        [JsonIgnore]
        public string WireResponseTypeString
        {
            get
            {
                if (Headers == null)
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0}<{1}>", ClientResponseType, GenericBodyWireTypeString);
                }
                else
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0}<{1}, {2}>", ClientResponseType, GenericBodyWireTypeString, GenericHeaderWireTypeString);
                }
            }
        }

        [JsonIgnore]
        public virtual string GenericBodyClientTypeString
        {
            get
            {
                var respvariant = BodyWireType.ResponseVariant;
                if ((respvariant as PrimaryTypeJv)?.Nullable != false)
                {
                    return respvariant.Name;
                }
                return BodyWireType.Name;
            }
        }

        [JsonIgnore]
        public string GenericBodyClientTypeStringWrapped
        {
            get
            {
                return WrapResponse(GenericBodyClientTypeString);
            }
        }

        [JsonIgnore]
        public virtual string ServiceCallGenericParameterString
        {
            get
            {
                return GenericBodyClientTypeString;
            }
        }

        [JsonIgnore]
        public virtual string ServiceResponseGenericParameterString
        {
            get
            {
                return ServiceCallGenericParameterString;
            }
        }

        [JsonIgnore]
        public string ServiceResponseGenericParameterStringWrapped
        {
            get
            {
                return WrapResponse(ServiceResponseGenericParameterString);
            }
        }

        [JsonIgnore]
        public virtual string GenericHeaderClientTypeString
        {
            get
            {
                return HeaderClientType.ResponseVariant.Name;
            }
        }

        [JsonIgnore]
        public virtual string GenericBodyWireTypeString
        {
            get
            {
                return BodyWireType.Name;
            }
        }

        [JsonIgnore]
        public string GenericBodyWireTypeStringWrapped
        {
            get
            {
                return WrapResponse(GenericBodyWireTypeString);
            }
        }

        [JsonIgnore]
        public virtual string GenericHeaderWireTypeString
        {
            get
            {
                return HeaderWireType.Name;
            }
        }

        [JsonIgnore]
        public virtual string SequenceElementTypeString
        {
            get
            {
                var sequenceType = Body as SequenceTypeJv;
                return sequenceType != null ? sequenceType.ElementType.Name.ToString() : "Void";
            }
        }

        public string ServiceResponseCreation(string serviceResponse, string body, string response)
        {
            string format;
            if (Headers == null)
            {
                format = "new {0}({1}, {2}.getResponse())";
            }
            else
            {
                format = "new {0}({1}, {2}.getHeaders(), {2}.getResponse())";
            }
            return string.Format(format, serviceResponse, body, response);
        }

        #endregion

        [JsonIgnore]
        public IEnumerable<string> InterfaceImports
        {
            get
            {
                return _interfaceImports.Concat(BodyClientType.ImportSafe()).Concat(HeaderClientType.ImportSafe());
            }
        }

        [JsonIgnore]
        public IEnumerable<string> ImplImports
        {
            get
            {
                var imports = new List<string>(InterfaceImports);
                imports.AddRange(BodyWireType.ImportSafe());
                imports.AddRange(HeaderWireType.ImportSafe());
                if (this.NeedsConversion && (Body is SequenceType || Headers is SequenceType))
                {
                    imports.Add("java.util.ArrayList");
                }
                if (this.NeedsConversion && (Body is DictionaryType || Headers is DictionaryType))
                {
                    imports.Add("java.util.HashMap");
                }
                return imports;
            }
        }

        private string convertToClientType(IModelTypeJv type, string source, string target, int level = 0)
        {
            if (type == null)
            {
                return target + " = " + source + ";";
            }
            
            IndentedStringBuilder builder = new IndentedStringBuilder();

            var sequenceType = type as SequenceTypeJv;
            var dictionaryType = type as DictionaryTypeJv;

            if (sequenceType != null)
            {
                var elementType = sequenceType.ElementType as IModelTypeJv;
                var itemName = string.Format(CultureInfo.InvariantCulture, "item{0}", level == 0 ? "" : level.ToString(CultureInfo.InvariantCulture));
                var itemTarget = string.Format(CultureInfo.InvariantCulture, "value{0}", level == 0 ? "" : level.ToString(CultureInfo.InvariantCulture));
                builder.AppendLine("{0} = new ArrayList<{1}>();", target, elementType.ResponseVariant.Name)
                    .AppendLine("for ({0} {1} : {2}) {{", elementType.Name, itemName, source)
                    .Indent().AppendLine("{0} {1};", elementType.ResponseVariant.Name, itemTarget)
                        .AppendLine(convertToClientType(elementType, itemName, itemTarget, level + 1))
                        .AppendLine("{0}.add({1});", target, itemTarget)
                    .Outdent().Append("}");
                _implImports.Add("java.util.ArrayList");
                return builder.ToString();
            }
            else if (dictionaryType != null)
            {
                var valueType = dictionaryType.ValueType as IModelTypeJv;
                var itemName = string.Format(CultureInfo.InvariantCulture, "entry{0}", level == 0 ? "" : level.ToString(CultureInfo.InvariantCulture));
                var itemTarget = string.Format(CultureInfo.InvariantCulture, "value{0}", level == 0 ? "" : level.ToString(CultureInfo.InvariantCulture));
                builder.AppendLine("{0} = new HashMap<String, {1}>();", target, valueType.ResponseVariant.Name)
                    .AppendLine("for (Map.Entry<String, {0}> {1} : {2}.entrySet()) {{", valueType.Name, itemName, source)
                    .Indent().AppendLine("{0} {1};", valueType.ResponseVariant.Name, itemTarget)
                        .AppendLine(convertToClientType(valueType, itemName + ".getValue()", itemTarget, level + 1))
                        .AppendLine("{0}.put({1}.getKey(), {2});", target, itemName, itemTarget)
                    .Outdent().Append("}");
                _implImports.Add("java.util.HashMap");
                return builder.ToString();
            }
            else if (type.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
            {
                return target + " = " + source + ".getDateTime();";
            }
            else if (type.IsPrimaryType(KnownPrimaryType.UnixTime))
            {
                return target + " = new DateTime(" + source + " * 1000L, DateTimeZone.UTC);";
            }
            else if (type.IsPrimaryType(KnownPrimaryType.Base64Url))
            {
                return target + " = " + source + ".getDecodedBytes();";
            }
            else
            {
                return target + " = " + source + ";";
            }
        }
    }
}
