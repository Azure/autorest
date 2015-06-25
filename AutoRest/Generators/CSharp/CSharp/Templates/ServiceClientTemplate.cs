// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Templates
{
#line 1 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp

#line default
#line hidden
    ;
#line 2 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Templates

#line default
#line hidden
    ;
#line 3 "ServiceClientTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
#line 4 "ServiceClientTemplate.cshtml"
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
#line 6 "ServiceClientTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 7 "ServiceClientTemplate.cshtml"
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
#line 21 "ServiceClientTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 22 "ServiceClientTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 23 "ServiceClientTemplate.cshtml"
}

#line default
#line hidden

#line 24 "ServiceClientTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    ");
#line 26 "ServiceClientTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n    public partial class ");
#line 28 "ServiceClientTemplate.cshtml"
                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" : ServiceClient<");
#line 28 "ServiceClientTemplate.cshtml"
                                                Write(Model.Name);

#line default
#line hidden
            WriteLiteral(">, I");
#line 28 "ServiceClientTemplate.cshtml"
                                                                Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n        /// <summary>\r\n        /// The base URI of the service.\r\n       " +
" /// </summary>\r\n        public Uri BaseUri { get; set; }\r\n        ");
#line 34 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Gets or sets json serialization settings.\r" +
"\n        /// </summary>\r\n        public JsonSerializerSettings SerializationSett" +
"ings { get; private set; }\r\n        ");
#line 40 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Gets or sets json deserialization settings" +
".\r\n        /// </summary>\r\n        public JsonSerializerSettings Deserialization" +
"Settings { get; private set; }        \r\n        ");
#line 46 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        \r\n");
#line 48 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 48 "ServiceClientTemplate.cshtml"
         foreach (var property in Model.Properties)
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 51 "ServiceClientTemplate.cshtml"
     Write(WrapComment("/// ", property.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n        public ");
#line 53 "ServiceClientTemplate.cshtml"
            Write(property.Type);

#line default
#line hidden
            WriteLiteral(" ");
#line 53 "ServiceClientTemplate.cshtml"
                           Write(property.Name);

#line default
#line hidden
            WriteLiteral(" { get; ");
#line 53 "ServiceClientTemplate.cshtml"
                                                  Write(property.IsReadOnly ? "private " : "");

#line default
#line hidden
            WriteLiteral("set; }\r\n");
#line 54 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 54 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 54 "ServiceClientTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 57 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 57 "ServiceClientTemplate.cshtml"
         foreach (var operation in Model.Operations) 
        {

#line default
#line hidden

            WriteLiteral("        public virtual I");
#line 59 "ServiceClientTemplate.cshtml"
                      Write(operation.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" ");
#line 59 "ServiceClientTemplate.cshtml"
                                                   Write(operation.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" { get; private set; }\r\n");
#line 60 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 60 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 60 "ServiceClientTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 64 "ServiceClientTemplate.cshtml"
                                         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        public ");
#line 66 "ServiceClientTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral("() : base()\r\n        {\r\n            this.Initialize();\r\n        }\r\n        ");
#line 70 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 72 "ServiceClientTemplate.cshtml"
                                         Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        /// <param name=\'handlers\'>\r\n        ///" +
" Optional. The delegating handlers to add to the http client pipeline.\r\n        " +
"/// </param>\r\n        public ");
#line 77 "ServiceClientTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(params DelegatingHandler[] handlers) : base(handlers)\r\n        {\r\n            th" +
"is.Initialize();\r\n        }\r\n        ");
#line 81 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 84 "ServiceClientTemplate.cshtml"
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
#line 92 "ServiceClientTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(HttpClientHandler rootHandler, params DelegatingHandler[] handlers) : base(rootH" +
"andler, handlers)\r\n        {\r\n            this.Initialize();\r\n        }\r\n       " +
" ");
#line 96 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 99 "ServiceClientTemplate.cshtml"
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
#line 107 "ServiceClientTemplate.cshtml"
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
#line 116 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 118 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 118 "ServiceClientTemplate.cshtml"
          var parameters = Model.Properties.Where(p => p.IsRequired);

#line default
#line hidden

            WriteLiteral("\r\n");
#line 119 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 119 "ServiceClientTemplate.cshtml"
         if (parameters.Any())
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 122 "ServiceClientTemplate.cshtml"
                                           Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n");
#line 124 "ServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 126 "ServiceClientTemplate.cshtml"
                       Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\'>\r\n        /// Required. ");
#line 127 "ServiceClientTemplate.cshtml"
                    Write(param.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n        /// </param>\r\n");
#line 129 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'handlers\'>\r\n        /// Optional. The delegating handler" +
"s to add to the http client pipeline.\r\n        /// </param>\r\n        public ");
#line 133 "ServiceClientTemplate.cshtml"
             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 133 "ServiceClientTemplate.cshtml"
                           Write(Model.RequiredConstructorParameters);

#line default
#line hidden
            WriteLiteral(", params DelegatingHandler[] handlers) : this(handlers)\r\n        {\r\n");
#line 135 "ServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("            if (");
#line 137 "ServiceClientTemplate.cshtml"
              Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(" == null)\r\n            {\r\n                throw new ArgumentNullException(\"");
#line 139 "ServiceClientTemplate.cshtml"
                                               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\");\r\n            }\r\n");
#line 141 "ServiceClientTemplate.cshtml"
        }
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 144 "ServiceClientTemplate.cshtml"
               Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 144 "ServiceClientTemplate.cshtml"
                               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 145 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("            this.Initialize();\r\n        }\r\n        ");
#line 148 "ServiceClientTemplate.cshtml"
     Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 149 "ServiceClientTemplate.cshtml"


#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 151 "ServiceClientTemplate.cshtml"
                                           Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        /// <param name=\'baseUri\'>\r\n        /// " +
"Optional. The base URI of the service.\r\n        /// </param>\r\n");
#line 156 "ServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 158 "ServiceClientTemplate.cshtml"
                       Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\'>\r\n        /// Required. ");
#line 159 "ServiceClientTemplate.cshtml"
                    Write(param.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n        /// </param>\r\n");
#line 161 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'handlers\'>\r\n        /// Optional. The delegating handler" +
"s to add to the http client pipeline.\r\n        /// </param>\r\n        public ");
#line 165 "ServiceClientTemplate.cshtml"
             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(Uri baseUri, ");
#line 165 "ServiceClientTemplate.cshtml"
                                        Write(Model.RequiredConstructorParameters);

#line default
#line hidden
            WriteLiteral(", params DelegatingHandler[] handlers) : this(handlers)\r\n        {\r\n            i" +
"f (baseUri == null)\r\n            {\r\n                throw new ArgumentNullExcept" +
"ion(\"baseUri\");\r\n            }\r\n");
#line 171 "ServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("            if (");
#line 173 "ServiceClientTemplate.cshtml"
              Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(" == null)\r\n            {\r\n                throw new ArgumentNullException(\"");
#line 175 "ServiceClientTemplate.cshtml"
                                               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\");\r\n            }\r\n");
#line 177 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("            this.BaseUri = baseUri;\r\n");
#line 179 "ServiceClientTemplate.cshtml"
        foreach (var param in parameters)
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 181 "ServiceClientTemplate.cshtml"
               Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 181 "ServiceClientTemplate.cshtml"
                               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 182 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        }\r\n        ");
#line 184 "ServiceClientTemplate.cshtml"
     Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 185 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    \r\n        /// <summary>\r\n        /// Initializes client properties.\r\n        " +
"/// </summary>\r\n        private void Initialize()\r\n        {\r\n");
#line 192 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 192 "ServiceClientTemplate.cshtml"
         foreach (var operation in Model.Operations) 
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 194 "ServiceClientTemplate.cshtml"
               Write(operation.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" = new ");
#line 194 "ServiceClientTemplate.cshtml"
                                                  Write(operation.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(this);\r\n");
#line 195 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("            this.BaseUri = new Uri(\"");
#line 196 "ServiceClientTemplate.cshtml"
                               Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\");\r\n");
#line 197 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 197 "ServiceClientTemplate.cshtml"
         foreach (var property in Model.Properties.Where(p => p.DefaultValue != null))
        {

#line default
#line hidden

            WriteLiteral("            this.");
#line 199 "ServiceClientTemplate.cshtml"
               Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 199 "ServiceClientTemplate.cshtml"
                                  Write(property.DefaultValue);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 200 "ServiceClientTemplate.cshtml"
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
#line 217 "ServiceClientTemplate.cshtml"
            

#line default
#line hidden

#line 217 "ServiceClientTemplate.cshtml"
             foreach (var polymorphicType in Model.ModelTypes.Where(t => t.PolymorphicDiscriminator != null))
            {

#line default
#line hidden

            WriteLiteral("            SerializationSettings.Converters.Add(new PolymorphicSerializeJsonConv" +
"erter<");
#line 219 "ServiceClientTemplate.cshtml"
                                                                                     Write(polymorphicType.Name);

#line default
#line hidden
            WriteLiteral(">(\"");
#line 219 "ServiceClientTemplate.cshtml"
                                                                                                               Write(polymorphicType.PolymorphicDiscriminator);

#line default
#line hidden
            WriteLiteral("\"));\r\n            DeserializationSettings.Converters.Add(new PolymorphicDeseriali" +
"zeJsonConverter<");
#line 220 "ServiceClientTemplate.cshtml"
                                                                                         Write(polymorphicType.Name);

#line default
#line hidden
            WriteLiteral(">(\"");
#line 220 "ServiceClientTemplate.cshtml"
                                                                                                                   Write(polymorphicType.PolymorphicDiscriminator);

#line default
#line hidden
            WriteLiteral("\"));\r\n");
#line 221 "ServiceClientTemplate.cshtml"
            } 

#line default
#line hidden

            WriteLiteral("        }    \r\n    \r\n");
#line 224 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 224 "ServiceClientTemplate.cshtml"
         foreach (var method in Model.MethodTemplateModels)
        {

#line default
#line hidden

            WriteLiteral("        ");
#line 226 "ServiceClientTemplate.cshtml"
      Write(Include(new MethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 227 "ServiceClientTemplate.cshtml"
        

#line default
#line hidden

#line 227 "ServiceClientTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 227 "ServiceClientTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 229 "ServiceClientTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
