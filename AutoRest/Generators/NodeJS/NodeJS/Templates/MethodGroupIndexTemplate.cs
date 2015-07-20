// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.NodeJS.Templates
{
#line 1 "MethodGroupIndexTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS

#line default
#line hidden
    ;
#line 2 "MethodGroupIndexTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.Templates

#line default
#line hidden
    ;
#line 3 "MethodGroupIndexTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
#line 4 "MethodGroupIndexTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class MethodGroupIndexTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.NodeJS.ServiceClientTemplateModel>
    {
        #line hidden
        public MethodGroupIndexTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 6 "MethodGroupIndexTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 7 "MethodGroupIndexTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n/* jshint latedef:false */\r\n/* jshint forin:false */\r\n/* jshint noempty:false *" +
"/\r\n");
#line 11 "MethodGroupIndexTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n\'use strict\';\r\n");
#line 13 "MethodGroupIndexTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 14 "MethodGroupIndexTemplate.cshtml"
 foreach (var methodGroup in Model.MethodGroupModels)
{

#line default
#line hidden

            WriteLiteral("exports.");
#line 16 "MethodGroupIndexTemplate.cshtml"
      Write(methodGroup.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" = require(\'./");
#line 16 "MethodGroupIndexTemplate.cshtml"
                                                  Write(methodGroup.MethodGroupType);

#line default
#line hidden
            WriteLiteral("\');\r\n");
#line 17 "MethodGroupIndexTemplate.cshtml"
}

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
