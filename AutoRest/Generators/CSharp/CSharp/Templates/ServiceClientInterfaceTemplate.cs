// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Templates
{
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
#line 2 "ServiceClientInterfaceTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 3 "ServiceClientInterfaceTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n    using System;\r\n    using System.Collections.Generic;\r\n    using System.N" +
"et.Http;\r\n    using System.Threading;\r\n    using System.Threading.Tasks;\r\n    us" +
"ing Microsoft.Rest;\r\n");
#line 11 "ServiceClientInterfaceTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 12 "ServiceClientInterfaceTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 13 "ServiceClientInterfaceTemplate.cshtml"
}

#line default
#line hidden

#line 14 "ServiceClientInterfaceTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    ");
#line 16 "ServiceClientInterfaceTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n    public partial interface I");
#line 18 "ServiceClientInterfaceTemplate.cshtml"
                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" : IDisposable\r\n    {\r\n        /// <summary>\r\n        /// The base URI of the ser" +
"vice.\r\n        /// </summary>\r\n        Uri BaseUri { get; set; }\r\n        ");
#line 24 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 25 "ServiceClientInterfaceTemplate.cshtml"
    

#line default
#line hidden

#line 25 "ServiceClientInterfaceTemplate.cshtml"
     foreach(var operation in Model.Operations)
    {

#line default
#line hidden

            WriteLiteral("        I");
#line 27 "ServiceClientInterfaceTemplate.cshtml"
       Write(operation.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" ");
#line 27 "ServiceClientInterfaceTemplate.cshtml"
                                    Write(operation.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" { get; }\r\n");
#line 28 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 28 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 28 "ServiceClientInterfaceTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 30 "ServiceClientInterfaceTemplate.cshtml"
    }        

#line default
#line hidden

            WriteLiteral("    ");
#line 31 "ServiceClientInterfaceTemplate.cshtml"
     foreach(var method in Model.MethodTemplateModels)
    {

#line default
#line hidden

            WriteLiteral("        \r\n        /// <summary>\r\n        ");
#line 35 "ServiceClientInterfaceTemplate.cshtml"
   Write(WrapComment("/// ", method.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n            \r\n");
#line 38 "ServiceClientInterfaceTemplate.cshtml"
        foreach (var parameter in method.Parameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 40 "ServiceClientInterfaceTemplate.cshtml"
                      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n        ");
#line 41 "ServiceClientInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", parameter.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n        /// </param>\r\n");
#line 43 "ServiceClientInterfaceTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'cancellationToken\'>\r\n        /// Cancellation token.\r\n  " +
"      /// </param>\r\n        Task<");
#line 47 "ServiceClientInterfaceTemplate.cshtml"
           Write(method.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 47 "ServiceClientInterfaceTemplate.cshtml"
                                                        Write(method.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 47 "ServiceClientInterfaceTemplate.cshtml"
                                                                                                Write(method.AsyncMethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 48 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 48 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 48 "ServiceClientInterfaceTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 50 "ServiceClientInterfaceTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
