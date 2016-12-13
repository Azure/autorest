// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "ServiceServerTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 2 "ServiceServerTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 3 "ServiceServerTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
#line 4 "ServiceServerTemplate.cshtml"
using AutoRest.CSharp.Model

#line default
#line hidden
    ;
#line 5 "ServiceServerTemplate.cshtml"
using AutoRest.CSharp.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServiceServerTemplate : AutoRest.Core.Template<CodeModelCs>
    {
        #line hidden
        public ServiceServerTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 7 "ServiceServerTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 8 "ServiceServerTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nusing System;\r\nusing System.Collections.Generic;\r\nusing System.Linq;\r\nusing Sys" +
"tem.Threading.Tasks;\r\nusing Microsoft.AspNetCore.Mvc;\r\nusing Microsoft.Rest;\r\n\r\n" +
"namespace ");
#line 16 "ServiceServerTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n    \r\n");
#line 19 "ServiceServerTemplate.cshtml"
 foreach (var usingString in Model.Usings)
{

#line default
#line hidden

            WriteLiteral("    using ");
#line 21 "ServiceServerTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 22 "ServiceServerTemplate.cshtml"
}

#line default
#line hidden

#line 23 "ServiceServerTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 24 "ServiceServerTemplate.cshtml"
 if (!string.IsNullOrWhiteSpace(Model.Documentation))
{

#line default
#line hidden

            WriteLiteral("    /// <summary>\r\n    ");
#line 27 "ServiceServerTemplate.cshtml"
 Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n");
#line 29 "ServiceServerTemplate.cshtml"
 }

#line default
#line hidden

            WriteLiteral("\r\n    public partial class ");
#line 31 "ServiceServerTemplate.cshtml"
                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" + \"Controller\" : Controller\r\n    {\r\n        \r\n    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
