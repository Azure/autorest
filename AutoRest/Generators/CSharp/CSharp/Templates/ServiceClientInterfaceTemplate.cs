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
"ing Microsoft.Rest;\r\n");
#line 12 "ServiceClientInterfaceTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 13 "ServiceClientInterfaceTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 14 "ServiceClientInterfaceTemplate.cshtml"
}

#line default
#line hidden

#line 15 "ServiceClientInterfaceTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    ");
#line 17 "ServiceClientInterfaceTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n    public partial interface I");
#line 19 "ServiceClientInterfaceTemplate.cshtml"
                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n        /// <summary>\r\n        /// The base URI of the service.\r\n       " +
" /// </summary>\r\n        Uri BaseUri { get; set; }\r\n        ");
#line 25 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 26 "ServiceClientInterfaceTemplate.cshtml"
    

#line default
#line hidden

#line 26 "ServiceClientInterfaceTemplate.cshtml"
     foreach(var operation in Model.Operations)
    {

#line default
#line hidden

            WriteLiteral("        I");
#line 28 "ServiceClientInterfaceTemplate.cshtml"
       Write(operation.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" ");
#line 28 "ServiceClientInterfaceTemplate.cshtml"
                                    Write(operation.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" { get; }\r\n");
#line 29 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 29 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 29 "ServiceClientInterfaceTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 31 "ServiceClientInterfaceTemplate.cshtml"
    }        

#line default
#line hidden

            WriteLiteral("    ");
#line 32 "ServiceClientInterfaceTemplate.cshtml"
     foreach(var method in Model.MethodTemplateModels)
    {

#line default
#line hidden

            WriteLiteral("        \r\n        /// <summary>\r\n        ");
#line 36 "ServiceClientInterfaceTemplate.cshtml"
   Write(WrapComment("/// ", method.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n            \r\n");
#line 39 "ServiceClientInterfaceTemplate.cshtml"
        foreach (var parameter in method.Parameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 41 "ServiceClientInterfaceTemplate.cshtml"
                      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n        ");
#line 42 "ServiceClientInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </param>\r\n");
#line 44 "ServiceClientInterfaceTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'cancellationToken\'>\r\n        /// Cancellation token.\r\n  " +
"      /// </param>\r\n        Task<");
#line 48 "ServiceClientInterfaceTemplate.cshtml"
           Write(method.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 48 "ServiceClientInterfaceTemplate.cshtml"
                                                        Write(method.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 48 "ServiceClientInterfaceTemplate.cshtml"
                                                                                                Write(method.AsyncMethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 49 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 49 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 49 "ServiceClientInterfaceTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 51 "ServiceClientInterfaceTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
