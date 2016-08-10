using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Java.TypeModels
{
    public class ResponseModel
    {
        protected Response _response;
        protected List<string> _interfaceImports;
        protected List<string> _implImports;

        public ResponseModel(Response response)
        {
            this._response = response;
            this._interfaceImports = new List<string>();
            this._implImports = new List<string>();
        }

        public ResponseModel(ITypeModel body, ITypeModel headers)
            : this(new Response(body, headers))
        {
        }

        #region types

        public ITypeModel Body
        {
            get
            {
                return (ITypeModel)_response.Body;
            }
        }

        public ITypeModel Headers
        {
            get
            {
                return (ITypeModel)_response.Headers;
            }
        }

        public bool NeedsConversion
        {
            get
            {
                return BodyWireType != BodyClientType ||
                    HeaderWireType != HeaderClientType;
            }
        }

        public ITypeModel BodyClientType
        {
            get
            {
                return BodyWireType.ResponseVariant;
            }
        }

        private ITypeModel _bodyWireType;

        public ITypeModel BodyWireType
        {
            get
            {
                if (_bodyWireType == null)
                {
                    if (Body == null)
                    {
                        _bodyWireType = new PrimaryTypeModel(KnownPrimaryType.None) { Name = "void" };
                    }
                    else
                    {
                        _bodyWireType = (ITypeModel) Body;
                    }
                }
                return _bodyWireType;
            }
        }

        public ITypeModel HeaderClientType
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

        public ITypeModel HeaderWireType
        {
            get
            {
                if (Headers == null)
                {
                    return null;
                }
                return (ITypeModel)Headers;
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

        public string ClientResponseTypeString
        {
            get
            {
                if (Headers == null)
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0}<{1}>", ClientResponseType, GenericBodyClientTypeString);
                }
                else
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0}<{1}, {2}>", ClientResponseType, GenericBodyClientTypeString, GenericHeaderClientTypeString);
                }
            }
        }

        public virtual string ClientCallbackTypeString
        {
            get
            {
                return GenericBodyClientTypeString;
            }
        }

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

        public virtual string GenericBodyClientTypeString
        {
            get
            {
                return BodyClientType.InstanceType().ResponseVariant.Name;
            }
        }

        public virtual string ServiceCallGenericParameterString
        {
            get
            {
                return GenericBodyClientTypeString;
            }
        }

        public virtual string GenericHeaderClientTypeString
        {
            get
            {
                return HeaderClientType.InstanceType().ResponseVariant.Name;
            }
        }

        public virtual string GenericBodyWireTypeString
        {
            get
            {
                return BodyWireType.InstanceType().Name;
            }
        }

        public virtual string GenericHeaderWireTypeString
        {
            get
            {
                return HeaderWireType.InstanceType().Name;
            }
        }

        public virtual string SequenceElementTypeString
        {
            get
            {
                SequenceTypeModel sequenceType = (SequenceTypeModel) Body;
                return sequenceType != null ? sequenceType.ElementTypeModel.InstanceType().Name : "Void";
            }
        }

        #endregion

        public IEnumerable<string> InterfaceImports
        {
            get
            {
                return _interfaceImports.Concat(BodyClientType.ImportSafe()).Concat(HeaderClientType.ImportSafe());
            }
        }

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

        private string convertToClientType(ITypeModel type, string source, string target, int level = 0)
        {
            if (type == null)
            {
                return target + " = " + source + ";";
            }
            
            IndentedStringBuilder builder = new IndentedStringBuilder();

            SequenceTypeModel sequenceType = type as SequenceTypeModel;
            DictionaryTypeModel dictionaryType = type as DictionaryTypeModel;

            if (sequenceType != null)
            {
                var elementType = sequenceType.ElementTypeModel;
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
                var valueType = dictionaryType.ValueTypeModel;
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
