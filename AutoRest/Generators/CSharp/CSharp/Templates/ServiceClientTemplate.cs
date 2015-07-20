// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Templates
{
#line 1 "ServiceClientTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 2 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp

#line default
#line hidden
    ;
#line 3 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Templates

#line default
#line hidden
    ;
#line 4 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
#line 5 "ServiceClientTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServiceClientTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.CSharp.ServiceClientTemplateModel>
    {
        #line hidden
        public ServiceClientTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 7 "ServiceClientTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 8 "ServiceClientTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral(@"
{
    using System;
    using System.Collections.Generic;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Newtonsoft.Json;
");
#line 22 "ServiceClientTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 23 "ServiceClientTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 24 "ServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 25 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    ");
#line 27 "ServiceClientTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n    public partial class ");
#line 29 "ServiceClientTemplate.cshtml"
                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" : ServiceClient<");
#line 29 "ServiceClientTemplate.cshtml"
                                                Write(Model.Name);

#line default
#line hidden
            WriteLiteral(">, I");
#line 29 "ServiceClientTemplate.cshtml"
                                                                Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n        /// <summary>\r\n        /// The base URI of the service.\r\n       " +
" /// </summary>\r\n        public Uri BaseUri { get; set; }\r\n        ");
#line 35 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Gets or sets json serialization settings.\r" +
"\n        /// </summary>\r\n        public JsonSerializerSettings SerializationSett" +
"ings { get; private set; }\r\n        ");
#line 41 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Gets or sets json deserialization settings" +
".\r\n        /// </summary>\r\n        public JsonSerializerSettings Deserialization" +
"Settings { get; private set; }        \r\n        ");
#line 47 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        \r\n");
#line 49 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 49 "ServiceClientTemplate.cshtml"
         foreach (var property in Model.Properties)
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 52 "ServiceClientTemplate.cshtml"
     Write(WrapComment("/// ", property.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n        public ");
#line 54 "ServiceClientTemplate.cshtml"
            Write(property.Type);

#line default
#line hidden
            WriteLiteral(" ");
#line 54 "ServiceClientTemplate.cshtml"
                           Write(property.Name);

#line default
#line hidden
            WriteLiteral(" { get; ");
#line 54 "ServiceClientTemplate.cshtml"
                                                  Write(property.IsReadOnly ? "private " : "");

#line default
#line hidden
            WriteLiteral("set; }\r\n");
#line 55 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 55 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 55 "ServiceClientTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 58 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 58 "ServiceClientTemplate.cshtml"
         foreach (var operation in Model.Operations) 
        {

#line default
#line hidden

            WriteLiteral("        public virtual I");
#line 60 "ServiceClientTemplate.cshtml"
                      Write(operation.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" ");
#line 60 "ServiceClientTemplate.cshtml"
                                                   Write(operation.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" { get; private set; }\r\n");
#line 61 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 61 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 61 "ServiceClientTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 65 "ServiceClientTemplate.cshtml"
                                         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        public ");
#line 67 "ServiceClientTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral("() : base()\r\n        {\r\n            this.Initialize();\r\n        }\r\n        ");
#line 71 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 73 "ServiceClientTemplate.cshtml"
                                         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        /// <param name=\'handlers\'>\r\n        ///" +
" Optional. The delegating handlers to add to the http client pipeline.\r\n        " +
"/// </param>\r\n        public ");
#line 78 "ServiceClientTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(params DelegatingHandler[] handlers) : base(handlers)\r\n        {\r\n            th" +
"is.Initialize();\r\n        }\r\n        ");
#line 82 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 85 "ServiceClientTemplate.cshtml"
                                         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(@" class.
        /// </summary>
        /// <param name='rootHandler'>
        /// Optional. The http client handler used to handle http transport.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        public ");
#line 93 "ServiceClientTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(HttpClientHandler rootHandler, params DelegatingHandler[] handlers) : base(rootH" +
"andler, handlers)\r\n        {\r\n            this.Initialize();\r\n        }\r\n       " +
" ");
#line 97 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 100 "ServiceClientTemplate.cshtml"
                                         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(@" class.
        /// </summary>
        /// <param name='baseUri'>
        /// Optional. The base URI of the service.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        public ");
#line 108 "ServiceClientTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral(@"(Uri baseUri, params DelegatingHandler[] handlers) : this(handlers)
        {
            if (baseUri == null)
            {
                throw new ArgumentNullException(""baseUri"");
            }
            this.Initialize();
            this.BaseUri = baseUri;
        }
        ");
#line 117 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 119 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 119 "ServiceClientTemplate.cshtml"
          var parameters = Model.Properties.Where(p => p.IsRequired && p.IsReadOnly);

#line default
#line hidden

            WriteLiteral("\r\n");
#line 120 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 120 "ServiceClientTemplate.cshtml"
         if (parameters.Any())
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 123 "ServiceClientTemplate.cshtml"
                                           Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n");
#line 125 "ServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 127 "ServiceClientTemplate.cshtml"
                       Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\'>\r\n        /// Required. ");
#line 128 "ServiceClientTemplate.cshtml"
                    Write(param.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n        /// </param>\r\n");
#line 130 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'handlers\'>\r\n        /// Optional. The delegating handler" +
"s to add to the http client pipeline.\r\n        /// </param>\r\n        public ");
#line 134 "ServiceClientTemplate.cshtml"
             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 134 "ServiceClientTemplate.cshtml"
                           Write(Model.RequiredConstructorParameters);

#line default
#line hidden
            WriteLiteral(", params DelegatingHandler[] handlers) : this(handlers)\r\n        {\r\n");
#line 136 "ServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("            if (");
#line 138 "ServiceClientTemplate.cshtml"
              Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(" == null)\r\n            {\r\n                throw new ArgumentNullException(\"");
#line 140 "ServiceClientTemplate.cshtml"
                                               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\");\r\n            }\r\n");
#line 142 "ServiceClientTemplate.cshtml"
        }
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 145 "ServiceClientTemplate.cshtml"
               Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 145 "ServiceClientTemplate.cshtml"
                               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 146 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("            this.Initialize();\r\n        }\r\n        ");
#line 149 "ServiceClientTemplate.cshtml"
     Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 150 "ServiceClientTemplate.cshtml"


#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 152 "ServiceClientTemplate.cshtml"
                                           Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        /// <param name=\'baseUri\'>\r\n        /// " +
"Optional. The base URI of the service.\r\n        /// </param>\r\n");
#line 157 "ServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 159 "ServiceClientTemplate.cshtml"
                       Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\'>\r\n        /// Required. ");
#line 160 "ServiceClientTemplate.cshtml"
                    Write(param.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n        /// </param>\r\n");
#line 162 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'handlers\'>\r\n        /// Optional. The delegating handler" +
"s to add to the http client pipeline.\r\n        /// </param>\r\n        public ");
#line 166 "ServiceClientTemplate.cshtml"
             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(Uri baseUri, ");
#line 166 "ServiceClientTemplate.cshtml"
                                        Write(Model.RequiredConstructorParameters);

#line default
#line hidden
            WriteLiteral(", params DelegatingHandler[] handlers) : this(handlers)\r\n        {\r\n            i" +
"f (baseUri == null)\r\n            {\r\n                throw new ArgumentNullExcept" +
"ion(\"baseUri\");\r\n            }\r\n");
#line 172 "ServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("            if (");
#line 174 "ServiceClientTemplate.cshtml"
              Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(" == null)\r\n            {\r\n                throw new ArgumentNullException(\"");
#line 176 "ServiceClientTemplate.cshtml"
                                               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\");\r\n            }\r\n");
#line 178 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("            this.BaseUri = baseUri;\r\n");
#line 180 "ServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 182 "ServiceClientTemplate.cshtml"
               Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 182 "ServiceClientTemplate.cshtml"
                               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 183 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        }\r\n        ");
#line 185 "ServiceClientTemplate.cshtml"
     Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 186 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    \r\n        /// <summary>\r\n        /// Initializes client properties.\r\n        " +
"/// </summary>\r\n        private void Initialize()\r\n        {\r\n");
#line 193 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 193 "ServiceClientTemplate.cshtml"
         foreach (var operation in Model.Operations) 
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 195 "ServiceClientTemplate.cshtml"
               Write(operation.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" = new ");
#line 195 "ServiceClientTemplate.cshtml"
                                                  Write(operation.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(this);\r\n");
#line 196 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("            this.BaseUri = new Uri(\"");
#line 197 "ServiceClientTemplate.cshtml"
                               Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\");\r\n");
#line 198 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 198 "ServiceClientTemplate.cshtml"
         foreach (var property in Model.Properties.Where(p => p.DefaultValue != null))
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 200 "ServiceClientTemplate.cshtml"
               Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 200 "ServiceClientTemplate.cshtml"
                                  Write(property.DefaultValue);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 201 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 203 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 203 "ServiceClientTemplate.cshtml"
         if (Model.Properties.Any(p => "Credentials".Equals(p.Name, StringComparison.OrdinalIgnoreCase) &&
            "ServiceClientCredentials".Equals(p.Type.Name, StringComparison.OrdinalIgnoreCase)))
        {

#line default
#line hidden

            WriteLiteral("            if (this.Credentials != null) \r\n            {\r\n                this.C" +
"redentials.InitializeServiceClient(this);\r\n            }\r\n");
#line 210 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral(@"            SerializationSettings = new JsonSerializerSettings
            {
                Formatting = Formatting.Indented,
                DateFormatHandling = DateFormatHandling.IsoDateFormat,
                DateTimeZoneHandling = DateTimeZoneHandling.Utc,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
            DeserializationSettings = new JsonSerializerSettings{
                DateFormatHandling = DateFormatHandling.IsoDateFormat,
                DateTimeZoneHandling = DateTimeZoneHandling.Utc,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
");
#line 227 "ServiceClientTemplate.cshtml"
            

#line default
#line hidden

#line 227 "ServiceClientTemplate.cshtml"
             foreach (var polymorphicType in Model.ModelTypes.Where(t => t.PolymorphicDiscriminator != null))
            {

#line default
#line hidden

            WriteLiteral("            SerializationSettings.Converters.Add(new PolymorphicSerializeJsonConv" +
"erter<");
#line 229 "ServiceClientTemplate.cshtml"
                                                                                     Write(polymorphicType.Name);

#line default
#line hidden
            WriteLiteral(">(\"");
#line 229 "ServiceClientTemplate.cshtml"
                                                                                                               Write(polymorphicType.PolymorphicDiscriminator);

#line default
#line hidden
            WriteLiteral("\"));\r\n            DeserializationSettings.Converters.Add(new PolymorphicDeseriali" +
"zeJsonConverter<");
#line 230 "ServiceClientTemplate.cshtml"
                                                                                         Write(polymorphicType.Name);

#line default
#line hidden
            WriteLiteral(">(\"");
#line 230 "ServiceClientTemplate.cshtml"
                                                                                                                   Write(polymorphicType.PolymorphicDiscriminator);

#line default
#line hidden
            WriteLiteral("\"));\r\n");
#line 231 "ServiceClientTemplate.cshtml"
            } 

#line default
#line hidden

            WriteLiteral("        }    \r\n    \r\n");
#line 234 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 234 "ServiceClientTemplate.cshtml"
         foreach (var method in Model.MethodTemplateModels)
        {

#line default
#line hidden

            WriteLiteral("        ");
#line 236 "ServiceClientTemplate.cshtml"
      Write(Include(new MethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 237 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 237 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 237 "ServiceClientTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 239 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
