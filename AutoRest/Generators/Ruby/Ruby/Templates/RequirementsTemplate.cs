// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Ruby.Templates
{
#line 1 "RequirementsTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby

#line default
#line hidden
    ;
#line 2 "RequirementsTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby.Templates

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class RequirementsTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Ruby.RequirementsTemplateModel>
    {
        #line hidden
        public RequirementsTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 4 "RequirementsTemplate.cshtml"
Write(Header("# "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 5 "RequirementsTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nrequire \'uri\'\r\nrequire \'cgi\'\r\nrequire \'date\'\r\nrequire \'json\'\r\nrequire \'base64\'\r" +
"\nrequire \'securerandom\'\r\nrequire \'time\'\r\nrequire \'timeliness\'\r\nrequire \'duration" +
"\'\r\nrequire \'concurrent\'\r\nrequire \'client_runtime\'\r\n");
#line 17 "RequirementsTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 18 "RequirementsTemplate.cshtml"
Write(Model.GetModelsRequiredFiles());

#line default
#line hidden
            WriteLiteral("\r\n");
#line 19 "RequirementsTemplate.cshtml"
Write(Model.GetOperationsRequiredFiles());

#line default
#line hidden
            WriteLiteral("\r\n");
#line 20 "RequirementsTemplate.cshtml"
Write(Model.GetClientRequiredFile());

#line default
#line hidden
            WriteLiteral("\r\n");
        }
        #pragma warning restore 1998
    }
}
