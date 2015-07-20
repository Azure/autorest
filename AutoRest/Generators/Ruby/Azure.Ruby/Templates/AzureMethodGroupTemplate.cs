// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Azure.Ruby.Templates
{
#line 1 "AzureMethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.Azure.Ruby.Templates

#line default
#line hidden
    ;
#line 2 "AzureMethodGroupTemplate.cshtml"
using Microsoft.Rest.Generator.Azure.Ruby

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class AzureMethodGroupTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Azure.Ruby.AzureMethodGroupTemplateModel>
    {
        #line hidden
        public AzureMethodGroupTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 4 "AzureMethodGroupTemplate.cshtml"
Write(Header("# "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 5 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nmodule ");
#line 6 "AzureMethodGroupTemplate.cshtml"
  Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n  #\r\n");
#line 8 "AzureMethodGroupTemplate.cshtml"
Write(WrapComment("# ", string.IsNullOrEmpty(Model.Documentation) ? Model.MethodGroupName : Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n  #\r\n  class ");
#line 10 "AzureMethodGroupTemplate.cshtml"
    Write(Model.MethodGroupName);

#line default
#line hidden
            WriteLiteral("\r\n\r\n    #\r\n    # Creates and initializes a new instance of the ");
#line 13 "AzureMethodGroupTemplate.cshtml"
                                               Write(Model.MethodGroupName);

#line default
#line hidden
            WriteLiteral(" class.\r\n    # @param client service class for accessing basic functionality.\r\n  " +
"  #\r\n    def initialize(client)\r\n    @client = client\r\n    end\r\n\r\n    ");
#line 20 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    # @return reference to the ");
#line 21 "AzureMethodGroupTemplate.cshtml"
                            Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\r\n    attr_reader :client\r\n\r\n    ");
#line 24 "AzureMethodGroupTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 25 "AzureMethodGroupTemplate.cshtml"
    

#line default
#line hidden

#line 25 "AzureMethodGroupTemplate.cshtml"
     foreach (var method in Model.MethodTemplateModels)
    {

#line default
#line hidden

            WriteLiteral("        ");
#line 27 "AzureMethodGroupTemplate.cshtml"
      Write(Include(new AzureMethodTemplate(), method as AzureMethodTemplateModel));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 28 "AzureMethodGroupTemplate.cshtml"
        

#line default
#line hidden

#line 28 "AzureMethodGroupTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 28 "AzureMethodGroupTemplate.cshtml"
                  
    }

#line default
#line hidden

            WriteLiteral("    end\r\n    end\r\n");
        }
        #pragma warning restore 1998
    }
}
