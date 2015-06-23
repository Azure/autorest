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
#line 5 "ModelTemplate.cshtml"
Write(Header("/// "));

#line default
#line hidden
            WriteLiteral("\r\nnamespace ");
#line 6 "ModelTemplate.cshtml"
      Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral(".Models\r\n{\r\n    using System;\r\n    using System.Collections.Generic;\r\n    using N" +
"ewtonsoft.Json;\r\n    using Microsoft.Rest;\r\n    using Microsoft.Rest.Serializati" +
"on;\r\n");
#line 13 "ModelTemplate.cshtml"
 foreach (var usingString in Model.Usings) {

#line default
#line hidden

            WriteLiteral("    using ");
#line 14 "ModelTemplate.cshtml"
       Write(usingString);

#line default
#line hidden
            WriteLiteral(";\r\n");
#line 15 "ModelTemplate.cshtml"
}

#line default
#line hidden

#line 16 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\r\n    /// <summary>\r\n    ");
#line 18 "ModelTemplate.cshtml"
Write(WrapComment("/// ", Model.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n    /// </summary>\r\n");
#line 20 "ModelTemplate.cshtml"
    

#line default
#line hidden

#line 20 "ModelTemplate.cshtml"
     if (Model.NeedsPolymorphicConverter)
    {

#line default
#line hidden

            WriteLiteral("    [JsonObject(\"");
#line 22 "ModelTemplate.cshtml"
              Write(Model.SerializedName);

#line default
#line hidden
            WriteLiteral("\")]    \r\n");
#line 23 "ModelTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("    public partial class ");
#line 24 "ModelTemplate.cshtml"
                    Write(Model.Name);

#line default
#line hidden
#line 24 "ModelTemplate.cshtml"
                                Write(Model.BaseModelType != null ? " : " + Model.BaseModelType.Name : "");

#line default
#line hidden
            WriteLiteral("\r\n    {\r\n");
#line 26 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 26 "ModelTemplate.cshtml"
         foreach (var property in Model.PropertyTemplateModels)
        {

#line default
#line hidden

            WriteLiteral("        /// <summary>\r\n        ");
#line 29 "ModelTemplate.cshtml"
     Write(WrapComment("/// ", property.Documentation));

#line default
#line hidden
            WriteLiteral("\r\n        /// </summary>\r\n");
#line 31 "ModelTemplate.cshtml"
            if (property.Type == PrimaryType.Date)
            {

#line default
#line hidden

            WriteLiteral("        [JsonConverter(typeof(DateJsonConverter))]\r\n");
#line 34 "ModelTemplate.cshtml"
            }

#line default
#line hidden

            WriteLiteral("        [JsonProperty(PropertyName = \"");
#line 35 "ModelTemplate.cshtml"
                                   Write(property.SerializedName);

#line default
#line hidden
            WriteLiteral("\")]\r\n        public ");
#line 36 "ModelTemplate.cshtml"
            Write(property.Type.Name);

#line default
#line hidden
            WriteLiteral(" ");
#line 36 "ModelTemplate.cshtml"
                                Write(property.Name);

#line default
#line hidden
            WriteLiteral(" { get; ");
#line 36 "ModelTemplate.cshtml"
                                                       Write(property.IsReadOnly ? "private " : "");

#line default
#line hidden
            WriteLiteral("set; }\r\n");
#line 37 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 37 "ModelTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 37 "ModelTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        \r\n");
#line 39 "ModelTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("       \r\n        /// <summary>\r\n        /// Validate the object. Throws ArgumentE" +
"xception or ArgumentNullException if validation fails.\r\n        /// </summary>\r\n" +
"        public ");
#line 44 "ModelTemplate.cshtml"
          Write(Model.MethodQualifier);

#line default
#line hidden
            WriteLiteral(" void Validate()\r\n        {\r\n");
#line 46 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 46 "ModelTemplate.cshtml"
          
            bool anythingToValidate = false;

            if (Model.BaseModelType != null)
            {
                anythingToValidate = true;

#line default
#line hidden

            WriteLiteral("            base.Validate();\r\n");
#line 53 "ModelTemplate.cshtml"
            }
            
            foreach (var property in Model.Properties.Where(p => p.IsRequired && !p.IsReadOnly))
            {
                anythingToValidate = true;

#line default
#line hidden

            WriteLiteral("            if (");
#line 58 "ModelTemplate.cshtml"
             Write(property.Name);

#line default
#line hidden
            WriteLiteral(" == null)\r\n            {\r\n                throw new ArgumentNullException(\"");
#line 60 "ModelTemplate.cshtml"
                                              Write(property.Name);

#line default
#line hidden
            WriteLiteral("\");\r\n            }\r\n            \r\n");
#line 63 "ModelTemplate.cshtml"
            }
            foreach (var property in Model.Properties.Where(p => !(p.Type is PrimaryType)))
            {
                anythingToValidate = true;

#line default
#line hidden

            WriteLiteral("            ");
#line 67 "ModelTemplate.cshtml"
         Write(property.Type.ValidateType(Model.Scope, string.Format("this.{0}", property.Name)));

#line default
#line hidden
            WriteLiteral("\r\n            \r\n");
#line 69 "ModelTemplate.cshtml"
            }
            if (!anythingToValidate)
            {

#line default
#line hidden

            WriteLiteral("            //Nothing to validate\r\n");
#line 73 "ModelTemplate.cshtml"
            }
        

#line default
#line hidden

            WriteLiteral("\r\n        }\r\n    }\r\n}\r\n");
        }
        #pragma warning restore 1998
    }
}
