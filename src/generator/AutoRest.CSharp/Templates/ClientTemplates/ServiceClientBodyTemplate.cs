// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "ServiceClientBodyTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 2 "ServiceClientBodyTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 3 "ServiceClientBodyTemplate.cshtml"
using AutoRest.Core.Model

#line default
#line hidden
    ;
#line 4 "ServiceClientBodyTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServiceClientBodyTemplate : AutoRest.Core.Template<AutoRest.CSharp.Model.CodeModelCs>
    {
        #line hidden
        public ServiceClientBodyTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
            WriteLiteral("\r\n/// <summary>\r\n/// The base URI of the service.\r\n/// </summary>\r\n");
#line 11 "ServiceClientBodyTemplate.cshtml"
 if(Model.IsCustomBaseUri)
{

#line default
#line hidden

            WriteLiteral("internal string BaseUri {get; set;}\r\n");
#line 14 "ServiceClientBodyTemplate.cshtml"
}
else
{

#line default
#line hidden

            WriteLiteral("public System.Uri BaseUri { get; set; }\r\n");
#line 18 "ServiceClientBodyTemplate.cshtml"
}

#line default
#line hidden

#line 19 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n/// <summary>\r\n/// Gets or sets json serialization settings.\r\n/// </summary>\r" +
"\npublic Newtonsoft.Json.JsonSerializerSettings SerializationSettings { get; priv" +
"ate set; }\r\n");
#line 25 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n/// <summary>\r\n/// Gets or sets json deserialization settings.\r\n/// </summary" +
">\r\npublic Newtonsoft.Json.JsonSerializerSettings DeserializationSettings { get; " +
"private set; }\r\n");
#line 31 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        \r\n");
#line 33 "ServiceClientBodyTemplate.cshtml"
 foreach (var property in Model.Properties)
{

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n");
#line 36 "ServiceClientBodyTemplate.cshtml"
Write(WrapComment("/// ", property.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n/// </summary>\r\npublic ");
#line 38 "ServiceClientBodyTemplate.cshtml"
    Write(property.ModelTypeName);

#line default
#line hidden
            WriteLiteral(" ");
#line 38 "ServiceClientBodyTemplate.cshtml"
                            Write(property.Name);

#line default
#line hidden
            WriteLiteral(" { get; ");
#line 38 "ServiceClientBodyTemplate.cshtml"
                                                   Write(property.IsReadOnly || property.IsConstant ? "private " : "");

#line default
#line hidden
            WriteLiteral("set; }\r\n");
#line 39 "ServiceClientBodyTemplate.cshtml"

#line default
#line hidden

#line 39 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 39 "ServiceClientBodyTemplate.cshtml"
          
}

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 42 "ServiceClientBodyTemplate.cshtml"
 foreach (var operation in Model.AllOperations) 
{

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n/// Gets the I");
#line 45 "ServiceClientBodyTemplate.cshtml"
            Write(operation.TypeName);

#line default
#line hidden
            WriteLiteral(".\r\n/// </summary>\r\npublic virtual I");
#line 47 "ServiceClientBodyTemplate.cshtml"
              Write(operation.TypeName);

#line default
#line hidden
            WriteLiteral(" ");
#line 47 "ServiceClientBodyTemplate.cshtml"
                                    Write(operation.NameForProperty);

#line default
#line hidden
            WriteLiteral(" { get; private set; }\r\n");
#line 48 "ServiceClientBodyTemplate.cshtml"

#line default
#line hidden

#line 48 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 48 "ServiceClientBodyTemplate.cshtml"
          
}

#line default
#line hidden

            WriteLiteral("       \r\n/// <summary>\r\n/// Initializes a new instance of the ");
#line 52 "ServiceClientBodyTemplate.cshtml"
                                 Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n/// </summary>\r\n/// <param name=\'handlers\'>\r\n/// Optional. The delegatin" +
"g handlers to add to the http client pipeline.\r\n/// </param>\r\n");
#line 57 "ServiceClientBodyTemplate.cshtml"
Write(Model.ContainsCredentials ? "protected" : Model.ConstructorVisibility);

#line default
#line hidden
            WriteLiteral(" ");
#line 57 "ServiceClientBodyTemplate.cshtml"
                                                                     Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(params System.Net.Http.DelegatingHandler[] handlers) : base(handlers)\r\n{\r\n    th" +
"is.Initialize();\r\n}\r\n");
#line 61 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n/// <summary>\r\n/// Initializes a new instance of the ");
#line 64 "ServiceClientBodyTemplate.cshtml"
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
");
#line 72 "ServiceClientBodyTemplate.cshtml"
Write(Model.ContainsCredentials ? "protected" : Model.ConstructorVisibility);

#line default
#line hidden
            WriteLiteral(" ");
#line 72 "ServiceClientBodyTemplate.cshtml"
                                                                     Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(System.Net.Http.HttpClientHandler rootHandler, params System.Net.Http.Delegating" +
"Handler[] handlers) : base(rootHandler, handlers)\r\n{\r\n    this.Initialize();\r\n}\r" +
"\n");
#line 76 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n");
#line 78 "ServiceClientBodyTemplate.cshtml"
 if(!Model.IsCustomBaseUri)
{ 

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n/// Initializes a new instance of the ");
#line 81 "ServiceClientBodyTemplate.cshtml"
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
/// <exception cref=""System.ArgumentNullException"">
/// Thrown when a required parameter is null
/// </exception>
");
#line 92 "ServiceClientBodyTemplate.cshtml"
Write(Model.ContainsCredentials ? "protected" : Model.ConstructorVisibility);

#line default
#line hidden
            WriteLiteral(" ");
#line 92 "ServiceClientBodyTemplate.cshtml"
                                                                       Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(System.Uri baseUri, params System.Net.Http.DelegatingHandler[] handlers) : this(" +
"handlers)\r\n{\r\n    if (baseUri == null)\r\n    {\r\n        throw new System.Argument" +
"NullException(\"baseUri\");\r\n    }\r\n\r\n    this.BaseUri = baseUri;\r\n}\r\n");
#line 101 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral(" \r\n");
#line 102 "ServiceClientBodyTemplate.cshtml"


#line default
#line hidden

            WriteLiteral("/// <summary>\r\n/// Initializes a new instance of the ");
#line 104 "ServiceClientBodyTemplate.cshtml"
                                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral(@" class.
/// </summary>
/// <param name='baseUri'>
/// Optional. The base URI of the service.
/// </param>
/// <param name='rootHandler'>
/// Optional. The http client handler used to handle http transport.
/// </param>
/// <param name='handlers'>
/// Optional. The delegating handlers to add to the http client pipeline.
/// </param>
/// <exception cref=""System.ArgumentNullException"">
/// Thrown when a required parameter is null
/// </exception>
");
#line 118 "ServiceClientBodyTemplate.cshtml"
Write(Model.ContainsCredentials ? "protected" : Model.ConstructorVisibility);

#line default
#line hidden
            WriteLiteral(" ");
#line 118 "ServiceClientBodyTemplate.cshtml"
                                                                       Write(Model.Name);

#line default
#line hidden
            WriteLiteral(@"(System.Uri baseUri, System.Net.Http.HttpClientHandler rootHandler, params System.Net.Http.DelegatingHandler[] handlers) : this(rootHandler, handlers)
{
    if (baseUri == null)
    {
        throw new System.ArgumentNullException(""baseUri"");
    }

    this.BaseUri = baseUri;
}
");
#line 127 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 128 "ServiceClientBodyTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("\r\n");
#line 130 "ServiceClientBodyTemplate.cshtml"
  var parameters = Model.Properties.Where(p => p.IsRequired && p.IsReadOnly);

#line default
#line hidden

            WriteLiteral("\r\n");
#line 131 "ServiceClientBodyTemplate.cshtml"
 if (parameters.Any())
{

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n/// Initializes a new instance of the ");
#line 134 "ServiceClientBodyTemplate.cshtml"
                                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n/// </summary>\r\n");
#line 136 "ServiceClientBodyTemplate.cshtml"
foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 138 "ServiceClientBodyTemplate.cshtml"
               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\'>\r\n/// Required. ");
#line 139 "ServiceClientBodyTemplate.cshtml"
            Write(param.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n/// </param>\r\n");
#line 141 "ServiceClientBodyTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("/// <param name=\'handlers\'>\r\n/// Optional. The delegating handlers to add to the " +
"http client pipeline.\r\n/// </param>\r\n/// <exception cref=\"System.ArgumentNullExc" +
"eption\">\r\n/// Thrown when a required parameter is null\r\n/// </exception>\r\n");
#line 148 "ServiceClientBodyTemplate.cshtml"
Write(Model.ConstructorVisibility);

#line default
#line hidden
            WriteLiteral(" ");
#line 148 "ServiceClientBodyTemplate.cshtml"
                             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 148 "ServiceClientBodyTemplate.cshtml"
                                           Write(Model.RequiredConstructorParameters);

#line default
#line hidden
            WriteLiteral(", params System.Net.Http.DelegatingHandler[] handlers) : this(handlers)\r\n{\r\n");
#line 150 "ServiceClientBodyTemplate.cshtml"
foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("    if (");
#line 152 "ServiceClientBodyTemplate.cshtml"
      Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(" == null)\r\n    {\r\n        throw new System.ArgumentNullException(\"");
#line 154 "ServiceClientBodyTemplate.cshtml"
                                              Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\");\r\n    }\r\n");
#line 156 "ServiceClientBodyTemplate.cshtml"
}
foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("    this.");
#line 159 "ServiceClientBodyTemplate.cshtml"
       Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 159 "ServiceClientBodyTemplate.cshtml"
                       Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 160 "ServiceClientBodyTemplate.cshtml"
    

#line default
#line hidden

#line 160 "ServiceClientBodyTemplate.cshtml"
     if (param.ModelType.IsPrimaryType(KnownPrimaryType.Credentials))
    {

#line default
#line hidden

            WriteLiteral("    if (this.Credentials != null)\r\n    {\r\n        this.Credentials.InitializeServ" +
"iceClient(this);\r\n    }\r\n");
#line 166 "ServiceClientBodyTemplate.cshtml"
    }

#line default
#line hidden

#line 166 "ServiceClientBodyTemplate.cshtml"
     
}

#line default
#line hidden

            WriteLiteral("}\r\n");
#line 169 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 170 "ServiceClientBodyTemplate.cshtml"
        

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n/// Initializes a new instance of the ");
#line 172 "ServiceClientBodyTemplate.cshtml"
                                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n/// </summary>\r\n");
#line 174 "ServiceClientBodyTemplate.cshtml"
foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 176 "ServiceClientBodyTemplate.cshtml"
               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\'>\r\n/// Required. ");
#line 177 "ServiceClientBodyTemplate.cshtml"
            Write(param.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n/// </param>\r\n");
#line 179 "ServiceClientBodyTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral(@"/// <param name='rootHandler'>
/// Optional. The http client handler used to handle http transport.
/// </param>
/// <param name='handlers'>
/// Optional. The delegating handlers to add to the http client pipeline.
/// </param>
/// <exception cref=""System.ArgumentNullException"">
/// Thrown when a required parameter is null
/// </exception>
");
#line 189 "ServiceClientBodyTemplate.cshtml"
Write(Model.ConstructorVisibility);

#line default
#line hidden
            WriteLiteral(" ");
#line 189 "ServiceClientBodyTemplate.cshtml"
                             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 189 "ServiceClientBodyTemplate.cshtml"
                                           Write(Model.RequiredConstructorParameters);

#line default
#line hidden
            WriteLiteral(", System.Net.Http.HttpClientHandler rootHandler, params System.Net.Http.Delegatin" +
"gHandler[] handlers) : this(rootHandler, handlers)\r\n{\r\n");
#line 191 "ServiceClientBodyTemplate.cshtml"
foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("    if (");
#line 193 "ServiceClientBodyTemplate.cshtml"
      Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(" == null)\r\n    {\r\n        throw new System.ArgumentNullException(\"");
#line 195 "ServiceClientBodyTemplate.cshtml"
                                              Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\");\r\n    }\r\n");
#line 197 "ServiceClientBodyTemplate.cshtml"
}
foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("    this.");
#line 200 "ServiceClientBodyTemplate.cshtml"
       Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 200 "ServiceClientBodyTemplate.cshtml"
                       Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 201 "ServiceClientBodyTemplate.cshtml"
    

#line default
#line hidden

#line 201 "ServiceClientBodyTemplate.cshtml"
     if (param.ModelType.IsPrimaryType(KnownPrimaryType.Credentials))
    {

#line default
#line hidden

            WriteLiteral("    if (this.Credentials != null)\r\n    {\r\n        this.Credentials.InitializeServ" +
"iceClient(this);\r\n    }\r\n");
#line 207 "ServiceClientBodyTemplate.cshtml"
    }

#line default
#line hidden

#line 207 "ServiceClientBodyTemplate.cshtml"
     
}

#line default
#line hidden

            WriteLiteral("}\r\n");
#line 210 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 211 "ServiceClientBodyTemplate.cshtml"

if(!Model.IsCustomBaseUri)
{ 

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n/// Initializes a new instance of the ");
#line 215 "ServiceClientBodyTemplate.cshtml"
                                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n/// </summary>\r\n/// <param name=\'baseUri\'>\r\n/// Optional. The base URI o" +
"f the service.\r\n/// </param>\r\n");
#line 220 "ServiceClientBodyTemplate.cshtml"
foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 222 "ServiceClientBodyTemplate.cshtml"
               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\'>\r\n/// Required. ");
#line 223 "ServiceClientBodyTemplate.cshtml"
            Write(param.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n/// </param>\r\n");
#line 225 "ServiceClientBodyTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral("/// <param name=\'handlers\'>\r\n/// Optional. The delegating handlers to add to the " +
"http client pipeline.\r\n/// </param>\r\n/// <exception cref=\"System.ArgumentNullExc" +
"eption\">\r\n/// Thrown when a required parameter is null\r\n/// </exception>\r\n");
#line 232 "ServiceClientBodyTemplate.cshtml"
Write(Model.ConstructorVisibility);

#line default
#line hidden
            WriteLiteral(" ");
#line 232 "ServiceClientBodyTemplate.cshtml"
                             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(System.Uri baseUri, ");
#line 232 "ServiceClientBodyTemplate.cshtml"
                                                               Write(Model.RequiredConstructorParameters);

#line default
#line hidden
            WriteLiteral(", params System.Net.Http.DelegatingHandler[] handlers) : this(handlers)\r\n{\r\n    i" +
"f (baseUri == null)\r\n    {\r\n        throw new System.ArgumentNullException(\"base" +
"Uri\");\r\n    }\r\n");
#line 238 "ServiceClientBodyTemplate.cshtml"
    foreach (var param in parameters)
    {

#line default
#line hidden

            WriteLiteral("    if (");
#line 240 "ServiceClientBodyTemplate.cshtml"
      Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(" == null)\r\n    {\r\n        throw new System.ArgumentNullException(\"");
#line 242 "ServiceClientBodyTemplate.cshtml"
                                              Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\");\r\n    }\r\n");
#line 244 "ServiceClientBodyTemplate.cshtml"
}


#line default
#line hidden

            WriteLiteral("    this.BaseUri = baseUri;\r\n");
#line 247 "ServiceClientBodyTemplate.cshtml"

foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("    this.");
#line 250 "ServiceClientBodyTemplate.cshtml"
       Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 250 "ServiceClientBodyTemplate.cshtml"
                       Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 251 "ServiceClientBodyTemplate.cshtml"


#line default
#line hidden

#line 252 "ServiceClientBodyTemplate.cshtml"
 if (param.ModelType.IsPrimaryType(KnownPrimaryType.Credentials))
{

#line default
#line hidden

            WriteLiteral("    if (this.Credentials != null)\r\n    {\r\n        this.Credentials.InitializeServ" +
"iceClient(this);\r\n    }\r\n");
#line 258 "ServiceClientBodyTemplate.cshtml"
}

#line default
#line hidden

#line 258 "ServiceClientBodyTemplate.cshtml"
 
}

#line default
#line hidden

            WriteLiteral("}\r\n");
#line 261 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 262 "ServiceClientBodyTemplate.cshtml"
        

#line default
#line hidden

            WriteLiteral("/// <summary>\r\n/// Initializes a new instance of the ");
#line 264 "ServiceClientBodyTemplate.cshtml"
                                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" class.\r\n/// </summary>\r\n/// <param name=\'baseUri\'>\r\n/// Optional. The base URI o" +
"f the service.\r\n/// </param>\r\n");
#line 269 "ServiceClientBodyTemplate.cshtml"
foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("/// <param name=\'");
#line 271 "ServiceClientBodyTemplate.cshtml"
               Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\'>\r\n/// Required. ");
#line 272 "ServiceClientBodyTemplate.cshtml"
            Write(param.Documentation);

#line default
#line hidden
            WriteLiteral("\r\n/// </param>\r\n");
#line 274 "ServiceClientBodyTemplate.cshtml"
}

#line default
#line hidden

            WriteLiteral(@"/// <param name='rootHandler'>
/// Optional. The http client handler used to handle http transport.
/// </param>
/// <param name='handlers'>
/// Optional. The delegating handlers to add to the http client pipeline.
/// </param>
/// <exception cref=""System.ArgumentNullException"">
/// Thrown when a required parameter is null
/// </exception>
");
#line 284 "ServiceClientBodyTemplate.cshtml"
Write(Model.ConstructorVisibility);

#line default
#line hidden
            WriteLiteral(" ");
#line 284 "ServiceClientBodyTemplate.cshtml"
                             Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(System.Uri baseUri, ");
#line 284 "ServiceClientBodyTemplate.cshtml"
                                                               Write(Model.RequiredConstructorParameters);

#line default
#line hidden
            WriteLiteral(", System.Net.Http.HttpClientHandler rootHandler, params System.Net.Http.Delegatin" +
"gHandler[] handlers) : this(rootHandler, handlers)\r\n{\r\n    if (baseUri == null)\r" +
"\n    {\r\n        throw new System.ArgumentNullException(\"baseUri\");\r\n    }\r\n");
#line 290 "ServiceClientBodyTemplate.cshtml"

foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("    if (");
#line 293 "ServiceClientBodyTemplate.cshtml"
      Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(" == null)\r\n    {\r\n        throw new System.ArgumentNullException(\"");
#line 295 "ServiceClientBodyTemplate.cshtml"
                                              Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral("\");\r\n    }\r\n");
#line 297 "ServiceClientBodyTemplate.cshtml"
}


#line default
#line hidden

            WriteLiteral("    this.BaseUri = baseUri;\r\n");
#line 300 "ServiceClientBodyTemplate.cshtml"

foreach (var param in parameters)
{

#line default
#line hidden

            WriteLiteral("    this.");
#line 303 "ServiceClientBodyTemplate.cshtml"
       Write(param.Name);

#line default
#line hidden
            WriteLiteral(" = ");
#line 303 "ServiceClientBodyTemplate.cshtml"
                       Write(param.Name.ToCamelCase());

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 304 "ServiceClientBodyTemplate.cshtml"


#line default
#line hidden

#line 305 "ServiceClientBodyTemplate.cshtml"
 if (param.ModelType.IsPrimaryType(KnownPrimaryType.Credentials))
{

#line default
#line hidden

            WriteLiteral("    if (this.Credentials != null)\r\n    {\r\n        this.Credentials.InitializeServ" +
"iceClient(this);\r\n    }\r\n");
#line 311 "ServiceClientBodyTemplate.cshtml"
}

#line default
#line hidden

#line 311 "ServiceClientBodyTemplate.cshtml"
 
}

#line default
#line hidden

            WriteLiteral("}\r\n");
#line 314 "ServiceClientBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 315 "ServiceClientBodyTemplate.cshtml"
}
}

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
