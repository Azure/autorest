using System;
using System.Collections.Generic;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;

namespace AutoRest.Java.Model
{
    public class PrimaryTypeJv : PrimaryType, IModelTypeJv
    {
        private List<string> _imports;
        
        public PrimaryTypeJv(KnownPrimaryType type)
            : base(type)
        {
            _imports = new List<string>();
            Initialize(type);
        }

        public override string DefaultValue
        {
            get
            {
                if (Name == "byte[]")
                {
                    return "new byte[0]";
                }
                else if (Name == "Byte[]")
                {
                    return "new Byte[0]";
                }
                //else if (Name == "RequestBody")
                //{
                //    return "RequestBody.create(MediaType.parse(\"" + base.method.RequestContentType + "\"), new byte[0])";
                //}
                else if (IsInstanceType)
                // instance type
                {
                    return "null";
                }
                else
                {
                    throw new NotSupportedException(this.Name + " does not have default value!");
                }
            }
        }

        public IModelTypeJv ParameterVariant
        {
            get
            {
                if (KnownPrimaryType == KnownPrimaryType.DateTimeRfc1123)
                {
                    return new PrimaryTypeJv(KnownPrimaryType.DateTime);
                }
                else if (KnownPrimaryType == KnownPrimaryType.UnixTime)
                {
                    return new PrimaryTypeJv(KnownPrimaryType.DateTime);
                }
                else if (KnownPrimaryType == KnownPrimaryType.Base64Url)
                {
                    return new PrimaryTypeJv(KnownPrimaryType.ByteArray);
                }
                else if (KnownPrimaryType == KnownPrimaryType.Stream)
                {
                    return new PrimaryTypeJv(KnownPrimaryType.ByteArray);
                }
                else
                {
                    return this;
                }
            }
        }

        public IModelTypeJv ResponseVariant
        {
            get
            {
                if (KnownPrimaryType == KnownPrimaryType.DateTimeRfc1123)
                {
                    return new PrimaryTypeJv(KnownPrimaryType.DateTime);
                }
                else if (KnownPrimaryType == KnownPrimaryType.UnixTime)
                {
                    return new PrimaryTypeJv(KnownPrimaryType.DateTime);
                }
                else if (KnownPrimaryType == KnownPrimaryType.Base64Url)
                {
                    return new PrimaryTypeJv(KnownPrimaryType.ByteArray);
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
                return this.Name.ToString()[0] >= 'A' && this.Name.ToString()[0] <= 'Z';
            }
        }

        public IModelTypeJv InstanceType()
        {
            if (this.IsInstanceType)
            {
                return this;
            }

            var instanceType = new PrimaryTypeJv(this.KnownPrimaryType);
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

        private void Initialize(KnownPrimaryType primaryType)
        {
            if (primaryType == KnownPrimaryType.None)
            {
                Name = "void";
            }
            else if (primaryType == KnownPrimaryType.Base64Url)
            {
                Name = "Base64Url";
                _imports.Add("com.microsoft.rest.Base64Url");
            }
            else if (primaryType == KnownPrimaryType.Boolean)
            {
                Name = "boolean";
            }
            else if (primaryType == KnownPrimaryType.ByteArray)
            {
                Name = "byte[]";
            }
            else if (primaryType == KnownPrimaryType.Date)
            {
                Name = "LocalDate";
                _imports.Add("org.joda.time.LocalDate");
            }
            else if (primaryType == KnownPrimaryType.DateTime)
            {
                Name = "DateTime";
                _imports.Add("org.joda.time.DateTime");
            }
            else if (primaryType == KnownPrimaryType.DateTimeRfc1123)
            {
                Name = "DateTimeRfc1123";
                _imports.Add("com.microsoft.rest.DateTimeRfc1123");
            }
            else if (primaryType == KnownPrimaryType.Double)
            {
                Name = "double";
            }
            else if (primaryType == KnownPrimaryType.Decimal)
            {
                Name = "BigDecimal";
                _imports.Add("java.math.BigDecimal");
            }
            else if (primaryType == KnownPrimaryType.Int)
            {
                Name = "int";
            }
            else if (primaryType == KnownPrimaryType.Long)
            {
                Name = "long";
            }
            else if (primaryType == KnownPrimaryType.Stream)
            {
                Name = "InputStream";
                _imports.Add("java.io.InputStream");
            }
            else if (primaryType == KnownPrimaryType.String)
            {
                Name = "String";
            }
            else if (primaryType == KnownPrimaryType.TimeSpan)
            {
                Name = "Period";
                _imports.Add("org.joda.time.Period");
            }
            else if (primaryType == KnownPrimaryType.UnixTime)
            {
                Name = "long";
                _imports.Add("org.joda.time.DateTime");
                _imports.Add("org.joda.time.DateTimeZone");
            }
            else if (primaryType == KnownPrimaryType.Uuid)
            {
                Name = "UUID";
                _imports.Add("java.util.UUID");
            }
            else if (primaryType == KnownPrimaryType.Object)
            {
                Name = "Object";
            }
            else if (primaryType == KnownPrimaryType.Credentials)
            {
                Name = "ServiceClientCredentials";
                _imports.Add("com.microsoft.rest.ServiceClientCredentials");
            }
        }
    }
}
