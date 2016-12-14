// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "ServerMethodTemplate.cshtml"
using System.Globalization

#line default
#line hidden
    ;
#line 2 "ServerMethodTemplate.cshtml"
using System.Linq;

#line default
#line hidden
#line 3 "ServerMethodTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 4 "ServerMethodTemplate.cshtml"
using AutoRest.Core.Model

#line default
#line hidden
    ;
#line 5 "ServerMethodTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
#line 6 "ServerMethodTemplate.cshtml"
using AutoRest.CSharp

#line default
#line hidden
    ;
#line 7 "ServerMethodTemplate.cshtml"
using AutoRest.CSharp.Model

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServerMethodTemplate : AutoRest.Core.Template<AutoRest.CSharp.Model.MethodCs>
    {
        #line hidden
        public ServerMethodTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
            WriteLiteral("\r\n");
#line 11 "ServerMethodTemplate.cshtml"
 if (!string.IsNullOrWhiteSpace(Model.Description) || !string.IsNullOrEmpty(Model.Summary))
{
}
 

#line default
#line hidden

#line 449 "ServerMethodTemplate.cshtml"
   

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
