using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Java.Model;

namespace AutoRest.Java.Azure.Fluent.Model
{
    public class PropertyJvaf : PropertyJv
    {
        public bool IsInnerModel { get; set; } = false;

        public override IEnumerable<string> Imports
        {
            get
            {
                var imports = new List<string>(ModelType.ImportSafe()
                        .Where(c => //!c.StartsWith(CodeModel?.Namespace.ToLower(CultureInfo.InvariantCulture), StringComparison.Ordinal) || 
                            c.EndsWith("Inner", StringComparison.Ordinal) ^ IsInnerModel));
                if (ModelType.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
                {
                    imports.AddRange(ModelType.ImportSafe());
                    imports.AddRange((ModelType as IModelTypeJv).ResponseVariant.ImportSafe());
                }
                return imports;
            }
        }
    }
}
