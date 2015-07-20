// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Templates
{
#line 1 "ExtensionsTemplate.cshtml"
using System.Text

#line default
#line hidden
    ;
#line 2 "ExtensionsTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp

#line default
#line hidden
    ;
#line 3 "ExtensionsTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Templates

#line default
#line hidden
    ;
#line 4 "ExtensionsTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.TemplateModels

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ExtensionsTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.CSharp.ExtensionsTemplateModel>
    {
        #line hidden
        public ExtensionsTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 6 "ExtensionsTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 7 "ExtensionsTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n    using System;\r\n    using System.Collections;\r\n    using System.Collectio" +
"ns.Generic;\r\n    using System.Threading;\r\n    using System.Threading.Tasks;\r\n   " +
" using Microsoft.Rest;\r\n");
#line 15 "ExtensionsTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 16 "ExtensionsTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 17 "ExtensionsTemplate.cshtml"
}

#line default
#line hidden

#line 18 "ExtensionsTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    public static partial class ");
#line 19 "ExtensionsTemplate.cshtml"
                            Write(Model.ExtensionName);

#line default
#line hidden
            WriteLiteral("Extensions\r\n    {\r\n");
#line 21 "ExtensionsTemplate.cshtml"
        

#line default
#line hidden

#line 21 "ExtensionsTemplate.cshtml"
         foreach (var method in Model.MethodTemplateModels)
        {

#line default
#line hidden

            WriteLiteral("            ");
#line 23 "ExtensionsTemplate.cshtml"
          Write(Include(new ExtensionMethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 24 "ExtensionsTemplate.cshtml"
            

#line default
#line hidden

#line 24 "ExtensionsTemplate.cshtml"
       Write(EmptyLine);

#line default
#line hidden
#line 24 "ExtensionsTemplate.cshtml"
                       
        }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
