// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Ruby.Templates
{
#line 1 "MethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby

#line default
#line hidden
    ;
#line 2 "MethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class MethodGroupTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Ruby.MethodGroupTemplateModel>
    {
        #line hidden
        public MethodGroupTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 4 "MethodGroupTemplate.cshtml"
Write(Header("# "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 5 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nmodule ");
#line 6 "MethodGroupTemplate.cshtml"
  Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n  #\r\n  ");
#line 8 "MethodGroupTemplate.cshtml"
Write(WrapComment("# ", string.IsNullOrEmpty(Model.Documentation) ? Model.MethodGroupName : Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n  #\r\n  class ");
#line 10 "MethodGroupTemplate.cshtml"
    Write(Model.MethodGroupName);

#line default
#line hidden
            WriteLiteral("\r\n\r\n    #\r\n    # Creates and initializes a new instance of the ");
#line 13 "MethodGroupTemplate.cshtml"
                                               Write(Model.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" class.\r\n    # @param client service class for accessing basic functionality.\r\n  " +
"  #\r\n    def initialize(client)\r\n        @client = client\r\n    end\r\n\r\n    ");
#line 20 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    # @return reference to the ");
#line 21 "MethodGroupTemplate.cshtml"
                            Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\r\n    attr_reader :client\r\n\r\n    ");
#line 24 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 25 "MethodGroupTemplate.cshtml"
    

#line default
#line hidden

#line 25 "MethodGroupTemplate.cshtml"
     foreach (var method in Model.MethodTemplateModels)
    {

#line default
#line hidden

            WriteLiteral("    ");
#line 27 "MethodGroupTemplate.cshtml"
  Write(Include(new MethodTemplate(), method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 28 "MethodGroupTemplate.cshtml"
    

#line default
#line hidden

#line 28 "MethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 28 "MethodGroupTemplate.cshtml"
              
    }

#line default
#line hidden

            WriteLiteral("  end\r\nend\r\n");
        }
        #pragma warning restore 1998
    }
}
