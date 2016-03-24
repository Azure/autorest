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
    public class JavaParameter : Parameter
    {
        private MethodTemplateModel _method;

        public JavaParameter(Parameter parameter, MethodTemplateModel method)
            : base()
        {
            this.LoadFrom(parameter);
            this._method = method;
        }

        public IJavaType ClientType
        {
            get
            {
                return (IJavaType) Type;
            }
        }

        public IJavaType WireType
        {
            get
            {
                if (Type.IsPrimaryType(KnownPrimaryType.Stream))
                {
                    return new JavaPrimaryType(KnownPrimaryType.Stream) { Name = "RequestBody" };
                }
                else if ((Location != ParameterLocation.Body)
                    && NeedsSpecialSerialization(Type))
                {
                    return new JavaPrimaryType(KnownPrimaryType.String);
                }
                else
                {
                    return ClientType;
                }
            }
        }

        public string Invoke(string reference, string clientReference)
        {
            if (ClientType.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
            {
                return string.Format(CultureInfo.InvariantCulture, "new DateTimeRfc1123({0})", reference);
            }
            else if (Location != ParameterLocation.Body && Location != ParameterLocation.FormData)
            {
                var primary = ClientType as JavaPrimaryType;
                var sequence = ClientType as JavaSequenceType;
                if (primary != null && primary.Name != "LocalDate" && primary.Name != "DateTime")
                {
                    if (primary.Type == KnownPrimaryType.ByteArray)
                    {
                        return "Base64.encodeBase64String(" + reference + ")";
                    }
                    else
                    {
                        return reference;
                    }
                }
                else if (sequence != null)
                {
                    return clientReference + ".getMapperAdapter().serializeList(" + reference +
                        ", CollectionFormat." + CollectionFormat.ToString().ToUpper(CultureInfo.InvariantCulture) + ")";
                }
                else
                {
                    return clientReference + ".getMapperAdapter().serializeRaw(" + reference + ")";
                }
            }
            else if (ClientType.IsPrimaryType(KnownPrimaryType.Stream))
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "RequestBody.create(MediaType.parse(\"{0}\"), {1})",
                    _method.RequestContentType, reference);
            }
            else
            {
                return reference;
            }
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
                if (Type.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
                {
                    imports.Add("com.microsoft.rest.DateTimeRfc1123");
                }
                // parameter location
                imports.Add(LocationImport(this.Location));
                return imports;
            }
        }

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
                if (Type.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
                {
                    imports.Add("com.microsoft.rest.DateTimeRfc1123");
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
            return (known != null && (known.Name == "LocalDate" || known.Name == "DateTime" || known.Type == KnownPrimaryType.ByteArray)) ||
                type is EnumType || type is CompositeType || type is SequenceType || type is DictionaryType;
        }
    }
}
