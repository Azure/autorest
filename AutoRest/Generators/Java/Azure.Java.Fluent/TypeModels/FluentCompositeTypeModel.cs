using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;

namespace Microsoft.Rest.Generator.Java.Azure.Fluent
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
                else if (this.Name.EndsWith("Inner"))
                {
                    return _package + ".implementation.api";
                }
                else
                {
                    return _package;
                }
            }
        }
    }
}
