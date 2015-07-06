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
            WriteLiteral("\nnamespace ");
#line 4 "ServiceClientInterfaceTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\n{\n    using System;\n    using System.Collections.Generic;\n    using System.Net.H" +
"ttp;\n    using System.Threading;\n    using System.Threading.Tasks;\n    using Mic" +
"rosoft.Rest;\n");
#line 12 "ServiceClientInterfaceTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 13 "ServiceClientInterfaceTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\n");
#line 14 "ServiceClientInterfaceTemplate.cshtml"
}

#line default
#line hidden

#line 15 "ServiceClientInterfaceTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n    /// <summary>\n    ");
#line 17 "ServiceClientInterfaceTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\n    /// </summary>\n    public partial interface I");
#line 19 "ServiceClientInterfaceTemplate.cshtml"
                          Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\n    {\n        /// <summary>\n        /// The base URI of the service.\n        ///" +
" </summary>\n        Uri BaseUri { get; set; }\n        ");
#line 25 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n");
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
            WriteLiteral(" { get; }\n");
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

            WriteLiteral("        \n");
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

            WriteLiteral("        \n        /// <summary>\n        ");
#line 36 "ServiceClientInterfaceTemplate.cshtml"
   Write(WrapComment("/// ", method.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\n        /// </summary>\n            \n");
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
            WriteLiteral("\'>\n        ");
#line 42 "ServiceClientInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\n        /// </param>\n");
#line 44 "ServiceClientInterfaceTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'customHeaders\'>\n        /// Headers that will be added t" +
"o request.\n        /// </param>        \n        /// <param name=\'cancellationTok" +
"en\'>\n        /// Cancellation token.\n        /// </param>\n        Task<");
#line 51 "ServiceClientInterfaceTemplate.cshtml"
           Write(method.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 51 "ServiceClientInterfaceTemplate.cshtml"
                                                        Write(method.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 51 "ServiceClientInterfaceTemplate.cshtml"
                                                                                                 Write(method.GetAsyncMethodParameterDeclaration(true));

#line default
#line hidden
            WriteLiteral(");\n");
#line 52 "ServiceClientInterfaceTemplate.cshtml"
        

#line default
#line hidden

#line 52 "ServiceClientInterfaceTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 52 "ServiceClientInterfaceTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \n");
#line 54 "ServiceClientInterfaceTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    }\n}\n");
        }
        #pragma warning restore 1998
    }
}
