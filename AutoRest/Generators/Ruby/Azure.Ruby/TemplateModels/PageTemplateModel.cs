using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Ruby;
using Microsoft.Rest.Generator.Azure.Ruby.Templates;

namespace Microsoft.Rest.Generator.Azure.Ruby
{
    public class PageTemplateModel : ModelTemplateModel
    {
        public PageTemplateModel(CompositeType source, ISet<CompositeType> allTypes, string nextLinkName, string itemName)
            : base(source, allTypes)
        {
            this.NextLinkName = nextLinkName;
            this.ItemName = itemName;
            this.NextLinkParameter = BuildNextLinkParameter();
        }

        public string NextLinkName { get; private set; }

        public Parameter NextLinkParameter { get; private set; }

        public string ItemName { get; private set; }

        public CompositeType ItemType
        {
            get
            {
                if (Properties == null)
                {
                    return null;
                }
                var property = Properties.FirstOrDefault(p => p.Type is SequenceType);
                if (property != null)
                {
                    return ((SequenceType)property.Type).ElementType as CompositeType;
                }
                else
                {
                    return null;
                }
            }
        }

        public Parameter BuildNextLinkParameter()
        {
            Parameter param = new Parameter
            {
                Name = RubyCodeNamer.RemoveInvalidCharacters(RubyCodeNamer.UnderscoreCase(NextLinkName)),
                SerializedName = NextLinkName,
                Type = new PrimaryType(KnownPrimaryType.String),
                Documentation = "The NextLink from the previous successful call to List operation.",
                IsRequired = true,
                Location = ParameterLocation.Path
            };
            param.Extensions[Generator.Extensions.SkipUrlEncodingExtension] = true;
            return param;
        }

        /// <summary>
        /// Returns code for declaring inheritance.
        /// </summary>
        /// <returns>Code for declaring inheritance.</returns>
        public override string GetBaseTypeName()
        {
            if (this.BaseModelType != null)
            {
                string typeName = this.BaseModelType.Name;

                if (this.BaseModelType.Extensions.ContainsKey(AzureExtensions.ExternalExtension) ||
                    this.BaseModelType.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension))
                {
                    typeName = "MsRestAzure::" + typeName;
                }

                return " < " + typeName;
            }

            return string.Empty;
        }

        /// <summary>
        /// Constructs mapper for the model class.
        /// </summary>
        /// <returns>Mapper as string for this model class.</returns>
        public override string ConstructModelMapper()
        {
            var modelMapper = Generator.Ruby.TemplateModels.ClientModelExtensions.ConstructMapper(this, SerializedName, null, true);
            var builder = new IndentedStringBuilder("  ");
            builder.AppendLine("{{{0}}}", modelMapper);
            return builder.ToString();
        }

        /// <summary>
        /// Gets the list of modules/classes which need to be included.
        /// </summary>
        public override List<string> Includes
        {
            get
            {
                return new List<string>
                {
                    "MsRestAzure"
                };
            }
        }

        public override List<string> ClassNamespaces
        {
            get
            {
                return new List<string>
                {
                    "MsRestAzure"
                };
            }
        }
    }
}

