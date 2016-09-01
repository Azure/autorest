// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;

using AutoRest.Core;
using AutoRest.Core.Logging;
using AutoRest.Core.ClientModel;
using AutoRest.Go.Properties;

namespace AutoRest.Go
{
    public class GoCodeNamer : CodeNamer
    {
        public static readonly List<string> AutorestImports = new List<string> { "github.com/Azure/go-autorest/autorest" };
        public static readonly List<string> StandardImports = new List<string> { "github.com/Azure/go-autorest/autorest/azure", "net/http" };
        public static readonly List<string> PageableImports = new List<string> { "net/http", "github.com/Azure/go-autorest/autorest/to" };
        public static readonly List<string> ValidationImport = new List<string> { "github.com/Azure/go-autorest/autorest/validation" };

        // CommonInitialisms are those "words" within a name that Golint expects to be uppercase.
        // See https://github.com/golang/lint/blob/master/lint.go for detail.
        private static readonly List<String> CommonInitialisms = new List<String>() {
	                                                                        "Api",
	                                                                        "Ascii",
	                                                                        "Cpu",
	                                                                        "Css",
	                                                                        "Dns",
	                                                                        "Eof",
	                                                                        "Guid",
	                                                                        "Html",
	                                                                        "Http",
	                                                                        "Https",
	                                                                        "Id",
	                                                                        "Ip",
	                                                                        "Json",
	                                                                        "Lhs",
	                                                                        "Qps",
	                                                                        "Ram",
	                                                                        "Rhs",
	                                                                        "Rpc",
	                                                                        "Sla",
	                                                                        "Smtp",
	                                                                        "Sql",
	                                                                        "Ssh",
	                                                                        "Tcp",
	                                                                        "Tls",
	                                                                        "Ttl",
	                                                                        "Udp",
	                                                                        "Ui",
	                                                                        "Uid",
	                                                                        "Uuid",
	                                                                        "Uri",
	                                                                        "Url",
	                                                                        "Utf8",
	                                                                        "Vm",
	                                                                        "Xml",
	                                                                        "Xsrf",
	                                                                        "Xss",
                                                                        };

        private readonly Dictionary<IType, IType> _normalizedTypes;

        public static readonly Dictionary<HttpStatusCode, string> StatusCodeToGoString;

        static GoCodeNamer()
        {
            // Create a map from HttpStatusCode to the appropriate Go http.StatusXxxxx string.
            // -- Go does not have constants for the full HttpStatusCode enumeration; this set taken from http://golang.org/pkg/net/http/
            StatusCodeToGoString = new Dictionary<HttpStatusCode, string>();
            foreach (var sc in new HttpStatusCode[]{
                HttpStatusCode.Continue,
                HttpStatusCode.SwitchingProtocols,
                
                HttpStatusCode.OK,
                HttpStatusCode.Created,
                HttpStatusCode.Accepted,
                HttpStatusCode.NonAuthoritativeInformation,
                HttpStatusCode.NoContent,
                HttpStatusCode.ResetContent,
                HttpStatusCode.PartialContent,
                
                HttpStatusCode.MultipleChoices,
                HttpStatusCode.MovedPermanently,
                HttpStatusCode.Found,
                HttpStatusCode.SeeOther,
                HttpStatusCode.NotModified,
                HttpStatusCode.UseProxy,
                HttpStatusCode.TemporaryRedirect,
                
                HttpStatusCode.BadRequest,
                HttpStatusCode.Unauthorized,
                HttpStatusCode.PaymentRequired,
                HttpStatusCode.Forbidden,
                HttpStatusCode.NotFound,
                HttpStatusCode.MethodNotAllowed,
                HttpStatusCode.NotAcceptable,
                HttpStatusCode.ProxyAuthenticationRequired,
                HttpStatusCode.RequestTimeout,
                HttpStatusCode.Conflict,
                HttpStatusCode.Gone,
                HttpStatusCode.LengthRequired,
                HttpStatusCode.PreconditionFailed,
                HttpStatusCode.RequestEntityTooLarge,
                HttpStatusCode.RequestUriTooLong,
                HttpStatusCode.UnsupportedMediaType,
                HttpStatusCode.RequestedRangeNotSatisfiable,
                HttpStatusCode.ExpectationFailed,
                
                HttpStatusCode.InternalServerError,
                HttpStatusCode.NotImplemented,
                HttpStatusCode.BadGateway,
                HttpStatusCode.ServiceUnavailable,
                HttpStatusCode.GatewayTimeout,
                HttpStatusCode.HttpVersionNotSupported
            })
            {
                StatusCodeToGoString.Add(sc, string.Format("http.Status{0}", sc));
            }

            // Go names some constants slightly differently than the HttpStatusCode enumeration -- correct those
            StatusCodeToGoString[HttpStatusCode.Redirect] = "http.StatusFound";
            StatusCodeToGoString[HttpStatusCode.NonAuthoritativeInformation] = "http.StatusNonAuthoritativeInfo";
            StatusCodeToGoString[HttpStatusCode.ProxyAuthenticationRequired] = "http.StatusProxyAuthRequired";
            StatusCodeToGoString[HttpStatusCode.RequestUriTooLong] = "http.StatusRequestURITooLong";
            StatusCodeToGoString[HttpStatusCode.HttpVersionNotSupported] = "http.StatusHTTPVersionNotSupported";
        }

        /// <summary>
        /// Initializes a new instance of GoCodeNamingFramework.
        /// </summary>
        public GoCodeNamer()
        {
            new HashSet<string>
            {
                // Reserved keywords -- list retrieved from http://golang.org/ref/spec#Keywords
                "break",        "default",      "func",         "interface",    "select",
                "case",         "defer",        "go",           "map",          "struct",
                "chan",         "else",         "goto",         "package",      "switch",
                "const",        "fallthrough",  "if",           "range",        "type",
                "continue",     "for",          "import",       "return",       "var",        
                
                // Reserved predeclared identifiers -- list retrieved from http://golang.org/ref/spec#Predeclared_identifiers
                "bool", "byte",
                "complex64", "complex128",
                "error",
                "float32", "float64",
                "int", "int8", "int16", "int32", "int64",
                "rune", "string",
                "uint", "uint8", "uint16", "uint32", "uint64",
                "uintptr",

                "true", "false", "iota",
                
                "nil",

                "append", "cap", "close", "complex", "copy", "delete", "imag", "len", "make", "new", "panic", "print", "println", "real", "recover",


                // Reserved packages -- list retrieved from http://golang.org/pkg/
                // -- Since package names serve as partial identifiers, exclude the standard library
                "archive", "tar", "zip",
                "bufio",
                "builtin",
                "bytes",
                "compress", "bzip2", "flate", "gzip", "lzw", "zlib",
                "container", "heap", "list", "ring",
                "crypto", "aes", "cipher", "des", "dsa", "ecdsa", "elliptic", "hmac", "md5", "rand", "rc4", "rsa", "sha1", "sha256", "sha512", "subtle", "tls", "x509", "pkix",
                "database", "sql", "driver",
                "debug", "dwarf", "elf", "gosym", "macho", "pe", "plan9obj",
                "encoding", "ascii85", "asn1", "base32", "base64", "binary", "csv", "gob", "hex", "json", "pem", "xml",
                "errors",
                "expvar",
                "flag",
                "fmt",
                "go", "ast", "build", "constant", "doc", "format", "importer", "parser", "printer", "scanner", "token", "types",
                "hash", "adler32", "crc32", "crc64", "fnv",
                "html", "template",
                "image", "color", "palette", "draw", "gif", "jpeg", "png",
                "index", "suffixarray",
                "io", "ioutil",
                "log", "syslog",
                "math", "big", "cmplx", "rand",
                "mime", "multipart", "quotedprintable",
                "net", "http", "cgi", "cookiejar", "fcgi", "httptest", "httputil", "pprof", "mail", "rpc", "jsonrpc", "smtp", "textproto", "url",
                "os", "exec", "signal", "user",
                "path", "filepath",
                "reflect",
                "regexp", "syntax",
                "runtime", "cgo", "debug", "pprof", "race", "trace",
                "sort",
                "strconv",
                "strings",
                "sync", "atomic",
                "syscall",
                "testing", "iotest", "quick",
                "text", "scanner", "tabwriter", "template", "parse",
                "time",
                "unicode", "utf16", "utf8",
                "unsafe",

                // Other reserved names and packages (defined by the base libraries this code uses)
                "autorest", "client", "date", "err", "req", "resp", "result", "sender"

            }.ToList().ForEach(s => ReservedWords.Add(s));

            _normalizedTypes = new Dictionary<IType, IType>();
        }
        
        public string PackageName { get; private set; }

        public override void NormalizeClientModel(ServiceClient client)
        {
            PackageName = PackageNameFromNamespace(client.Namespace);

            base.NormalizeClientModel(client);

            List<SyntheticType> syntheticTypes = new List<SyntheticType>();

            // Trim the package name from exported types; append a suitable qualifier, if needed, to avoid conflicts.
            var exportedTypes = new HashSet<object>();
            exportedTypes.UnionWith(client.EnumTypes);
            exportedTypes.UnionWith(client.Methods);
            exportedTypes.UnionWith(client.ModelTypes);

            var stutteringTypes = exportedTypes
                                    .Where(exported =>
                                        (exported is IType && (exported as IType).Name.StartsWith(PackageName, StringComparison.InvariantCultureIgnoreCase)) ||
                                        (exported is Method && (exported as Method).Name.StartsWith(PackageName, StringComparison.InvariantCultureIgnoreCase)));

            if (stutteringTypes.Count() > 0)
            {
                Logger.LogWarning(string.Format(CultureInfo.InvariantCulture, Resources.NamesStutter, stutteringTypes.Count()));
                stutteringTypes
                    .ToList().ForEach(exported =>
                    {
                        var name = exported is IType
                                        ? (exported as IType).Name
                                        : (exported as Method).Name;

                        Logger.LogWarning(string.Format(CultureInfo.InvariantCulture, Resources.StutteringName, name));

                        name = name.TrimPackageName(PackageName);

                        var nameInUse = exportedTypes
                                            .Any(et => (et is IType && (et as IType).Name.Equals(name)) || (et is Method && (et as Method).Name.Equals(name)));
                        if (exported is EnumType)
                        {
                            (exported as EnumType).Name = nameInUse
                                                            ? name + "Enum"
                                                            : name;
                        }
                        else if (exported is CompositeType)
                        {
                            (exported as CompositeType).Name = nameInUse
                                                            ? name + "Type"
                                                            : name;
                        }
                        else if (exported is Method)
                        {
                            (exported as Method).Name = nameInUse
                                                            ? name + "Method"
                                                            : name;
                        }
                    });
            }

            foreach (var method in client.Methods)
            {
                var scope = new VariableScopeProvider();
                foreach (var parameter in method.Parameters)
                {
                    parameter.Name = scope.GetVariableName(parameter.Name);
                }

                if (SyntheticType.ShouldBeSyntheticType(method.ReturnType.Body))
                {
                    SyntheticType st = new SyntheticType(method.ReturnType.Body);
                    if (syntheticTypes.Contains(st))
                    {
                        method.ReturnType = new Response(syntheticTypes.Find(i => i.Equals(st)), method.ReturnType.Headers);
                    }
                    else
                    {
                        syntheticTypes.Add(st);
                        client.ModelTypes.Add(st);
                        method.ReturnType = new Response(st, method.ReturnType.Headers);
                    }
                }
            }
        }

        /// <summary>
        /// Returns language specific type reference name.
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public override IType NormalizeTypeReference(IType type)
        {
            if (type == null)
            {
                return null;
            }

            // Return the normalized type if previously normalized
            // go: Caching types is broken for Go and other generators since properties which contribute to the hash may change during normalization.
            // Note:
            //  Go needs to manufacture new types in some cases (e.g., MapTypes replace basic DictionaryTypes).
            //  Go cannot, as a result, handle self-referential types (e.g., a DictionaryType whose value type is the same dictionary type).
            //  Normalization methods for each type family will inject the proper values into the normalized type collection, if the type is
            //  present and the value is null, it means normalization is incomplete.
            IType normalizedType = null;
            if (_normalizedTypes.ContainsKey(type))
            {
                normalizedType = _normalizedTypes[type];
                if (normalizedType == null)
                {
                    throw new NotSupportedException(string.Format("Type {0} is recursively defined in a manner Go cannot handle", type.GetType()));
                }
                return normalizedType;
            }

            // Note the incoming type is undergoing normalization
            _normalizedTypes[type] = null;

            if (type is PrimaryType)
            {
                normalizedType = NormalizePrimaryType(type as PrimaryType);
            }
            if (type is SequenceType)
            {
                normalizedType = NormalizeSequenceType(type as SequenceType);
            }
            if (type is DictionaryType)
            {
                normalizedType = NormalizeDictionaryType(type as DictionaryType);
            }
            if (type is CompositeType)
            {
                normalizedType = NormalizeCompositeType(type as CompositeType);
            }
            if (type is EnumType)
            {
                normalizedType = NormalizeEnumType(type as EnumType);
            }
            if (normalizedType == null)
            {
                throw new NotSupportedException(string.Format("Type {0} is not supported.", type.GetType()));
            }

            // Remember the normalized type
            _normalizedTypes[type] = normalizedType;

            return normalizedType;
        }

        /// <summary>
        /// Returns language specific type declaration name.
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public override IType NormalizeTypeDeclaration(IType type)
        {
            return NormalizeTypeReference(type);
        }

        private IType NormalizeCompositeType(CompositeType compositeType)
        {
            // Composite types normalize to the same object
            _normalizedTypes[compositeType] = compositeType;

            compositeType.Name = GetTypeName(compositeType.Name);

            foreach (var property in compositeType.Properties)
            {
                property.SerializedName = property.Name;
                property.Name = GetPropertyName(property.Name);
                // gosdk: For now, inherit Enumerated type names from the composite type field name
                if (property.Type is EnumType)
                {
                    var enumType = property.Type as EnumType;
                    if (String.IsNullOrEmpty(enumType.Name))
                    {
                        enumType.Name = property.Name;
                    }
                }
                property.Type = NormalizeTypeReference(property.Type);
            }

            return compositeType;
        }

        private IType NormalizeEnumType(EnumType enumType)
        {
            // Enumerated types normalize to the same object
            _normalizedTypes[enumType] = enumType;

            // gosdk: Default unnamed Enumerated types to "string"
            if (String.IsNullOrEmpty(enumType.Name) || enumType.Values.Any(v => v == null || string.IsNullOrEmpty(v.Name)))
            {
                enumType.Name = "string";
                enumType.SerializedName = "string";
            }
            else
            {
                enumType.SerializedName = enumType.Name;
                enumType.Name = GetTypeName(enumType.Name);

                foreach (var value in enumType.Values)
                {
                    value.SerializedName = value.Name;
                    value.Name = GetEnumMemberName(value.Name);
                }
            }

            return enumType;
        }

        private IType NormalizePrimaryType(PrimaryType primaryType)
        {
            if (primaryType.Type == KnownPrimaryType.Object)
            {
                return new MapType(new InterfaceType());
            }
            else if (primaryType.Type == KnownPrimaryType.Date)
            {
                return new PackageType { Import = "github.com/Azure/go-autorest/autorest/date", Member = "Date" };
            }
            else if (primaryType.Type == KnownPrimaryType.DateTimeRfc1123)
            {
                return new PackageType { Import = "github.com/Azure/go-autorest/autorest/date", Member = "TimeRFC1123" };
            }
            else if (primaryType.Type == KnownPrimaryType.DateTime)
            {
                return new PackageType { Import = "github.com/Azure/go-autorest/autorest/date", Member = "Time" };
            }
            else if (primaryType.Type == KnownPrimaryType.Decimal)
            {
                return new PackageType { Import = "github.com/shopspring/decimal", Member = "Decimal" };
            }
            else if (primaryType.Type == KnownPrimaryType.Uuid)
            {
                return new PackageType {Import = "github.com/satori/uuid", Member = "UUID"};
            }
            else
            {
                // The remaining Primary types normalize to the same object
                _normalizedTypes[primaryType] = primaryType;

                if (primaryType.Type == KnownPrimaryType.Boolean)
                {
                    primaryType.Name = "bool";
                }
                else if (primaryType.Type == KnownPrimaryType.ByteArray)
                {
                    primaryType.Name = "[]byte";
                }
                else if (primaryType.Type == KnownPrimaryType.Double)
                {
                    primaryType.Name = "float64";
                }
                else if (primaryType.Type == KnownPrimaryType.Int)
                {
                    primaryType.Name = "int32";
                }
                else if (primaryType.Type == KnownPrimaryType.Long)
                {
                    primaryType.Name = "int64";
                }
                else if (primaryType.Type == KnownPrimaryType.Stream)
                {
                    // Note:
                    // -- All streaming will be through instances of an io.ReadCloser
                    // -- When streaming to the server, the method will take an io.ReadCloser as the http.Request body
                    // -- When streaming from the servier, the method will return access to the (open) http.Response body
                    primaryType.Name = "io.ReadCloser";
                }
                else if (primaryType.Type == KnownPrimaryType.String)
                {
                    primaryType.Name = "string";
                }
                else if (primaryType.Type == KnownPrimaryType.TimeSpan)
                {
                    primaryType.Name = "string";
                }
                else if (primaryType.Type == KnownPrimaryType.Base64Url)
                {
                    //TODO: add base64Url type.
                    primaryType.Name = "string";
                }
                else if (primaryType.Type == KnownPrimaryType.UnixTime)
                {
                    //TODO: add unixtime type.
                    primaryType.Name = "string";
                }
                else
                {
                    throw new ArgumentException("Illegal primary type for Go: " + primaryType.ToString());
                }

                return primaryType;
            }
        }

        private IType NormalizeSequenceType(SequenceType sequenceType)
        {
            // Sequence types normalize to the same object
            _normalizedTypes[sequenceType] = sequenceType;
            
            sequenceType.ElementType = NormalizeTypeReference(sequenceType.ElementType);
            sequenceType.NameFormat = "[]{0}";
            return sequenceType;
        }

        private IType NormalizeDictionaryType(DictionaryType dictionaryType)
        {
            return new MapType(NormalizeTypeReference(dictionaryType.ValueType));
        }

        public override string GetEnumMemberName(string name)
        {
            return EnsureNameCase(base.GetEnumMemberName(name));
        }

        public override string GetFieldName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return EnsureNameCase(PascalCase(RemoveInvalidCharacters(GetEscapedReservedName(name, "Field"))));
        }

        public override string GetInterfaceName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return EnsureNameCase(PascalCase(RemoveInvalidCharacters(name)));
        }

        /// <summary>
        /// Formats a string for naming a method using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public override string GetMethodName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return EnsureNameCase(GetEscapedReservedName(PascalCase(RemoveInvalidCharacters(name)), "Method"));
        }
        
        public override string GetMethodGroupName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return EnsureNameCase(PascalCase(RemoveInvalidCharacters(GetEscapedReservedName(name, "Group"))).TrimPackageName(PackageName));
        }

        /// <summary>
        /// Formats a string for naming method parameters using GetVariableName Camel case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public override string GetParameterName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return EnsureNameCase(GetEscapedReservedName(CamelCase(RemoveInvalidCharacters(name)), "Parameter"));
        }

        /// <summary>
        /// Formats a string for naming properties using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public override string GetPropertyName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return EnsureNameCase(GetEscapedReservedName(PascalCase(RemoveInvalidCharacters(name)), "Property"));
        }

        /// <summary>
        /// Formats a string for naming a Type or Object using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public override string GetTypeName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return EnsureNameCase(GetEscapedReservedName(PascalCase(RemoveInvalidCharacters(name)), "Type"));
        }

        /// <summary>
        /// Formats a string for naming a local variable using Camel case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public override string GetVariableName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return EnsureNameCase(GetEscapedReservedName(CamelCase(RemoveInvalidCharacters(name)), "Var"));
        }

        /// <summary>
        /// Converts names the conflict with Go reserved terms by appending the passed appendValue.
        /// </summary>
        /// <param name="name">Name.</param>
        /// <param name="appendValue">String to append.</param>
        /// <returns>The transformed reserved name</returns>
        protected override string GetEscapedReservedName(string name, string appendValue)
        {
            if (name == null)
            {
                throw new ArgumentNullException("name");
            }

            if (appendValue == null)
            {
                throw new ArgumentNullException("appendValue");
            }

            // Use case-sensitive comparisons to reduce generated names
            if (ReservedWords.Contains(name, StringComparer.Ordinal))
            {
                name += appendValue;
            }

            return name;
        }

        public void ReserveNamespace(string ns)
        {
            ReservedWords.Add(PackageNameFromNamespace(ns));
        }

        // EnsureNameCase ensures that all "words" in the passed name adhere to Golint casing expectations.
        // A "word" is a sequence of characters separated by a change in case or underscores. Since this
        // method alters name casing, it should be used after any other method that expects normal
        // camelCase or PascalCase.
        private static string EnsureNameCase(string name)
        {
            List<string> words = new List<string>();
            new List<string>(name.ToWords())
                .ForEach(s =>
                {
                    if (CommonInitialisms.Contains(s))
                    {
                        words.Add(s.ToUpper());
                    }
                    else
                    {
                        words.Add(s);
                    }
                });
            return String.Join(String.Empty, words.ToArray());
        }

        public static string FormatFileName(string fileName)
        {
            return FormatFileName(String.Empty, fileName);
        }

        public static string FormatFileName(string path, string fileName)
        {
            return path + fileName + ".go";
        }

        public static string FormatImportName(string baseImport, string basePackage, params string[] packages)
        {
            List<string> items = new List<string> { baseImport, basePackage };
            packages.ToList().ForEach(p => items.Add(FormatPackageName(p)));
            return String.Join("/", items.ToArray<string>());
        }
    
        public static string FormatPackageName(string packageName)
        {
            if (string.IsNullOrWhiteSpace(packageName))
            {
                return packageName;
            }
            return RemoveInvalidCharacters(packageName).ToLowerInvariant();
        }

        public static List<string> NamespaceParts(string ns)
        {
            // -- The namespace is assumed to be the full-path under go/src (e.g., github.com/azure/azure-sdk-for-go/arm/storage)
            // -- Ensure the namespace uses a Go-style (aka Unix) path
            return new List<string>(ns.Replace('\\', '/').Split('/'));
        }

        public static string PackageNameFromNamespace(string ns)
        {
            List<string> namespaceParts = NamespaceParts(ns);
            return namespaceParts[namespaceParts.Count() - 1];
        }

        public override string EscapeDefaultValue(string defaultValue, IType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }
            PrimaryType primaryType = type as PrimaryType;
            if (defaultValue != null)
            {
                if (type is CompositeType)
                {
                    return type.Name + "{}";
                }
                else if (primaryType != null)
                {
                    if (primaryType.Type == KnownPrimaryType.String  
                        || primaryType.Type == KnownPrimaryType.Uuid
                        || primaryType.Type == KnownPrimaryType.TimeSpan)
                    {
                        return CodeNamer.QuoteValue(defaultValue);
                    }
                    else if (primaryType.Type == KnownPrimaryType.Boolean)
                    {
                        return defaultValue.ToLowerInvariant();
                    }
                    else if (primaryType.Type == KnownPrimaryType.ByteArray)
                    {
                        return "[]bytearray(\"" + defaultValue + "\")";
                    }
                    else
                    {
                       //TODO: handle imports for package types.
                    }
                }
            }
            return defaultValue;
        }
    }
}