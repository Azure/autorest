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
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 4 "MethodGroupInterfaceTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n    using System;\r\n    using System.Collections.Generic;\r\n    using System.N" +
"et.Http;\r\n    using System.Threading;\r\n    using System.Threading.Tasks;\r\n    us" +
"ing Microsoft.Rest;\r\n");
#line 12 "MethodGroupInterfaceTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 13 "MethodGroupInterfaceTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 14 "MethodGroupInterfaceTemplate.cshtml"
}

#line default
#line hidden

#line 15 "MethodGroupInterfaceTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    /// ");
#line 17 "MethodGroupInterfaceTemplate.cshtml"
    Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" operations.\r\n    /// </summary>\r\n    public partial interface I");
#line 19 "MethodGroupInterfaceTemplate.cshtml"
                          Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n");
#line 21 "MethodGroupInterfaceTemplate.cshtml"
    

#line default
#line hidden

#line 21 "MethodGroupInterfaceTemplate.cshtml"
     foreach(var method in Model.MethodTemplateModels)
    {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 24 "MethodGroupInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", method.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n");
#line 26 "MethodGroupInterfaceTemplate.cshtml"
        foreach (var parameter in method.LocalParameters)
        {

#line default
#line hidden

            WriteLiteral("        /// <param name=\'");
#line 28 "MethodGroupInterfaceTemplate.cshtml"
                      Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("\'>\r\n        ");
#line 29 "MethodGroupInterfaceTemplate.cshtml"
     Write(WrapComment("/// ", parameter.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </param>\r\n");
#line 31 "MethodGroupInterfaceTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        /// <param name=\'customHeaders\'>\r\n        /// The headers that will be ad" +
"ded to request.\r\n        /// </param>\r\n        /// <param name=\'cancellationToke" +
"n\'>\r\n        /// The cancellation token.\r\n        /// </param>\r\n        Task<");
#line 38 "MethodGroupInterfaceTemplate.cshtml"
          Write(method.OperationResponseReturnTypeString);

#line default
#line hidden
            WriteLiteral("> ");
#line 38 "MethodGroupInterfaceTemplate.cshtml"
                                                      Write(method.Name);

#line default
#line hidden
            WriteLiteral("WithHttpMessagesAsync(");
#line 38 "MethodGroupInterfaceTemplate.cshtml"
                                                                                          Write(method.GetAsyncMethodParameterDeclaration(true));

#line default
#line hidden
            WriteLiteral(");\r\n");
#line 39 "MethodGroupInterfaceTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
