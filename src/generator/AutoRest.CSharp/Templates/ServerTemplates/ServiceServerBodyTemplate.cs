// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "ServiceServerBodyTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 2 "ServiceServerBodyTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 3 "ServiceServerBodyTemplate.cshtml"
using AutoRest.Core.Model

#line default
#line hidden
    ;
#line 4 "ServiceServerBodyTemplate.cshtml"
using AutoRest.Core.Utilities

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ServiceServerBodyTemplate : AutoRest.Core.Template<AutoRest.CSharp.Model.CodeModelCs>
    {
        #line hidden
        public ServiceServerBodyTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
            WriteLiteral("\r\n/// <summary>\r\n    /// The base URI of the service.\r\n    ///\r\n</summary>\r\n");
#line 12 "ServiceServerBodyTemplate.cshtml"
 if (Model.IsCustomBaseUri)
{

#line default
#line hidden

            WriteLiteral("    internal string BaseUri {get; set;}\r\n");
#line 15 "ServiceServerBodyTemplate.cshtml"
}
else
{

#line default
#line hidden

            WriteLiteral("    public System.Uri BaseUri { get; set; }\r\n");
#line 19 "ServiceServerBodyTemplate.cshtml"
}

#line default
#line hidden

#line 20 "ServiceServerBodyTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
        }
        #pragma warning restore 1998
    }
}
