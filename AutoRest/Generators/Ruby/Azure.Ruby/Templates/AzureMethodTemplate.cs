// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Azure.Ruby.Templates
{
#line 1 "AzureMethodTemplate.cshtml"
using System.Linq;

#line default
#line hidden
#line 2 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 3 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby

#line default
#line hidden
    ;
#line 4 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby.TemplateModels

#line default
#line hidden
    ;
#line 5 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class AzureMethodTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Azure.Ruby.AzureMethodTemplateModel>
    {
        #line hidden
        public AzureMethodTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 8 "AzureMethodTemplate.cshtml"
 if (!Model.IsLongRunningOperation)
{

#line default
#line hidden

            WriteLiteral("    ");
#line 10 "AzureMethodTemplate.cshtml"
      Write(Include(new MethodTemplate(), (MethodTemplateModel)Model));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 11 "AzureMethodTemplate.cshtml"
}
else if (Model.HttpMethod == HttpMethod.Post || Model.HttpMethod == HttpMethod.Delete)
{

#line default
#line hidden

            WriteLiteral("    \r\n    #\r\n    # ");
#line 16 "AzureMethodTemplate.cshtml"
 Write(WrapComment("# ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 17 "AzureMethodTemplate.cshtml"
    

#line default
#line hidden

#line 17 "AzureMethodTemplate.cshtml"
     foreach (var parameter in Model.Parameters)
    {

#line default
#line hidden

            WriteLiteral("        ");
#line 19 "AzureMethodTemplate.cshtml"
     Write(WrapComment("# ", string.Format("@param {0} {1}{2}", parameter.Name, parameter.Type.GetYardDocumentation(), parameter.Documentation)));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 20 "AzureMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 21 "AzureMethodTemplate.cshtml"
Write(WrapComment("# ", string.Format("@return [{0}] TODO: add text", "TODO: add type")));

#line default
#line hidden
            WriteLiteral("\r\n    #\r\n    def ");
#line 23 "AzureMethodTemplate.cshtml"
    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 23 "AzureMethodTemplate.cshtml"
                  Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(")\r\n      // Send request\r\n      response = begin");
#line 25 "AzureMethodTemplate.cshtml"
                  Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 25 "AzureMethodTemplate.cshtml"
                                Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(").value!\r\n      return ");
#line 26 "AzureMethodTemplate.cshtml"
         Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".get_post_or_delete_operation_result_async(response).value!\r\n    end\r\n    \r\n");
#line 29 "AzureMethodTemplate.cshtml"
}
else
{

#line default
#line hidden

            WriteLiteral("    \r\n    #\r\n    # ");
#line 34 "AzureMethodTemplate.cshtml"
 Write(WrapComment("# ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 35 "AzureMethodTemplate.cshtml"
    

#line default
#line hidden

#line 35 "AzureMethodTemplate.cshtml"
     foreach (var parameter in Model.Parameters)
    {

#line default
#line hidden

            WriteLiteral("      ");
#line 37 "AzureMethodTemplate.cshtml"
   Write(WrapComment("# ", string.Format("@param {0} {1}{2}", parameter.Name, parameter.Type.GetYardDocumentation(), parameter.Documentation)));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 38 "AzureMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 39 "AzureMethodTemplate.cshtml"
Write(WrapComment("# ", string.Format("@return [{0}] TODO: add text", "TODO: add type")));

#line default
#line hidden
            WriteLiteral("\r\n    #\r\n    def ");
#line 41 "AzureMethodTemplate.cshtml"
    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 41 "AzureMethodTemplate.cshtml"
                  Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(")\r\n      # Send request\r\n      response = begin_");
#line 43 "AzureMethodTemplate.cshtml"
                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 43 "AzureMethodTemplate.cshtml"
                                 Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(").value!\r\n\r\n      # Defining polling method.\r\n      get_method = lambda { self.");
#line 46 "AzureMethodTemplate.cshtml"
                             Write(Model.GetMethod.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 46 "AzureMethodTemplate.cshtml"
                                                     Write(Model.GetMethod.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(") }\r\n\r\n      # Waiting for response.\r\n      return ");
#line 49 "AzureMethodTemplate.cshtml"
         Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".get_put_operation_result_async(response, get_method).value!\r\n    end\r\n    \r\n");
#line 52 "AzureMethodTemplate.cshtml"
}

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
