// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Ruby.Templates
{
#line 1 "OperationsTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby

#line default
#line hidden
    ;
#line 2 "OperationsTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class OperationsTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Ruby.OperationsTemplateModel>
    {
        #line hidden
        public OperationsTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 4 "OperationsTemplate.cshtml"
Write(Header("# "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 5 "OperationsTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nmodule ");
#line 6 "OperationsTemplate.cshtml"
  Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n  #\r\n  ");
#line 8 "OperationsTemplate.cshtml"
Write(WrapComment("# ", string.IsNullOrEmpty(Model.Documentation) ? Model.OperationName : Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n  #\r\n  class ");
#line 10 "OperationsTemplate.cshtml"
    Write(Model.OperationName);

#line default
#line hidden
            WriteLiteral("\r\n\r\n    #\r\n    # Creates and initializes a new instance of the ");
#line 13 "OperationsTemplate.cshtml"
                                               Write(Model.OperationName);

#line default
#line hidden
            WriteLiteral(" class.\r\n    # @param client service class for accessing basic functionality.\r\n  " +
"  #\r\n    def initialize(client)\r\n        @client = client\r\n    end\r\n\r\n    ");
#line 20 "OperationsTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    # @return reference to the ");
#line 21 "OperationsTemplate.cshtml"
                            Write(Model.Name);

#line default
#line hidden
            WriteLiteral("\r\n    attr_reader :client\r\n\r\n    ");
#line 24 "OperationsTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 25 "OperationsTemplate.cshtml"
    

#line default
#line hidden

#line 25 "OperationsTemplate.cshtml"
     foreach (var method in Model.MethodTemplateModels)
    {

#line default
#line hidden

            WriteLiteral("    ");
#line 27 "OperationsTemplate.cshtml"
  Write(Include( new MethodTemplate(),method));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 28 "OperationsTemplate.cshtml"
    

#line default
#line hidden

#line 28 "OperationsTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
#line 28 "OperationsTemplate.cshtml"
              
    }

#line default
#line hidden

            WriteLiteral("  end\r\nend\r\n");
        }
        #pragma warning restore 1998
    }
}
