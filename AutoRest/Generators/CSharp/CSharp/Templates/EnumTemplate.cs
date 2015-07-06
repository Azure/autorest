// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Templates
{
#line 1 "EnumTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 2 "EnumTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 3 "EnumTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.TemplateModels

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class EnumTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.CSharp.EnumTemplateModel>
    {
        #line hidden
        public EnumTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 5 "EnumTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\nnamespace ");
#line 6 "EnumTemplate.cshtml"
      Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral(".Models\n{\n    using Newtonsoft.Json;\n    using Newtonsoft.Json.Converters;\n    us" +
"ing System.Runtime.Serialization;\n");
#line 11 "EnumTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n    /// <summary>\n    ");
#line 13 "EnumTemplate.cshtml"
Write(WrapComment("/// ", "Defines values for " + Model.TypeDefinitionName));

#line default
#line hidden
            WriteLiteral("\n    /// </summary>\n    [JsonConverter(typeof(StringEnumConverter))]\n    public e" +
"num ");
#line 16 "EnumTemplate.cshtml"
           Write(Model.TypeDefinitionName);

#line default
#line hidden
            WriteLiteral("\n    {\n");
#line 18 "EnumTemplate.cshtml"
        

#line default
#line hidden

#line 18 "EnumTemplate.cshtml"
         for (int i = 0; i < Model.Values.Count - 1; i++)
        {

#line default
#line hidden

            WriteLiteral("        [EnumMember(Value = \"");
#line 20 "EnumTemplate.cshtml"
                          Write(Model.Values[i].SerializedName);

#line default
#line hidden
            WriteLiteral("\")]\n        ");
#line 21 "EnumTemplate.cshtml"
      Write(Model.Values[i].Name);

#line default
#line hidden
            WriteLiteral(",\n");
#line 22 "EnumTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        [EnumMember(Value = \"");
#line 23 "EnumTemplate.cshtml"
                        Write(Model.Values.Last().SerializedName);

#line default
#line hidden
            WriteLiteral("\")]\n        ");
#line 24 "EnumTemplate.cshtml"
    Write(Model.Values.Last().Name);

#line default
#line hidden
            WriteLiteral("\n    }\n}\n");
        }
        #pragma warning restore 1998
    }
}
