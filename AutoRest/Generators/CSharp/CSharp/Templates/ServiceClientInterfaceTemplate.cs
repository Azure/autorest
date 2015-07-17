// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Templates
{
#line 1 "ServiceClientInterfaceTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServiceClientInterfaceTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.CSharp.ServiceClientTemplateModel>
    {
        #line hidden
        public ServiceClientInterfaceTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 3 "ServiceClientInterfaceTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 4 "ServiceClientInterfaceTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n    using System;\r\n    using System.Collections.Generic;\r\n    using System.N" +
"et.Http;\r\n    using System.Threading;\r\n    using System.Threading.Tasks;\r\n    us" +
"ing Newtonsoft.Json;\r\n    using Microsoft.Rest;\r\n\r\n");
#line 14 "ServiceClientInterfaceTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 15 "ServiceClientInterfaceTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 16 "ServiceClientInterfaceTemplate.cshtml"
}

#line default
#line hidden

#line 17 "ServiceClientInterfaceTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    ");
#line 19 "ServiceClientInterfaceTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n    public partial interface I");
#line 21 "ServiceClientInterfaceTemplate.cshtml"
                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n        /// <summary>\r\n        /// The base URI of the service.\r\n       " +
" /// </summary>\r\n        Uri BaseUri { get; set; }\r\n        ");
#line 27 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Gets or sets json serialization settings.\r" +
"\n        /// </summary>\r\n        JsonSerializerSettings SerializationSettings { " +
"get; }\r\n        ");
#line 33 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\r\n        /// <summary>\r\n        /// Gets or sets json deserialization settings" +
".\r\n        /// </summary>\r\n        JsonSerializerSettings DeserializationSetting" +
"s { get; }        \r\n        ");
#line 39 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        \r\n");
#line 41 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 41 "ServiceClientInterfaceTemplate.cshtml"
         foreach (var property in Model.Properties)
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 44 "ServiceClientInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", property.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n        ");
#line 46 "ServiceClientInterfaceTemplate.cshtml"
     Write(property.Type);

#line default
#line hidden
            WriteLiteral(" ");
#line 46 "ServiceClientInterfaceTemplate.cshtml"
                    Write(property.Name);

#line default
#line hidden
            WriteLiteral(" { get;");
#line 46 "ServiceClientInterfaceTemplate.cshtml"
                                          Write(property.IsReadOnly ? "" : " set;");

#line default
#line hidden
            WriteLiteral(" }\r\n");
#line 47 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 47 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 47 "ServiceClientInterfaceTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("\r\n        ");
#line 50 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 51 "ServiceClientInterfaceTemplate.cshtml"
    

#line default
#line hidden

#line 51 "ServiceClientInterfaceTemplate.cshtml"
     foreach(var operation in Model.Operations)
    {

#line default
#line hidden

            WriteLiteral("        I");
#line 53 "ServiceClientInterfaceTemplate.cshtml"
       Write(operation.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" ");
#line 53 "ServiceClientInterfaceTemplate.cshtml"
                                    Write(operation.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" { get; }\r\n");
#line 54 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 54 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 54 "ServiceClientInterfaceTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 56 "ServiceClientInterfaceTemplate.cshtml"
    }        

#line default
#line hidden

            WriteLiteral("    ");
#line 57 "ServiceClientInterfaceTemplate.cshtml"
     foreach(var method in Model.MethodTemplateModels)
    {

#line default
#line hidden

            WriteLiteral("        \r\n        /// <summary>\r\n        ");
#line 61 "ServiceClientInterfaceTemplate.cshtml"
   Write(WrapComment("/// ", method.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n            \r\n");
#line 64 "ServiceClientInterfaceTemplate.cshtml"
        foreach (var parameter in method.LocalParameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 66 "ServiceClientInterfaceTemplate.cshtml"
                      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n        ");
#line 67 "ServiceClientInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </param>\r\n");
#line 69 "ServiceClientInterfaceTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'customHeaders\'>\r\n        /// Headers that will be added " +
"to request.\r\n        /// </param>        \r\n        /// <param name=\'cancellation" +
"Token\'>\r\n        /// Cancellation token.\r\n        /// </param>\r\n        Task<");
#line 76 "ServiceClientInterfaceTemplate.cshtml"
           Write(method.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 76 "ServiceClientInterfaceTemplate.cshtml"
                                                        Write(method.Name);

#line default
#line hidden
            WriteLiteral("WithHttpMessagesAsync(");
#line 76 "ServiceClientInterfaceTemplate.cshtml"
                                                                                            Write(method.GetAsyncMethodParameterDeclaration(true));

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 77 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 77 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 77 "ServiceClientInterfaceTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 79 "ServiceClientInterfaceTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\r\n    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
