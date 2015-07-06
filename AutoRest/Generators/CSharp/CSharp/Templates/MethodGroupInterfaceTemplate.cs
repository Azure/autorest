// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Templates
{
#line 1 "MethodGroupInterfaceTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class MethodGroupInterfaceTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.CSharp.MethodGroupTemplateModel>
    {
        #line hidden
        public MethodGroupInterfaceTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 3 "MethodGroupInterfaceTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\nnamespace ");
#line 4 "MethodGroupInterfaceTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\n{\n    using System;\n    using System.Collections.Generic;\n    using System.Net.H" +
"ttp;\n    using System.Threading;\n    using System.Threading.Tasks;\n    using Mic" +
"rosoft.Rest;\n");
#line 12 "MethodGroupInterfaceTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 13 "MethodGroupInterfaceTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\n");
#line 14 "MethodGroupInterfaceTemplate.cshtml"
}

#line default
#line hidden

#line 15 "MethodGroupInterfaceTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n    /// <summary>\n    ");
#line 17 "MethodGroupInterfaceTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\n    /// </summary>\n    public partial interface I");
#line 19 "MethodGroupInterfaceTemplate.cshtml"
                          Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("\n    {\n");
#line 21 "MethodGroupInterfaceTemplate.cshtml"
    

#line default
#line hidden

#line 21 "MethodGroupInterfaceTemplate.cshtml"
     foreach(var method in Model.MethodTemplateModels)
    {

#line default
#line hidden

            WriteLiteral("        /// <summary>\n        ");
#line 24 "MethodGroupInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", method.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\n        /// </summary>\n");
#line 26 "MethodGroupInterfaceTemplate.cshtml"
        foreach (var parameter in method.Parameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 28 "MethodGroupInterfaceTemplate.cshtml"
                      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\n        ");
#line 29 "MethodGroupInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\n        /// </param>\n");
#line 31 "MethodGroupInterfaceTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'customHeaders\'>\n        /// Headers that will be added t" +
"o request.\n        /// </param>\n        /// <param name=\'cancellationToken\'>\n   " +
"     /// Cancellation token.\n        /// </param>\n        Task<");
#line 38 "MethodGroupInterfaceTemplate.cshtml"
          Write(method.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 38 "MethodGroupInterfaceTemplate.cshtml"
                                                      Write(method.Name);

#line default
#line hidden
            WriteLiteral("WithOperationResponseAsync(");
#line 38 "MethodGroupInterfaceTemplate.cshtml"
                                                                                               Write(method.GetAsyncMethodParameterDeclaration(true));

#line default
#line hidden
            WriteLiteral(");\n");
#line 39 "MethodGroupInterfaceTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    }\n}\n");
        }
        #pragma warning restore 1998
    }
}
