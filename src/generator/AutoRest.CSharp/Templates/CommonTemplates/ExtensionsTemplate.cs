// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "ExtensionsTemplate.cshtml"
using System.Text

#line default
#line hidden
    ;
#line 2 "ExtensionsTemplate.cshtml"
using AutoRest.CSharp.Model

#line default
#line hidden
    ;
#line 3 "ExtensionsTemplate.cshtml"
using AutoRest.CSharp.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ExtensionsTemplate : AutoRest.Core.Template<AutoRest.CSharp.Model.MethodGroupCs>
    {
        #line hidden
        public ExtensionsTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 5 "ExtensionsTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 6 "ExtensionsTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 7 "ExtensionsTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n    using System.Threading.Tasks;\r\n");
#line 10 "ExtensionsTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 11 "ExtensionsTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 12 "ExtensionsTemplate.cshtml"
}

#line default
#line hidden

#line 13 "ExtensionsTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    /// Extension methods for ");
#line 15 "ExtensionsTemplate.cshtml"
                          Write(Model.ExtensionTypeName);

#line default
#line hidden
            WriteLiteral(".\r\n    /// </summary>\r\n    public static partial class ");
#line 17 "ExtensionsTemplate.cshtml"
                            Write(Model.ExtensionTypeName);

#line default
#line hidden
            WriteLiteral("Extensions\r\n    {\r\n");
#line 19 "ExtensionsTemplate.cshtml"
        

#line default
#line hidden

#line 19 "ExtensionsTemplate.cshtml"
         foreach (MethodCs method in Model.Methods)
        {

#line default
#line hidden

            WriteLiteral("            ");
#line 21 "ExtensionsTemplate.cshtml"
          Write(Include(new ExtensionMethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 22 "ExtensionsTemplate.cshtml"
            

#line default
#line hidden

#line 22 "ExtensionsTemplate.cshtml"
       Write(EmptyLine);

#line default
#line hidden
#line 22 "ExtensionsTemplate.cshtml"
                       
        }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
