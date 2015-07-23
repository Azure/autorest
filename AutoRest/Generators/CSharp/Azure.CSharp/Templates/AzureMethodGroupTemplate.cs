// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Azure.Templates
{
#line 1 "AzureMethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp

#line default
#line hidden
    ;
#line 2 "AzureMethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Templates

#line default
#line hidden
    ;
#line 3 "AzureMethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Azure

#line default
#line hidden
    ;
#line 4 "AzureMethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Azure.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class AzureMethodGroupTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.CSharp.Azure.AzureMethodGroupTemplateModel>
    {
        #line hidden
        public AzureMethodGroupTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 6 "AzureMethodGroupTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 7 "AzureMethodGroupTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral(@"
{
    using System;
    using System.Collections.Generic;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Newtonsoft.Json;
");
#line 20 "AzureMethodGroupTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 21 "AzureMethodGroupTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 22 "AzureMethodGroupTemplate.cshtml"
}

#line default
#line hidden

#line 23 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    /// ");
#line 25 "AzureMethodGroupTemplate.cshtml"
    Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" operations.\r\n    /// </summary>\r\n    internal partial class ");
#line 27 "AzureMethodGroupTemplate.cshtml"
                       Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" : IServiceOperations<");
#line 27 "AzureMethodGroupTemplate.cshtml"
                                                                     Write(Model.Name);

#line default
#line hidden
            WriteLiteral(">, I");
#line 27 "AzureMethodGroupTemplate.cshtml"
                                                                                      Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 30 "AzureMethodGroupTemplate.cshtml"
                                          Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        /// <param name=\'client\'>\r\n        /// R" +
"eference to the service client.\r\n        /// </param>\r\n        internal ");
#line 35 "AzureMethodGroupTemplate.cshtml"
             Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(");
#line 35 "AzureMethodGroupTemplate.cshtml"
                                      Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" client)\r\n        {\r\n            this.Client = client;\r\n        }\r\n        ");
#line 39 "AzureMethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        /// <summary>\r\n        /// Gets a reference to the ");
#line 41 "AzureMethodGroupTemplate.cshtml"
                                Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n        public ");
#line 43 "AzureMethodGroupTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" Client { get; private set; }\r\n        ");
#line 44 "AzureMethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 45 "AzureMethodGroupTemplate.cshtml"
        

#line default
#line hidden

#line 45 "AzureMethodGroupTemplate.cshtml"
         foreach (var method in Model.MethodTemplateModels)
        {

#line default
#line hidden

            WriteLiteral("        ");
#line 47 "AzureMethodGroupTemplate.cshtml"
      Write(Include(new AzureMethodTemplate(), (AzureMethodTemplateModel)method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 48 "AzureMethodGroupTemplate.cshtml"
        

#line default
#line hidden

#line 48 "AzureMethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 48 "AzureMethodGroupTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
