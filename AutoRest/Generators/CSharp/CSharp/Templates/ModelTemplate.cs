// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.CSharp.Templates
{
#line 1 "ModelTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 2 "ModelTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 3 "ModelTemplate.cshtml"
using Microsoft.Rest.Generator.CSharp.TemplateModels

#line default
#line hidden
    ;
#line 4 "ModelTemplate.cshtml"
using Microsoft.Rest.Generator.Utilities

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ModelTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.CSharp.ModelTemplateModel>
    {
        #line hidden
        public ModelTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 6 "ModelTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 7 "ModelTemplate.cshtml"
      Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral(".Models\r\n{\r\n    using System;\r\n    using System.Collections.Generic;\r\n    using N" +
"ewtonsoft.Json;\r\n    using Microsoft.Rest;\r\n    using Microsoft.Rest.Serializati" +
"on;\r\n");
#line 14 "ModelTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 15 "ModelTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 16 "ModelTemplate.cshtml"
}

#line default
#line hidden

#line 17 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    ");
#line 19 "ModelTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n");
#line 21 "ModelTemplate.cshtml"
    

#line default
#line hidden

#line 21 "ModelTemplate.cshtml"
     if (Model.NeedsPolymorphicConverter)
    {

#line default
#line hidden

            WriteLiteral("    [JsonObject(\"");
#line 23 "ModelTemplate.cshtml"
              Write(Model.SerializedName);

#line default
#line hidden
            WriteLiteral("\")]    \r\n");
#line 24 "ModelTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    public partial class ");
#line 25 "ModelTemplate.cshtml"
                    Write(Model.Name);

#line default
#line hidden
#line 25 "ModelTemplate.cshtml"
                                Write(Model.BaseModelType != null ? " : " + Model.BaseModelType.Name : "");

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n");
#line 27 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 27 "ModelTemplate.cshtml"
         foreach (var property in Model.PropertyTemplateModels)
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 30 "ModelTemplate.cshtml"
     Write(WrapComment("/// ", property.Documentation.EscapeXmlComment()));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n");
#line 32 "ModelTemplate.cshtml"
            if (property.Type == PrimaryType.Date)
            {

#line default
#line hidden

            WriteLiteral("        [JsonConverter(typeof(DateJsonConverter))]\r\n");
#line 35 "ModelTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("        [JsonProperty(PropertyName = \"");
#line 36 "ModelTemplate.cshtml"
                                   Write(property.SerializedName);

#line default
#line hidden
            WriteLiteral("\")]\r\n        public ");
#line 37 "ModelTemplate.cshtml"
            Write(property.Type.Name);

#line default
#line hidden
            WriteLiteral(" ");
#line 37 "ModelTemplate.cshtml"
                                Write(property.Name);

#line default
#line hidden
            WriteLiteral(" { get; ");
#line 37 "ModelTemplate.cshtml"
                                                       Write(property.IsReadOnly ? "private " : "");

#line default
#line hidden
            WriteLiteral("set; }\r\n");
#line 38 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 38 "ModelTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 38 "ModelTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 40 "ModelTemplate.cshtml"
        }

#line default
#line hidden

#line 41 "ModelTemplate.cshtml"
 if(@Model.ShouldValidateChain()) 
{   

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        /// Validate the object. Throws ArgumentException " +
"or ArgumentNullException if validation fails.\r\n        /// </summary>\r\n        p" +
"ublic ");
#line 46 "ModelTemplate.cshtml"
            Write(Model.MethodQualifier);

#line default
#line hidden
            WriteLiteral(" void Validate()\r\n        {\r\n");
#line 48 "ModelTemplate.cshtml"
            bool anythingToValidate = false;

            if (Model.BaseModelType != null && Model.BaseModelType.ShouldValidateChain())
            {
                anythingToValidate = true;

#line default
#line hidden

            WriteLiteral("            base.Validate();\r\n");
#line 54 "ModelTemplate.cshtml"
            }
            
            foreach (var property in Model.Properties.Where(p => p.IsRequired && !p.IsReadOnly))
            {
                anythingToValidate = true;

#line default
#line hidden

            WriteLiteral("            if (");
#line 59 "ModelTemplate.cshtml"
             Write(property.Name);

#line default
#line hidden
            WriteLiteral(" == null)\r\n            {\r\n                throw new ValidationException(Validatio" +
"nRules.CannotBeNull, \"");
#line 61 "ModelTemplate.cshtml"
                                                                          Write(property.Name);

#line default
#line hidden
            WriteLiteral("\");\r\n            }\r\n            \r\n");
#line 64 "ModelTemplate.cshtml"
            }
            foreach (var property in Model.Properties.Where(p => !(p.Type is PrimaryType)))
            {
                anythingToValidate = true;

#line default
#line hidden

            WriteLiteral("            ");
#line 68 "ModelTemplate.cshtml"
         Write(property.Type.ValidateType(Model.Scope, string.Format("this.{0}", property.Name)));

#line default
#line hidden
            WriteLiteral("\r\n            \r\n");
#line 70 "ModelTemplate.cshtml"
            }
            if (!anythingToValidate)
            {

#line default
#line hidden

            WriteLiteral("            //Nothing to validate\r\n");
#line 74 "ModelTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("        }\r\n");
#line 76 "ModelTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
