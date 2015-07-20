// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Azure.Ruby.Templates
{
#line 1 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 2 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby

#line default
#line hidden
    ;
#line 3 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby.TemplateModels

#line default
#line hidden
    ;
#line 4 "AzureMethodTemplate.cshtml"
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
#line 7 "AzureMethodTemplate.cshtml"
 if (!Model.IsLongRunningOperation)
{

#line default
#line hidden

            WriteLiteral("    ");
#line 9 "AzureMethodTemplate.cshtml"
  Write(Include(new MethodTemplate(), (MethodTemplateModel)Model));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 10 "AzureMethodTemplate.cshtml"
}
else if (Model.HttpMethod == HttpMethod.Post || Model.HttpMethod == HttpMethod.Delete)
{

#line default
#line hidden

            WriteLiteral("    \r\n    #\r\n    # ");
#line 15 "AzureMethodTemplate.cshtml"
 Write(WrapComment("# ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 16 "AzureMethodTemplate.cshtml"
    

#line default
#line hidden

#line 16 "AzureMethodTemplate.cshtml"
     foreach (var parameter in Model.Parameters)
    {

#line default
#line hidden

            WriteLiteral("        ");
#line 18 "AzureMethodTemplate.cshtml"
     Write(WrapComment("# ", string.Format("@param {0} {1}{2}", parameter.Name, parameter.Type.GetYardDocumentation(), parameter.Documentation)));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 19 "AzureMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 20 "AzureMethodTemplate.cshtml"
Write(WrapComment("# ", string.Format("@return [{0}] TODO: add text", "TODO: add type")));

#line default
#line hidden
            WriteLiteral("\r\n    #\r\n    def ");
#line 22 "AzureMethodTemplate.cshtml"
    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 22 "AzureMethodTemplate.cshtml"
                  Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(")\r\n      # Send request\r\n      response = begin_");
#line 24 "AzureMethodTemplate.cshtml"
                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 24 "AzureMethodTemplate.cshtml"
                                 Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(").value!\r\n      ");
#line 25 "AzureMethodTemplate.cshtml"
 Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n      # Defining deserialization method.\r\n      deserialize_method = lambda do " +
"|parsed_response|\r\n        ");
#line 28 "AzureMethodTemplate.cshtml"
    Write(Model.DeserializePollingResponse("parsed_response", Model.ReturnType, false, Settings.Namespace));

#line default
#line hidden
            WriteLiteral("\r\n      end\r\n      ");
#line 30 "AzureMethodTemplate.cshtml"
 Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n      # Waiting for response.\r\n      return ");
#line 32 "AzureMethodTemplate.cshtml"
         Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".get_post_or_delete_operation_result(response, nil, deserialize_method)\r\n    end\r" +
"\n    \r\n");
#line 35 "AzureMethodTemplate.cshtml"
}
else
{

#line default
#line hidden

            WriteLiteral("    \r\n    #\r\n    # ");
#line 40 "AzureMethodTemplate.cshtml"
 Write(WrapComment("# ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 41 "AzureMethodTemplate.cshtml"
    

#line default
#line hidden

#line 41 "AzureMethodTemplate.cshtml"
     foreach (var parameter in Model.Parameters)
    {

#line default
#line hidden

            WriteLiteral("      ");
#line 43 "AzureMethodTemplate.cshtml"
   Write(WrapComment("# ", string.Format("@param {0} {1}{2}", parameter.Name, parameter.Type.GetYardDocumentation(), parameter.Documentation)));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 44 "AzureMethodTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    ");
#line 45 "AzureMethodTemplate.cshtml"
Write(WrapComment("# ", string.Format("@return [{0}] TODO: add text", "TODO: add type")));

#line default
#line hidden
            WriteLiteral("\r\n    #\r\n    def ");
#line 47 "AzureMethodTemplate.cshtml"
    Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 47 "AzureMethodTemplate.cshtml"
                  Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(")\r\n      # Send request\r\n      response = begin_");
#line 49 "AzureMethodTemplate.cshtml"
                   Write(Model.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 49 "AzureMethodTemplate.cshtml"
                                 Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(").value!\r\n      ");
#line 50 "AzureMethodTemplate.cshtml"
 Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n      # Defining polling method.\r\n      get_method = lambda { self.");
#line 52 "AzureMethodTemplate.cshtml"
                             Write(Model.GetMethod.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 52 "AzureMethodTemplate.cshtml"
                                                     Write(Model.GetMethod.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral(") }\r\n      ");
#line 53 "AzureMethodTemplate.cshtml"
 Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n      # Defining deserialization method.\r\n      deserialize_method = lambda do " +
"|parsed_response|\r\n        ");
#line 56 "AzureMethodTemplate.cshtml"
    Write(Model.DeserializePollingResponse("parsed_response", Model.ReturnType, false, Settings.Namespace));

#line default
#line hidden
            WriteLiteral("\r\n      end\r\n      ");
#line 58 "AzureMethodTemplate.cshtml"
 Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n      # Waiting for response.\r\n      return ");
#line 60 "AzureMethodTemplate.cshtml"
         Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(".get_put_operation_result(response, get_method, nil, deserialize_method)\r\n    end" +
"\r\n    \r\n");
#line 63 "AzureMethodTemplate.cshtml"
}

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
