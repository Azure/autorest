using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;
using AutoRest.Extensions;

namespace AutoRest.Java.Model
{
    public class CompositeTypeJv : CompositeType, IModelTypeJv
    {
        public const string ExternalExtension = "x-ms-external";
        protected string _runtimePackage = "com.microsoft.rest";

        public CompositeTypeJv()
        {
        }

        public CompositeTypeJv(string name) : base(name)
        {
        }

        public string ModelsPackage => (this.CodeModel as CodeModelJv).ModelsPackage;

        public virtual string Package
        {
            get
            {
                if (Extensions.ContainsKey(ExternalExtension) &&
                    (bool)Extensions[ExternalExtension]) {
                    return _runtimePackage;
                }
                else
                {
                    return string.Join(
                        ".",
                        //_package, // TODO
                        "models");
                }
            }
        }

        public IEnumerable<CompositeType> SubTypes
        {
            get
            {
                if (IsPolymorphic)
                {
                    foreach (CompositeType type in CodeModel.ModelTypes)
                    {
                        if (type.BaseModelType != null &&
                            type.BaseModelType.SerializedName == this.SerializedName)
                        {
                            yield return type;
                        }
                    }
                }
            }
        }

        public virtual string ExceptionTypeDefinitionName
        {
            get
            {
                if (this.Extensions.ContainsKey(SwaggerExtensions.NameOverrideExtension))
                {
                    var ext = this.Extensions[SwaggerExtensions.NameOverrideExtension] as Newtonsoft.Json.Linq.JContainer;
                    if (ext != null && ext["name"] != null)
                    {
                        return ext["name"].ToString();
                    }
                }
                return this.Name + "Exception";
            }
        }

        public bool NeedsFlatten
        {
            get
            {
                return Properties.OfType<PropertyJv>().Any(p => p.WasFlattened());
            }
        }

        public IEnumerable<string> Imports
        {
            get
            {
                var imports = new List<string>();
                if (Name.Contains('<'))
                {
                    imports.AddRange(ParseGenericType().SelectMany(t => t.Imports));
                }
                else
                {
                    imports.Add(string.Join(".", Package, Name));
                }
                return imports;
            }
        }

        public virtual IEnumerable<String> ImportList
        {
            get
            {
                var classes = new HashSet<string>();
                classes.AddRange(Properties.SelectMany(pm => (pm as PropertyJv).Imports));
                if (this.Properties.Any(p => !p.GetJsonProperty().IsNullOrEmpty()))
                {
                    classes.Add("com.fasterxml.jackson.annotation.JsonProperty");
                }
                // For polymorphism
                if (IsPolymorphic)
                {
                    classes.Add("com.fasterxml.jackson.annotation.JsonTypeInfo");
                    classes.Add("com.fasterxml.jackson.annotation.JsonTypeName");
                    if (SubTypes.Any())
                    {
                        classes.Add("com.fasterxml.jackson.annotation.JsonSubTypes");
                    }
                }
                // For flattening
                if (NeedsFlatten)
                {
                    classes.Add("com.microsoft.rest.serializer.JsonFlatten");
                }
                return classes.AsEnumerable();
            }
        }

        public IModelTypeJv ResponseVariant => this;

        public IModelTypeJv InstanceType()
        {
            return this;
        }

        private IEnumerable<IModelTypeJv> ParseGenericType()
        {
            string name = Name;
            string[] types = Name.ToString().Split(new String[] { "<", ">", ",", ", " }, StringSplitOptions.RemoveEmptyEntries);
            foreach (var innerType in types.Where(t => !string.IsNullOrWhiteSpace(t)))
            {
                if (!CodeNamerJv.PrimaryTypes.Contains(innerType.Trim()))
                {
                    yield return new CompositeTypeJv { Name = innerType.Trim() };
                }
            }
        }
    }
}
