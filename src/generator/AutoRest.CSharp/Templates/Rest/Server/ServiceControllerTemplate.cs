// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates.Rest.Server
{
#line 1 "ServiceControllerTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 2 "ServiceControllerTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 3 "ServiceControllerTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
#line 4 "ServiceControllerTemplate.cshtml"
using AutoRest.CSharp.Model

#line default
#line hidden
    ;
#line 5 "ServiceControllerTemplate.cshtml"
using AutoRest.CSharp.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServiceControllerTemplate : AutoRest.Core.Template<CodeModelCs>
    {
        #line hidden
        public ServiceControllerTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 7 "ServiceControllerTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 8 "ServiceControllerTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nusing System;\r\nusing System.Collections.Generic;\r\nusing System.Linq;\r\nusing Sys" +
"tem.Threading.Tasks;\r\nusing Microsoft.AspNetCore.Mvc;\r\nusing Microsoft.Rest;\r\n\r\n" +
"namespace ");
#line 16 "ServiceControllerTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n    \r\n");
#line 19 "ServiceControllerTemplate.cshtml"
 foreach (var usingString in Model.Usings)
{

#line default
#line hidden

            WriteLiteral("    using ");
#line 21 "ServiceControllerTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 22 "ServiceControllerTemplate.cshtml"
}

#line default
#line hidden

#line 23 "ServiceControllerTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 24 "ServiceControllerTemplate.cshtml"
 if (!string.IsNullOrWhiteSpace(Model.Documentation))
{

#line default
#line hidden

            WriteLiteral("    /// <summary>\r\n    ");
#line 27 "ServiceControllerTemplate.cshtml"
 Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>`\r\n");
#line 29 "ServiceControllerTemplate.cshtml"
 }

#line default
#line hidden

            WriteLiteral("    [Route(\"");
#line 30 "ServiceControllerTemplate.cshtml"
       Write(Model.BaseUrl);

#line default
#line hidden
            WriteLiteral("\")]\r\n    public partial class ");
#line 31 "ServiceControllerTemplate.cshtml"
                     Write(Model.Name+"Controller : Controller");

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n        \r\n");
#line 34 "ServiceControllerTemplate.cshtml"
    

#line default
#line hidden

#line 34 "ServiceControllerTemplate.cshtml"
     foreach (MethodCs method in Model.Methods.Where(m=>(m.MethodGroup.Name==Model.Name || m.MethodGroup.Name + "Operations" == Model.Name)))
    {

#line default
#line hidden

            WriteLiteral("        ");
#line 36 "ServiceControllerTemplate.cshtml"
      Write(Include(new ServiceMethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 37 "ServiceControllerTemplate.cshtml"
        

#line default
#line hidden

#line 37 "ServiceControllerTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 37 "ServiceControllerTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 39 "ServiceControllerTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("        \r\n    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
