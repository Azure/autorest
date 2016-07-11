using System;
using System.Collections.Generic;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Java.TypeModels
{
    public class PrimaryTypeModel : PrimaryType, ITypeModel
    {
        private List<string> _imports;
        
        public PrimaryTypeModel(KnownPrimaryType knownPrimaryType)
            : this (new PrimaryType(knownPrimaryType))
        {
        }

        public PrimaryTypeModel(PrimaryType primaryType)
            : base (primaryType != null ? primaryType.Type : KnownPrimaryType.None)
        {
            if (primaryType == null)
            {
                throw new ArgumentNullException("primaryType");
            }

            this.LoadFrom(primaryType);
            _imports = new List<string>();
            Initialize(primaryType);
        }

        public string DefaultValue(Method method)
        {
            if (this.Name == "byte[]")
            {
                return "new byte[0]";
            }
            else if (this.Name == "Byte[]")
            {
                return "new Byte[0]";
            }
            else if (this.Name == "RequestBody")
            {
                return "RequestBody.create(MediaType.parse(\"" + method.RequestContentType + "\"), new byte[0])";
            }
            else if (this.IsInstanceType)
            // instance type
            {
                return "null";
            }
            else
            {
                throw new NotSupportedException(this.Name + " does not have default value!");
            }
        }

        public ITypeModel ParameterVariant
        {
            get
            {
                if (Type == KnownPrimaryType.DateTimeRfc1123)
                {
                    return new PrimaryTypeModel(KnownPrimaryType.DateTime);
                }
                else if (Type == KnownPrimaryType.UnixTime)
                {
                    return new PrimaryTypeModel(KnownPrimaryType.DateTime);
                }
                else if (Type == KnownPrimaryType.Base64Url)
                {
                    return new PrimaryTypeModel(KnownPrimaryType.ByteArray);
                }
                else if (Type == KnownPrimaryType.Stream)
                {
                    return new PrimaryTypeModel(KnownPrimaryType.ByteArray);
                }
                else
                {
                    return this;
                }
            }
        }

        public ITypeModel ResponseVariant
        {
            get
            {
                if (Type == KnownPrimaryType.DateTimeRfc1123)
                {
                    return new PrimaryTypeModel(KnownPrimaryType.DateTime);
                }
                else if (Type == KnownPrimaryType.UnixTime)
                {
                    return new PrimaryTypeModel(KnownPrimaryType.DateTime);
                }
                else if (Type == KnownPrimaryType.Base64Url)
                {
                    return new PrimaryTypeModel(KnownPrimaryType.ByteArray);
                }
                else
                {
                    return this;
                }
            }
        }

        public IEnumerable<string> Imports
        {
            get
            {
                return _imports;
            }
        }

        private bool IsInstanceType
        {
            get
            {
                return this.Name[0] >= 'A' && this.Name[0] <= 'Z';
            }
        }

        public ITypeModel InstanceType()
        {
            if (this.IsInstanceType)
            {
                return this;
            }

            PrimaryTypeModel instanceType = new PrimaryTypeModel(this);
            if (instanceType.Name == "boolean")
            {
                instanceType.Name = "Boolean";
            }
            else if (instanceType.Name == "double")
            {
                instanceType.Name = "Double";
            }
            else if (instanceType.Name == "int")
            {
                instanceType.Name = "Integer";
            }
            else if (instanceType.Name == "long")
            {
                instanceType.Name = "Long";
            }
            else if (instanceType.Name == "void")
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
            else if (primaryType.Type == KnownPrimaryType.Base64Url)
            {
                Name = "Base64Url";
                _imports.Add("com.microsoft.rest.Base64Url");
            }
            else if (primaryType.Type == KnownPrimaryType.Boolean)
            {
                Name = "boolean";
            }
            else if (primaryType.Type == KnownPrimaryType.ByteArray)
            {
                Name = "byte[]";
            }
            else if (primaryType.Type == KnownPrimaryType.Date)
            {
                Name = "LocalDate";
                _imports.Add("org.joda.time.LocalDate");
            }
            else if (primaryType.Type == KnownPrimaryType.DateTime)
            {
                Name = "DateTime";
                _imports.Add("org.joda.time.DateTime");
            }
            else if (primaryType.Type == KnownPrimaryType.DateTimeRfc1123)
            {
                Name = "DateTimeRfc1123";
                _imports.Add("com.microsoft.rest.DateTimeRfc1123");
            }
            else if (primaryType.Type == KnownPrimaryType.Double)
            {
                Name = "double";
            }
            else if (primaryType.Type == KnownPrimaryType.Decimal)
            {
                Name = "BigDecimal";
                _imports.Add("java.math.BigDecimal");
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
                _imports.Add("java.io.InputStream");
            }
            else if (primaryType.Type == KnownPrimaryType.String)
            {
                Name = "String";
            }
            else if (primaryType.Type == KnownPrimaryType.TimeSpan)
            {
                Name = "Period";
                _imports.Add("org.joda.time.Period");
            }
            else if (primaryType.Type == KnownPrimaryType.UnixTime)
            {
                Name = "long";
                _imports.Add("org.joda.time.DateTime");
                _imports.Add("org.joda.time.DateTimeZone");
            }
            else if (primaryType.Type == KnownPrimaryType.Uuid)
            {
                Name = "UUID";
                _imports.Add("java.util.UUID");
            }
            else if (primaryType.Type == KnownPrimaryType.Object)
            {
                Name = "Object";
            }
            else if (primaryType.Type == KnownPrimaryType.Credentials)
            {
                Name = "ServiceClientCredentials";
                _imports.Add("com.microsoft.rest.ServiceClientCredentials");
            }
        }
    }
}
