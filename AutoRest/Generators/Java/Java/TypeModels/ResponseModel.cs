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
    public class ResponseModel
    {
        private Response _response;

        public ResponseModel(Response response)
        {
            this._response = response;
        }

        public ResponseModel(ITypeModel body, ITypeModel headers)
            : this(new Response(body, headers))
        {
        }

        public ITypeModel Body
        {
            get
            {
                if (_response == null)
                {
                    return null;
                }
                return (ITypeModel)_response.Body;
            }
        }

        public ITypeModel Headers
        {
            get
            {
                if (_response == null)
                {
                    return null;
                }
                return (ITypeModel)_response.Headers;
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

        public ITypeModel BodyClientType
        {
            get
            {
                if (Body == null)
                {
                    return new PrimaryTypeModel(KnownPrimaryType.None) { Name = "void" };
                }
                else if (Body.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
                {
                    return new PrimaryTypeModel(KnownPrimaryType.DateTime);
                }
                else
                {
                    return BodyWireType;
                }
            }
        }

        public ITypeModel BodyWireType
        {
            get
            {
                if (Body == null)
                {
                    return new PrimaryTypeModel(KnownPrimaryType.None) { Name = "void" };
                }
                return (ITypeModel) Body;
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
                else if (Headers.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
                {
                    return new PrimaryTypeModel(KnownPrimaryType.DateTime);
                }
                else
                {
                    return HeaderWireType;
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

        public string OperationResponseType
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
