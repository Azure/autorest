// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "ServiceServerControllerTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 2 "ServiceServerControllerTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 3 "ServiceServerControllerTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
#line 4 "ServiceServerControllerTemplate.cshtml"
using AutoRest.CSharp.Model

#line default
#line hidden
    ;
#line 5 "ServiceServerControllerTemplate.cshtml"
using AutoRest.CSharp.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServiceServerControllerTemplate : AutoRest.Core.Template<CodeModelCs>
    {
        #line hidden
        public ServiceServerControllerTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 7 "ServiceServerControllerTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 8 "ServiceServerControllerTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nusing System;\r\nusing System.Collections.Generic;\r\nusing System.Linq;\r\nusing Sys" +
"tem.Threading.Tasks;\r\nusing Microsoft.AspNetCore.Mvc;\r\nusing Microsoft.Rest;\r\n\r\n" +
"namespace ");
#line 16 "ServiceServerControllerTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n    \r\n");
#line 19 "ServiceServerControllerTemplate.cshtml"
 foreach (var usingString in Model.Usings)
{

#line default
#line hidden

            WriteLiteral("    using ");
#line 21 "ServiceServerControllerTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 22 "ServiceServerControllerTemplate.cshtml"
}

#line default
#line hidden

#line 23 "ServiceServerControllerTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 24 "ServiceServerControllerTemplate.cshtml"
 if (!string.IsNullOrWhiteSpace(Model.Documentation))
{

#line default
#line hidden

            WriteLiteral("    /// <summary>\r\n    ");
#line 27 "ServiceServerControllerTemplate.cshtml"
 Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>`\r\n");
#line 29 "ServiceServerControllerTemplate.cshtml"
 }

#line default
#line hidden

            WriteLiteral("    [Route(\"");
#line 30 "ServiceServerControllerTemplate.cshtml"
       Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\")]\r\n    public partial class ");
#line 31 "ServiceServerControllerTemplate.cshtml"
                     Write(Model.Name+"Controller : Controller");

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n        \r\n        \r\n        \r\n");
#line 113 "ServiceServerControllerTemplate.cshtml"
    

#line default
#line hidden

#line 113 "ServiceServerControllerTemplate.cshtml"
     foreach (MethodCs method in Model.Methods.Where(m=>(m.MethodGroup.Name==Model.Name)))
    {

#line default
#line hidden

            WriteLiteral("        ");
#line 115 "ServiceServerControllerTemplate.cshtml"
      Write(Include(new ServerMethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 116 "ServiceServerControllerTemplate.cshtml"
        

#line default
#line hidden

#line 116 "ServiceServerControllerTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 116 "ServiceServerControllerTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 118 "ServiceServerControllerTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("        \r\n    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
