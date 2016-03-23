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
    public class JavaPrimaryType : PrimaryType, IJavaType
    {
        private List<string> _commonImports;
        
        public JavaPrimaryType(KnownPrimaryType knownPrimaryType)
            : this (new PrimaryType(knownPrimaryType))
        {
        }

        public JavaPrimaryType(PrimaryType primaryType)
            : base (primaryType != null ? primaryType.Type : KnownPrimaryType.None)
        {
            if (primaryType == null)
            {
                throw new ArgumentNullException("primaryType");
            }

            this.LoadFrom(primaryType);
            _commonImports = new List<string>();
            _bodyFormat = "{0}";
            _headerFormat = "{0}";
            Initialize(primaryType);
        }

        public string ParameterType
        {
            get
            {
                if (Type == KnownPrimaryType.DateTimeRfc1123)
                {
                    return "DateTime";
                }
                else if (Type == KnownPrimaryType.Stream)
                {
                    return "byte[]";
                }
                else
                {
                    return Name;
                }
            }
        }

        public string ResponseType
        {
            get
            {
                if (Type == KnownPrimaryType.DateTimeRfc1123)
                {
                    return "DateTime";
                }
                else
                {
                    return Name;
                }
            }
        }

        private string _bodyFormat;

        public string BodyValue(string reference)
        {
            return string.Format(CultureInfo.InvariantCulture, _bodyFormat, reference);
        }

        public string _headerFormat;

        public string HeaderValue(string reference)
        {
            return string.Format(CultureInfo.InvariantCulture, _headerFormat, reference);
        }

        public List<string> InterfaceImports { get; private set; }

        public List<string> ImplImports { get; private set; }

        public JavaPrimaryType IntanceType()
        {
            JavaPrimaryType instanceType = new JavaPrimaryType(this);
            if (Name == "boolean")
            {
                instanceType.Name = "Boolean";
            }
            else if (Name == "double")
            {
                instanceType.Name = "Double";
            }
            else if (Name == "int")
            {
                instanceType.Name = "Integer";
            }
            else if (Name == "long")
            {
                instanceType.Name = "Long";
            }
            else if (Name == "void")
            {
                instanceType.Name = "Void";
            }
            return instanceType;
        }

        private void Initialize(PrimaryType primaryType)
        {
            if (primaryType.Type == KnownPrimaryType.None)
            {
                Name = "void";
            }
            else if (primaryType.Type == KnownPrimaryType.Boolean)
            {
                Name = "boolean";
            }
            else if (primaryType.Type == KnownPrimaryType.ByteArray)
            {
                Name = "byte[]";
                _headerFormat = "Base64.encodeBase64String({0})";
            }
            else if (primaryType.Type == KnownPrimaryType.Date)
            {
                Name = "LocalDate";
                _commonImports.Add("org.joda.time.LocalDate");
            }
            else if (primaryType.Type == KnownPrimaryType.DateTime)
            {
                Name = "DateTime";
                _commonImports.Add("org.joda.time.DateTime");
            }
            else if (primaryType.Type == KnownPrimaryType.DateTimeRfc1123)
            {
                Name = "DateTimeRfc1123";
                _commonImports.Add("com.microsoft.rest.DateTimeRfc1123");
                _commonImports.Add("org.joda.time.DateTime");
            }
            else if (primaryType.Type == KnownPrimaryType.Double)
            {
                Name = "double";
            }
            else if (primaryType.Type == KnownPrimaryType.Decimal)
            {
                Name = "BigDecimal";
                _commonImports.Add("java.math.BigDecimal");
            }
            else if (primaryType.Type == KnownPrimaryType.Int)
            {
                Name = "int";
            }
            else if (primaryType.Type == KnownPrimaryType.Long)
            {
                Name = "long";
            }
            else if (primaryType.Type == KnownPrimaryType.Stream)
            {
                Name = "InputStream";
                _commonImports.Add("java.io.InputStream");
            }
            else if (primaryType.Type == KnownPrimaryType.String)
            {
                Name = "String";
            }
            else if (primaryType.Type == KnownPrimaryType.TimeSpan)
            {
                Name = "Period";
                _commonImports.Add("org.joda.time.Period");
            }
            else if (primaryType.Type == KnownPrimaryType.Uuid)
            {
                Name = "UUID";
                _commonImports.Add("java.util.UUID");
            }
            else if (primaryType.Type == KnownPrimaryType.Object)
            {
                Name = "Object";
            }
            else if (primaryType.Type == KnownPrimaryType.Credentials)
            {
                Name = "ServiceClientCredentials";
                _commonImports.Add("com.microsoft.rest.ServiceClientCredentials");
            }
        }
    }
}
