// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Azure.Templates
{
#line 1 "AzureServiceClientTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 2 "AzureServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp

#line default
#line hidden
    ;
#line 3 "AzureServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Templates

#line default
#line hidden
    ;
#line 4 "AzureServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Azure

#line default
#line hidden
    ;
#line 5 "AzureServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Azure.Templates

#line default
#line hidden
    ;
#line 6 "AzureServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
#line 7 "AzureServiceClientTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class AzureServiceClientTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.CSharp.Azure.AzureServiceClientTemplateModel>
    {
        #line hidden
        public AzureServiceClientTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 9 "AzureServiceClientTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 10 "AzureServiceClientTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral(@"
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
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
#line 25 "AzureServiceClientTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 26 "AzureServiceClientTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 27 "AzureServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 28 "AzureServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    ");
#line 30 "AzureServiceClientTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n    public partial class ");
#line 32 "AzureServiceClientTemplate.cshtml"
                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" : ServiceClient<");
#line 32 "AzureServiceClientTemplate.cshtml"
                                                Write(Model.Name);

#line default
#line hidden
            WriteLiteral(">, I");
#line 32 "AzureServiceClientTemplate.cshtml"
                                                                Write(Model.Name);

#line default
#line hidden
            WriteLiteral(", IAzureClient\r\n    {\r\n        /// <summary>\r\n        /// The base URI of the ser" +
"vice.\r\n        /// </summary>\r\n        public Uri BaseUri { get; set; }\r\n       " +
" ");
#line 38 "AzureServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Gets or sets json serialization settings.\r" +
"\n        /// </summary>\r\n        public JsonSerializerSettings SerializationSett" +
"ings { get; private set; }\r\n        ");
#line 44 "AzureServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Gets or sets json deserialization settings" +
".\r\n        /// </summary>\r\n        public JsonSerializerSettings Deserialization" +
"Settings { get; private set; }        \r\n        ");
#line 50 "AzureServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        \r\n");
#line 52 "AzureServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 52 "AzureServiceClientTemplate.cshtml"
         foreach (var property in Model.Properties)
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 55 "AzureServiceClientTemplate.cshtml"
     Write(WrapComment("/// ", property.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n        public ");
#line 57 "AzureServiceClientTemplate.cshtml"
            Write(property.Type);

#line default
#line hidden
            WriteLiteral(" ");
#line 57 "AzureServiceClientTemplate.cshtml"
                           Write(property.Name);

#line default
#line hidden
            WriteLiteral(" { get; ");
#line 57 "AzureServiceClientTemplate.cshtml"
                                                  Write(property.IsReadOnly ? "private " : "");

#line default
#line hidden
            WriteLiteral("set; }\r\n");
#line 58 "AzureServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 58 "AzureServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 58 "AzureServiceClientTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 61 "AzureServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 61 "AzureServiceClientTemplate.cshtml"
         foreach (var operation in Model.Operations) 
        {

#line default
#line hidden

            WriteLiteral("        public virtual I");
#line 63 "AzureServiceClientTemplate.cshtml"
                      Write(operation.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" ");
#line 63 "AzureServiceClientTemplate.cshtml"
                                                   Write(operation.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" { get; private set; }\r\n");
#line 64 "AzureServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 64 "AzureServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 64 "AzureServiceClientTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 68 "AzureServiceClientTemplate.cshtml"
                                         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        public ");
#line 70 "AzureServiceClientTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral("() : base()\r\n        {\r\n            this.Initialize();\r\n        }\r\n        ");
#line 74 "AzureServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 76 "AzureServiceClientTemplate.cshtml"
                                         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        /// <param name=\'handlers\'>\r\n        ///" +
" Optional. The set of delegating handlers to insert in the http\r\n        /// cli" +
"ent pipeline.\r\n        /// </param>\r\n        public ");
#line 82 "AzureServiceClientTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(params DelegatingHandler[] handlers) : base(handlers)\r\n        {\r\n            th" +
"is.Initialize();\r\n        }\r\n        ");
#line 86 "AzureServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 89 "AzureServiceClientTemplate.cshtml"
                                         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(@" class.
        /// </summary>
        /// <param name='rootHandler'>
        /// Optional. The http client handler used to handle http transport.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The set of delegating handlers to insert in the http
        /// client pipeline.
        /// </param>
        public ");
#line 98 "AzureServiceClientTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(HttpClientHandler rootHandler, params DelegatingHandler[] handlers) : base(rootH" +
"andler, handlers)\r\n        {\r\n            this.Initialize();\r\n        }\r\n       " +
" ");
#line 102 "AzureServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 105 "AzureServiceClientTemplate.cshtml"
                                         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(@" class.
        /// </summary>
        /// <param name='baseUri'>
        /// Optional. The base URI of the service.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The set of delegating handlers to insert in the http
        /// client pipeline.
        /// </param>
        public ");
#line 114 "AzureServiceClientTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral(@"(Uri baseUri, params DelegatingHandler[] handlers) : this(handlers)
        {
            if (baseUri == null)
            {
                throw new ArgumentNullException(""baseUri"");
            }
            this.BaseUri = baseUri;
        }
        ");
#line 122 "AzureServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 124 "AzureServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 124 "AzureServiceClientTemplate.cshtml"
          var parameters = Model.Properties.Where(p => p.IsRequired && p.IsReadOnly);

#line default
#line hidden

            WriteLiteral("\r\n");
#line 125 "AzureServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 125 "AzureServiceClientTemplate.cshtml"
         if (parameters.Any())
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 128 "AzureServiceClientTemplate.cshtml"
                                           Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n");
#line 130 "AzureServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 132 "AzureServiceClientTemplate.cshtml"
                       Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\'>\r\n        /// Required. ");
#line 133 "AzureServiceClientTemplate.cshtml"
                    Write(param.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n        /// </param>\r\n");
#line 135 "AzureServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'handlers\'>\r\n        /// Optional. The set of delegating " +
"handlers to insert in the http\r\n        /// client pipeline.\r\n        /// </para" +
"m>\r\n        public ");
#line 140 "AzureServiceClientTemplate.cshtml"
             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 140 "AzureServiceClientTemplate.cshtml"
                           Write(Model.RequiredConstructorParameters);

#line default
#line hidden
            WriteLiteral(", params DelegatingHandler[] handlers) : this(handlers)\r\n        {\r\n");
#line 142 "AzureServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("            if (");
#line 144 "AzureServiceClientTemplate.cshtml"
              Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(" == null)\r\n            {\r\n                throw new ArgumentNullException(\"");
#line 146 "AzureServiceClientTemplate.cshtml"
                                               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\");\r\n            }\r\n");
#line 148 "AzureServiceClientTemplate.cshtml"
        }
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 151 "AzureServiceClientTemplate.cshtml"
               Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 151 "AzureServiceClientTemplate.cshtml"
                               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 152 "AzureServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        }\r\n        ");
#line 154 "AzureServiceClientTemplate.cshtml"
     Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 155 "AzureServiceClientTemplate.cshtml"


#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 157 "AzureServiceClientTemplate.cshtml"
                                           Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        /// <param name=\'baseUri\'>\r\n        /// " +
"Optional. The base URI of the service.\r\n        /// </param>\r\n");
#line 162 "AzureServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 164 "AzureServiceClientTemplate.cshtml"
                       Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\'>\r\n        /// Required. ");
#line 165 "AzureServiceClientTemplate.cshtml"
                    Write(param.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n        /// </param>\r\n");
#line 167 "AzureServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'handlers\'>\r\n        /// Optional. The set of delegating " +
"handlers to insert in the http\r\n        /// client pipeline.\r\n        /// </para" +
"m>\r\n        public ");
#line 172 "AzureServiceClientTemplate.cshtml"
             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(Uri baseUri, ");
#line 172 "AzureServiceClientTemplate.cshtml"
                                        Write(Model.RequiredConstructorParameters);

#line default
#line hidden
            WriteLiteral(", params DelegatingHandler[] handlers) : this(handlers)\r\n        {\r\n            i" +
"f (baseUri == null)\r\n            {\r\n                throw new ArgumentNullExcept" +
"ion(\"baseUri\");\r\n            }\r\n");
#line 178 "AzureServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("            if (");
#line 180 "AzureServiceClientTemplate.cshtml"
              Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(" == null)\r\n            {\r\n                throw new ArgumentNullException(\"");
#line 182 "AzureServiceClientTemplate.cshtml"
                                               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\");\r\n            }\r\n");
#line 184 "AzureServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("            this.BaseUri = baseUri;\r\n");
#line 186 "AzureServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 188 "AzureServiceClientTemplate.cshtml"
               Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 188 "AzureServiceClientTemplate.cshtml"
                               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 189 "AzureServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        }\r\n        ");
#line 191 "AzureServiceClientTemplate.cshtml"
     Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 192 "AzureServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    \r\n        /// <summary>\r\n        /// Initializes client properties.\r\n        " +
"/// </summary>\r\n        private void Initialize()\r\n        {\r\n");
#line 199 "AzureServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 199 "AzureServiceClientTemplate.cshtml"
         foreach (var operation in Model.Operations) 
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 201 "AzureServiceClientTemplate.cshtml"
               Write(operation.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" = new ");
#line 201 "AzureServiceClientTemplate.cshtml"
                                                  Write(operation.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(this);\r\n");
#line 202 "AzureServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("            this.BaseUri = new Uri(\"");
#line 203 "AzureServiceClientTemplate.cshtml"
                               Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\");\r\n");
#line 204 "AzureServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 204 "AzureServiceClientTemplate.cshtml"
         foreach (var property in Model.Properties.Where(p => p.DefaultValue != null))
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 206 "AzureServiceClientTemplate.cshtml"
               Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 206 "AzureServiceClientTemplate.cshtml"
                                  Write(property.DefaultValue);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 207 "AzureServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("\r\n");
#line 209 "AzureServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 209 "AzureServiceClientTemplate.cshtml"
         if (Model.Properties.Any(p => "Credentials".Equals(p.Name, StringComparison.OrdinalIgnoreCase) &&
            "SubscriptionCloudCredentials".Equals(p.Type.Name, StringComparison.OrdinalIgnoreCase)))
        {

#line default
#line hidden

            WriteLiteral("            if (this.Credentials != null)\r\n            {\r\n                this.Cr" +
"edentials.InitializeServiceClient(this);\r\n            }\r\n");
#line 216 "AzureServiceClientTemplate.cshtml"
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
            SerializationSettings.Converters.Add(new ResourceJsonConverter()); 
            DeserializationSettings = new JsonSerializerSettings{
                DateFormatHandling = DateFormatHandling.IsoDateFormat,
                DateTimeZoneHandling = DateTimeZoneHandling.Utc,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
");
#line 234 "AzureServiceClientTemplate.cshtml"
            

#line default
#line hidden

#line 234 "AzureServiceClientTemplate.cshtml"
             foreach (var polymorphicType in Model.ModelTypes.Where(t => t.PolymorphicDiscriminator != null))
            {

#line default
#line hidden

            WriteLiteral("            SerializationSettings.Converters.Add(new PolymorphicSerializeJsonConv" +
"erter<");
#line 236 "AzureServiceClientTemplate.cshtml"
                                                                                     Write(polymorphicType.Name);

#line default
#line hidden
            WriteLiteral(">(\"");
#line 236 "AzureServiceClientTemplate.cshtml"
                                                                                                               Write(polymorphicType.PolymorphicDiscriminator);

#line default
#line hidden
            WriteLiteral("\"));\r\n            DeserializationSettings.Converters.Add(new PolymorphicDeseriali" +
"zeJsonConverter<");
#line 237 "AzureServiceClientTemplate.cshtml"
                                                                                         Write(polymorphicType.Name);

#line default
#line hidden
            WriteLiteral(">(\"");
#line 237 "AzureServiceClientTemplate.cshtml"
                                                                                                                   Write(polymorphicType.PolymorphicDiscriminator);

#line default
#line hidden
            WriteLiteral("\"));\r\n");
#line 238 "AzureServiceClientTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("            DeserializationSettings.Converters.Add(new ResourceJsonConverter()); " +
"\r\n            DeserializationSettings.Converters.Add(new CloudErrorJsonConverter" +
"()); \r\n        }    \r\n    \r\n");
#line 243 "AzureServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 243 "AzureServiceClientTemplate.cshtml"
         foreach (var method in Model.MethodTemplateModels)
        {

#line default
#line hidden

            WriteLiteral("        ");
#line 245 "AzureServiceClientTemplate.cshtml"
      Write(Include(new AzureMethodTemplate(), (AzureMethodTemplateModel)method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 246 "AzureServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 246 "AzureServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 246 "AzureServiceClientTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 248 "AzureServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
