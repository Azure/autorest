// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Azure.NodeJS.Templates
{
#line 1 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS

#line default
#line hidden
    ;
#line 2 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.Templates

#line default
#line hidden
    ;
#line 3 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.NodeJS.TemplateModels

#line default
#line hidden
    ;
#line 4 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Azure.NodeJS

#line default
#line hidden
    ;
#line 5 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Azure.NodeJS.Templates

#line default
#line hidden
    ;
#line 6 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
#line 7 "AzureMethodTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 8 "AzureMethodTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class AzureMethodTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Azure.NodeJS.AzureMethodTemplateModel>
    {
        #line hidden
        public AzureMethodTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 11 "AzureMethodTemplate.cshtml"
 if (!Model.IsLongRunningOperation)
{

#line default
#line hidden

#line 13 "AzureMethodTemplate.cshtml"
Write(Include( new MethodTemplate(), Model as MethodTemplateModel));

#line default
#line hidden
            WriteLiteral("\n");
#line 14 "AzureMethodTemplate.cshtml"
}
else if (Model.HttpMethod == HttpMethod.Post || Model.HttpMethod == HttpMethod.Delete)
{

#line default
#line hidden

            WriteLiteral("\n/**\n *\n");
#line 20 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\n");
#line 21 "AzureMethodTemplate.cshtml"
 foreach (var parameter in Model.DocumentationParameters)
{

#line default
#line hidden

            WriteLiteral(" * @param {");
#line 23 "AzureMethodTemplate.cshtml"
         Write(parameter.Type.Name);

#line default
#line hidden
            WriteLiteral("} [");
#line 23 "AzureMethodTemplate.cshtml"
                                Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("] ");
#line 23 "AzureMethodTemplate.cshtml"
                                                 Write(parameter.Documentation);

#line default
#line hidden
            WriteLiteral("\n *\n");
#line 25 "AzureMethodTemplate.cshtml"
}

#line default
#line hidden

#line 26 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", " @param {function} callback"));

#line default
#line hidden
            WriteLiteral("\n *\n");
#line 28 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", " @returns {Stream} The Response stream"));

#line default
#line hidden
            WriteLiteral("\n */\n");
#line 30 "AzureMethodTemplate.cshtml"
Write(Model.OperationName);

#line default
#line hidden
            WriteLiteral(".prototype.");
#line 30 "AzureMethodTemplate.cshtml"
                             Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" = function (");
#line 30 "AzureMethodTemplate.cshtml"
                                                       Write(Model.MethodParameterDeclarationWithCallback);

#line default
#line hidden
            WriteLiteral(") {\n  var self = ");
#line 31 "AzureMethodTemplate.cshtml"
         Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(";\n\n  // Send request\n  this.begin");
#line 34 "AzureMethodTemplate.cshtml"
        Write(Model.Name.ToPascalCase());

#line default
#line hidden
            WriteLiteral("(");
#line 34 "AzureMethodTemplate.cshtml"
                                     Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral("function (err, result){\n    if (err) return callback(err);\n    self.getPostOrDele" +
"teOperationResult(result, callback);\n  });\n};\n\n");
#line 40 "AzureMethodTemplate.cshtml"
}
else if (Model.HttpMethod == HttpMethod.Put)
{

#line default
#line hidden

            WriteLiteral("\n/**\n *\n");
#line 46 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\n");
#line 47 "AzureMethodTemplate.cshtml"
 foreach (var parameter in Model.DocumentationParameters)
{

#line default
#line hidden

            WriteLiteral(" * @param {");
#line 49 "AzureMethodTemplate.cshtml"
         Write(parameter.Type.Name);

#line default
#line hidden
            WriteLiteral("} [");
#line 49 "AzureMethodTemplate.cshtml"
                                Write(parameter.Name);

#line default
#line hidden
            WriteLiteral("] ");
#line 49 "AzureMethodTemplate.cshtml"
                                                 Write(parameter.Documentation);

#line default
#line hidden
            WriteLiteral("\n *\n");
#line 51 "AzureMethodTemplate.cshtml"
}

#line default
#line hidden

#line 52 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", " @param {function} callback"));

#line default
#line hidden
            WriteLiteral("\n *\n");
#line 54 "AzureMethodTemplate.cshtml"
Write(WrapComment(" * ", " @returns {Stream} The Response stream"));

#line default
#line hidden
            WriteLiteral("\n */\n");
#line 56 "AzureMethodTemplate.cshtml"
Write(Model.OperationName);

#line default
#line hidden
            WriteLiteral(".prototype.");
#line 56 "AzureMethodTemplate.cshtml"
                             Write(Model.Name);

#line default
#line hidden
            WriteLiteral(" = function (");
#line 56 "AzureMethodTemplate.cshtml"
                                                       Write(Model.MethodParameterDeclarationWithCallback);

#line default
#line hidden
            WriteLiteral(") {\n  var client = ");
#line 57 "AzureMethodTemplate.cshtml"
           Write(Model.ClientReference);

#line default
#line hidden
            WriteLiteral(";\n  var self = this;\n  function getMethod() {\n    var cb = function (callback) {\n" +
"      return self.");
#line 61 "AzureMethodTemplate.cshtml"
              Write(Model.GetMethod.Name);

#line default
#line hidden
            WriteLiteral("(");
#line 61 "AzureMethodTemplate.cshtml"
                                      Write(Model.GetMethod.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral("callback);\n    };\n    return cb;\n  }\n  // Send request\n  self.begin");
#line 66 "AzureMethodTemplate.cshtml"
        Write(Model.Name.ToPascalCase());

#line default
#line hidden
            WriteLiteral("(");
#line 66 "AzureMethodTemplate.cshtml"
                                     Write(Model.MethodParameterDeclaration);

#line default
#line hidden
            WriteLiteral("function (err, result){\n    if (err) return callback(err);\n    client.getPutOpera" +
"tionResult(result, getMethod(), callback);\n  });\n};\n\n");
#line 72 "AzureMethodTemplate.cshtml"
}

#line default
#line hidden

        }
        #pragma warning restore 1998
    }
}
