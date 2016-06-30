using System;
using System.Globalization;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Java.Azure.TypeModels;

namespace AutoRest.Java.Azure.Fluent.TypeModels
{
    public class FluentCompositeTypeModel : AzureCompositeTypeModel
    {
        public FluentCompositeTypeModel(CompositeType compositeType, string package)
            : base(compositeType, package)
        {
            this.LoadFrom(compositeType);
        }

        public FluentCompositeTypeModel(string package)
            : base(package)
        {
            this._package = package.ToLower(CultureInfo.InvariantCulture);
        }

        public override string Package
        {
            get
            {
                if (this.IsResource)
                {
                    return _azureRuntimePackage;
                }
                else if (Extensions.ContainsKey(ExternalExtension) &&
                    (bool)Extensions[ExternalExtension])
                {
                    return _runtimePackage;
                }
                else if (this.Name.EndsWith("Inner", StringComparison.Ordinal))
                {
                    return _package + ".implementation";
                }
                else
                {
                    return _package;
                }
            }
        }
    }
}
