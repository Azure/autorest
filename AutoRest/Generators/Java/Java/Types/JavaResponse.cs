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
    public class JavaResponse
    {
        private Response _response;

        public JavaResponse(Response response)
        {
            this._response = response;
        }

        public JavaResponse(IJavaType body, IJavaType headers)
            : this(new Response(body, headers))
        {
        }

        public IJavaType Body
        {
            get
            {
                if (_response == null)
                {
                    return null;
                }
                return (IJavaType)_response.Body;
            }
        }

        public IJavaType Headers
        {
            get
            {
                if (_response == null)
                {
                    return null;
                }
                return (IJavaType)_response.Headers;
            }
        }

        public bool NeedsConversion
        {
            get
            {
                return (Body != null &&
                    Body.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
                        ||
                    (Headers != null &&
                    Headers.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123));
            }
        }

        public IJavaType BodyClientType
        {
            get
            {
                if (Body == null)
                {
                    return null;
                }
                else if (Body.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
                {
                    return new JavaPrimaryType(KnownPrimaryType.DateTime);
                }
                else
                {
                    return BodyWireType;
                }
            }
        }

        public IJavaType BodyWireType
        {
            get
            {
                if (Body == null)
                {
                    return null;
                }
                return (IJavaType) Body;
            }
        }

        public IJavaType HeaderClientType
        {
            get
            {
                if (Headers == null)
                {
                    return null;
                }
                else if (Headers.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
                {
                    return new JavaPrimaryType(KnownPrimaryType.DateTime);
                }
                else
                {
                    return HeaderWireType;
                }
            }
        }

        public IJavaType HeaderWireType
        {
            get
            {
                if (Headers == null)
                {
                    return null;
                }
                return (IJavaType)Headers;
            }
        }

        public string ConvertBodyToClientType(string reference)
        {
            return converToClientType(Body, reference);
        }

        public string ConvertHeaderToClientType(string reference)
        {
            return converToClientType(Headers, reference);
        }

        public IEnumerable<string> InterfaceImports
        {
            get
            {
                return BodyClientType.ImportSafe().Concat(HeaderClientType.ImportSafe());
            }
        }

        public IEnumerable<string> ImplImports
        {
            get
            {
                var imports = new List<string>(InterfaceImports);
                imports.AddRange(BodyWireType.ImportSafe());
                imports.AddRange(HeaderWireType.ImportSafe());
                return imports;
            }
        }

        private string converToClientType(IType type, string reference)
        {
            if (type == null)
            {
                return reference;
            }
            else if (type.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
            {
                return reference + ".getDateTime()";
            }
            else
            {
                return reference;
            }
        }
    }
}
