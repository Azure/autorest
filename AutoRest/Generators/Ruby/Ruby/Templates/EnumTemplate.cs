// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Ruby.Templates
{
    using System.Threading.Tasks;

    public class EnumTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Ruby.EnumTemplateModel>
    {
        #line hidden
        public EnumTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 2 "EnumTemplate.cshtml"
Write(Header("# "));

#line default
#line hidden
            WriteLiteral("\r\n");
#line 3 "EnumTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\nmodule ");
#line 4 "EnumTemplate.cshtml"
  Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\r\n  #\r\n  ");
#line 6 "EnumTemplate.cshtml"
Write(WrapComment("# ", "Defines values for " + Model.TypeDefinitionName));

#line default
#line hidden
            WriteLiteral("\r\n  #\r\n  module ");
#line 8 "EnumTemplate.cshtml"
     Write(Model.TypeDefinitionName);

#line default
#line hidden
            WriteLiteral("\r\n");
#line 9 "EnumTemplate.cshtml"
    

#line default
#line hidden

#line 9 "EnumTemplate.cshtml"
     for (int i = 0; i < Model.Values.Count; i++)
    {

#line default
#line hidden

            WriteLiteral("    ");
#line 11 "EnumTemplate.cshtml"
  Write(Model.Values[i].SerializedName);

#line default
#line hidden
            WriteLiteral(" = \"");
#line 11 "EnumTemplate.cshtml"
                                       Write(Model.Values[i].Name);

#line default
#line hidden
            WriteLiteral("\"\r\n");
#line 12 "EnumTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("  end\r\nend\r\n");
        }
        #pragma warning restore 1998
    }
}
