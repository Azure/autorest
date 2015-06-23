// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Templates
{
#line 1 "MethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp

#line default
#line hidden
    ;
#line 2 "MethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class MethodGroupTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.CSharp.MethodGroupTemplateModel>
    {
        #line hidden
        public MethodGroupTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 4 "MethodGroupTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 5 "MethodGroupTemplate.cshtml"
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
    using Microsoft.Rest.Serialization;
    using Newtonsoft.Json;
");
#line 19 "MethodGroupTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 20 "MethodGroupTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 21 "MethodGroupTemplate.cshtml"
}

#line default
#line hidden

#line 22 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    internal partial class ");
#line 23 "MethodGroupTemplate.cshtml"
                       Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" : IServiceOperations<");
#line 23 "MethodGroupTemplate.cshtml"
                                                                     Write(Model.Name);

#line default
#line hidden
            WriteLiteral(">, I");
#line 23 "MethodGroupTemplate.cshtml"
                                                                                      Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 26 "MethodGroupTemplate.cshtml"
                                          Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral(" class.\r\n        /// </summary>\r\n        /// <param name=\'client\'>\r\n        /// R" +
"eference to the service client.\r\n        /// </param>\r\n        internal ");
#line 31 "MethodGroupTemplate.cshtml"
             Write(Model.MethodGroupType);

#line default
#line hidden
            WriteLiteral("(");
#line 31 "MethodGroupTemplate.cshtml"
                                      Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" client)\r\n        {\r\n            this.Client = client;\r\n        }\r\n        ");
#line 35 "MethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        /// <summary>\r\n        /// Gets a reference to the ");
#line 37 "MethodGroupTemplate.cshtml"
                                Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n        public ");
#line 39 "MethodGroupTemplate.cshtml"
           Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" Client { get; private set; }\r\n        ");
#line 40 "MethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 41 "MethodGroupTemplate.cshtml"
        

#line default
#line hidden

#line 41 "MethodGroupTemplate.cshtml"
         foreach (var method in Model.MethodTemplateModels)
        {

#line default
#line hidden

            WriteLiteral("        ");
#line 43 "MethodGroupTemplate.cshtml"
      Write(Include<MethodTemplate, MethodTemplateModel>(method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 44 "MethodGroupTemplate.cshtml"
        

#line default
#line hidden

#line 44 "MethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 44 "MethodGroupTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
