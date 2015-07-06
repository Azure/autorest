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
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\nnamespace ");
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
            WriteLiteral(";\n");
#line 22 "AzureMethodGroupTemplate.cshtml"
}

#line default
#line hidden

#line 23 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n    internal partial class ");
#line 24 "AzureMethodGroupTemplate.cshtml"
                       Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" : IServiceOperations<");
#line 24 "AzureMethodGroupTemplate.cshtml"
                                                                     Write(Model.Name);

#line default
#line hidden
            WriteLiteral(">, I");
#line 24 "AzureMethodGroupTemplate.cshtml"
                                                                                      Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("\n    {\n        /// <summary>\n        /// Initializes a new instance of the ");
#line 27 "AzureMethodGroupTemplate.cshtml"
                                          Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" class.\n        /// </summary>\n        /// <param name=\'client\'>\n        /// Refe" +
"rence to the service client.\n        /// </param>\n        internal ");
#line 32 "AzureMethodGroupTemplate.cshtml"
             Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(");
#line 32 "AzureMethodGroupTemplate.cshtml"
                                      Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" client)\n        {\n            this.Client = client;\n        }\n        ");
#line 36 "AzureMethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n        /// <summary>\n        /// Gets a reference to the ");
#line 38 "AzureMethodGroupTemplate.cshtml"
                                Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\n        /// </summary>\n        public ");
#line 40 "AzureMethodGroupTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" Client { get; private set; }\n        ");
#line 41 "AzureMethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n");
#line 42 "AzureMethodGroupTemplate.cshtml"
        

#line default
#line hidden

#line 42 "AzureMethodGroupTemplate.cshtml"
         foreach (var method in Model.MethodTemplateModels)
        {

#line default
#line hidden

            WriteLiteral("        ");
#line 44 "AzureMethodGroupTemplate.cshtml"
      Write(Include(new AzureMethodTemplate(), (AzureMethodTemplateModel)method));

#line default
#line hidden
            WriteLiteral("\n");
#line 45 "AzureMethodGroupTemplate.cshtml"
        

#line default
#line hidden

#line 45 "AzureMethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 45 "AzureMethodGroupTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("    }\n}\n");
        }
        #pragma warning restore 1998
    }
}
