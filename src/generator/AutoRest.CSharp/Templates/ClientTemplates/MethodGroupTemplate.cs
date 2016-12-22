// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Templates
{
#line 1 "MethodGroupTemplate.cshtml"
using AutoRest.CSharp.Model

#line default
#line hidden
    ;
#line 2 "MethodGroupTemplate.cshtml"
using AutoRest.CSharp.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class MethodGroupTemplate : AutoRest.Core.Template<AutoRest.CSharp.Model.MethodGroupCs>
    {
        #line hidden
        public MethodGroupTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 4 "MethodGroupTemplate.cshtml"
Write(Header("// "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 5 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 6 "MethodGroupTemplate.cshtml"
     Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n{\r\n    using System.IO;\r\n    using Microsoft.Rest;\r\n");
#line 10 "MethodGroupTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 11 "MethodGroupTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 12 "MethodGroupTemplate.cshtml"
}

#line default
#line hidden

#line 13 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    /// ");
#line 15 "MethodGroupTemplate.cshtml"
    Write(Model.TypeName);

#line default
#line hidden
            WriteLiteral(" operations.\r\n    /// </summary>\r\n    public partial class ");
#line 17 "MethodGroupTemplate.cshtml"
                     Write(Model.TypeName);

#line default
#line hidden
            WriteLiteral(" : Microsoft.Rest.IServiceOperations<");
#line 17 "MethodGroupTemplate.cshtml"
                                                                          Write(Model.CodeModel.Name);

#line default
#line hidden
            WriteLiteral(">, I");
#line 17 "MethodGroupTemplate.cshtml"
                                                                                                    Write(Model.TypeName);

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n        /// <summary>\r\n        /// Initializes a new instance of the ");
#line 20 "MethodGroupTemplate.cshtml"
                                          Write(Model.TypeName);

#line default
#line hidden
            WriteLiteral(@" class.
        /// </summary>
        /// <param name='client'>
        /// Reference to the service client.
        /// </param>
        /// <exception cref=""System.ArgumentNullException"">
        /// Thrown when a required parameter is null
        /// </exception>
        public ");
#line 28 "MethodGroupTemplate.cshtml"
           Write(Model.TypeName);

#line default
#line hidden
            WriteLiteral("(");
#line 28 "MethodGroupTemplate.cshtml"
                            Write(Model.CodeModel.Name);

#line default
#line hidden
            WriteLiteral(" client)\r\n        {\r\n            if (client == null) \r\n            {\r\n           " +
"     throw new System.ArgumentNullException(\"client\");\r\n            }\r\n         " +
"   this.Client = client;\r\n        }\r\n        ");
#line 36 "MethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n        /// <summary>\r\n        /// Gets a reference to the ");
#line 38 "MethodGroupTemplate.cshtml"
                               Write(Model.CodeModel.Name);

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n        public ");
#line 40 "MethodGroupTemplate.cshtml"
          Write(Model.CodeModel.Name);

#line default
#line hidden
            WriteLiteral(" Client { get; private set; }\r\n        ");
#line 41 "MethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 42 "MethodGroupTemplate.cshtml"
        

#line default
#line hidden

#line 42 "MethodGroupTemplate.cshtml"
         foreach (MethodCs method in Model.Methods)
        {

#line default
#line hidden

            WriteLiteral("        ");
#line 44 "MethodGroupTemplate.cshtml"
      Write(Include(new MethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 45 "MethodGroupTemplate.cshtml"
        

#line default
#line hidden

#line 45 "MethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 45 "MethodGroupTemplate.cshtml"
                  
        }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
