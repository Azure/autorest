// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Ruby.Templates
{
#line 1 "ModelTemplate.cshtml"
using System

#line default
#line hidden
    ;
#line 2 "ModelTemplate.cshtml"
using System.Linq

#line default
#line hidden
    ;
#line 3 "ModelTemplate.cshtml"
using Microsoft.Rest.Generator.ClientModel

#line default
#line hidden
    ;
#line 4 "ModelTemplate.cshtml"
using Microsoft.Rest.Generator.Ruby.TemplateModels

#line default
#line hidden
    ;
    using System.Threading.Tasks;

    public class ModelTemplate : Microsoft.Rest.Generator.Template<Microsoft.Rest.Generator.Ruby.ModelTemplateModel>
    {
        #line hidden
        public ModelTemplate()
        {
        }

        #pragma warning disable 1998
        public override async Task ExecuteAsync()
        {
#line 6 "ModelTemplate.cshtml"
Write(Header("# "));

#line default
#line hidden
            WriteLiteral("\n");
#line 7 "ModelTemplate.cshtml"
Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\nmodule ");
#line 8 "ModelTemplate.cshtml"
   Write(Settings.Namespace);

#line default
#line hidden
            WriteLiteral("\n  module Models\n    #\n    ");
#line 11 "ModelTemplate.cshtml"
Write(WrapComment("# ", string.IsNullOrEmpty(Model.Documentation) ? "Model object." : Model.Documentation));

#line default
#line hidden
            WriteLiteral("\n    #\n    class ");
#line 13 "ModelTemplate.cshtml"
     Write(Model.Name);

#line default
#line hidden
#line 13 "ModelTemplate.cshtml"
                 Write(Model.GetBaseTypeName());

#line default
#line hidden
            WriteLiteral("\n");
#line 14 "ModelTemplate.cshtml"
    

#line default
#line hidden

#line 14 "ModelTemplate.cshtml"
     foreach (var property in Model.PropertyTemplateModels)
    {

#line default
#line hidden

            WriteLiteral("      ");
#line 16 "ModelTemplate.cshtml"
   Write(WrapComment("# ", string.Format("@return {0}{1}", property.Type.GetYardDocumentation(), property.Documentation)));

#line default
#line hidden
            WriteLiteral("\n      ");
#line 17 "ModelTemplate.cshtml"
    Write(property.IsReadOnly ? "attr_reader" : "attr_accessor");

#line default
#line hidden
            WriteLiteral(" :");
#line 17 "ModelTemplate.cshtml"
                                                             Write(property.Name);

#line default
#line hidden
            WriteLiteral("\n");
#line 18 "ModelTemplate.cshtml"
      

#line default
#line hidden

#line 18 "ModelTemplate.cshtml"
 Write(EmptyLine);

#line default
#line hidden
#line 18 "ModelTemplate.cshtml"
                

#line default
#line hidden

            WriteLiteral("      \n");
#line 20 "ModelTemplate.cshtml"
    }

#line default
#line hidden

            WriteLiteral("\n");
#line 22 "ModelTemplate.cshtml"
    

#line default
#line hidden

#line 22 "ModelTemplate.cshtml"
     if (Model.Properties.Any(p => p.Type is SequenceType || p.Type is DictionaryType))
    {

#line default
#line hidden

            WriteLiteral("      def initialize\n");
#line 25 "ModelTemplate.cshtml"
        foreach (var property in Model.PropertyTemplateModels)
        {
            if (property.Type is SequenceType)
            {

#line default
#line hidden

            WriteLiteral("        @");
#line 29 "ModelTemplate.cshtml"
       Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = [];\n");
#line 30 "ModelTemplate.cshtml"
            }
            else if (property.Type is DictionaryType)
            {

#line default
#line hidden

            WriteLiteral("        @");
#line 33 "ModelTemplate.cshtml"
       Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = {};\n");
#line 34 "ModelTemplate.cshtml"
            }
        }

#line default
#line hidden

            WriteLiteral("      end\n");
#line 37 "ModelTemplate.cshtml"
      

#line default
#line hidden

#line 37 "ModelTemplate.cshtml"
 Write(EmptyLine);

#line default
#line hidden
#line 37 "ModelTemplate.cshtml"
                
    }

#line default
#line hidden

            WriteLiteral("\n      #\n      # Validate the object. Throws ArgumentError if validation fails.\n " +
"     #\n      def validate\n");
#line 44 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 44 "ModelTemplate.cshtml"
          
            bool anythingToValidate = false;
            foreach (var property in Model.Properties.Where(p => p.IsRequired && !p.IsReadOnly && p.Type.IsNullable()))
            {
                anythingToValidate = true;

#line default
#line hidden

            WriteLiteral("        fail ArgumentError, \'");
#line 49 "ModelTemplate.cshtml"
                          Write(property.Name);

#line default
#line hidden
            WriteLiteral(" is nil\' if @");
#line 49 "ModelTemplate.cshtml"
                                                       Write(property.Name);

#line default
#line hidden
            WriteLiteral(".nil?\n");
#line 50 "ModelTemplate.cshtml"
            }
            foreach (var property in Model.Properties.Where(p => !(p.Type is PrimaryType)))
            {
                anythingToValidate = true;

#line default
#line hidden

            WriteLiteral("        ");
#line 54 "ModelTemplate.cshtml"
     Write(property.Type.ValidateType(Model.Scope, string.Format("@{0}", property.Name)));

#line default
#line hidden
            WriteLiteral("\n        \n");
#line 56 "ModelTemplate.cshtml"
            }
            if (!anythingToValidate)
            {

#line default
#line hidden

            WriteLiteral("        # Nothing to validate\n");
#line 60 "ModelTemplate.cshtml"
            }
        

#line default
#line hidden

            WriteLiteral("\n      end\n\n      ");
#line 64 "ModelTemplate.cshtml"
 Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n      #\n      # Serializes given Model object into Ruby Hash.\n      ");
#line 67 "ModelTemplate.cshtml"
 Write(WrapComment("# ", string.Format("@param {0} {1}", "object", "Model object to serialize.")));

#line default
#line hidden
            WriteLiteral("\n      ");
#line 68 "ModelTemplate.cshtml"
 Write(WrapComment("# ", string.Format("@return [Hash] {0}", "Serialized object in form of Ruby Hash.")));

#line default
#line hidden
            WriteLiteral("\n      #\n      def self.serialize_object(object)\n        object.validate\n        " +
"output_object = {}\n");
#line 73 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 73 "ModelTemplate.cshtml"
         foreach (var property in Model.ComposedProperties.Where(x => !x.IsReadOnly).OrderByDescending(x => x.IsRequired))
        {
        

#line default
#line hidden

#line 75 "ModelTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 75 "ModelTemplate.cshtml"
                  

#line default
#line hidden

            WriteLiteral("        serialized_property = ");
#line 76 "ModelTemplate.cshtml"
                            Write("object." + property.Name);

#line default
#line hidden
            WriteLiteral("\n        ");
#line 77 "ModelTemplate.cshtml"
     Write(Model.SerializeProperty("serialized_property", property.Type, property.IsRequired, Settings.Namespace));

#line default
#line hidden
            WriteLiteral("\n        output_object[\'");
#line 78 "ModelTemplate.cshtml"
                     Write(property.SerializedName);

#line default
#line hidden
            WriteLiteral("\'] = serialized_property\n");
#line 79 "ModelTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        output_object\n      end\n\n      ");
#line 83 "ModelTemplate.cshtml"
 Write(EmptyLine);

#line default
#line hidden
            WriteLiteral("\n      #\n      # Deserializes given Ruby Hash into Model object.\n      ");
#line 86 "ModelTemplate.cshtml"
 Write(WrapComment("# ", string.Format("@param {0} [Hash] {1}", "object", "Ruby Hash object to deserialize.")));

#line default
#line hidden
            WriteLiteral("\n      ");
#line 87 "ModelTemplate.cshtml"
 Write(WrapComment("# ", string.Format("@return [{0}] {1}", Model.Name, "Deserialized object.")));

#line default
#line hidden
            WriteLiteral("\n      #\n      def self.deserialize_object(object)\n        return if object.nil?\n" +
"\n        output_object = ");
#line 92 "ModelTemplate.cshtml"
                    Write(Model.Name);

#line default
#line hidden
            WriteLiteral(".new\n        \n");
#line 94 "ModelTemplate.cshtml"
        

#line default
#line hidden

#line 94 "ModelTemplate.cshtml"
         foreach (var property in Model.ComposedProperties.Where(x => !x.IsReadOnly).OrderByDescending(x => x.IsRequired))
        {
        

#line default
#line hidden

#line 96 "ModelTemplate.cshtml"
   Write(EmptyLine);

#line default
#line hidden
#line 96 "ModelTemplate.cshtml"
                      

#line default
#line hidden

            WriteLiteral("        deserialized_property = ");
#line 97 "ModelTemplate.cshtml"
                              Write(string.Format("object['{0}']", property.SerializedName));

#line default
#line hidden
            WriteLiteral("\n        ");
#line 98 "ModelTemplate.cshtml"
     Write(Model.DeserializeProperty("deserialized_property", property.Type, property.IsRequired, Settings.Namespace));

#line default
#line hidden
            WriteLiteral("\n        output_object.");
#line 99 "ModelTemplate.cshtml"
                    Write(property.Name);

#line default
#line hidden
            WriteLiteral(" = deserialized_property\n");
#line 100 "ModelTemplate.cshtml"
        }

#line default
#line hidden

            WriteLiteral("        output_object.validate\n        output_object\n      end\n    end\n  end\nend\n" +
"");
        }
        #pragma warning restore 1998
    }
}
