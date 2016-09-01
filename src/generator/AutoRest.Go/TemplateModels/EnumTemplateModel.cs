// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Go.TemplateModels
{
    public class EnumTemplateModel : EnumType
    {
        public bool HasUniqueNames { get; set; }
        
        public EnumTemplateModel(EnumType source)
        {
            this.LoadFrom(source);

            // Assume members have unique names
            HasUniqueNames = true;

            if (string.IsNullOrEmpty(Documentation))
            {
                Documentation = string.Format("{0} enumerates the values for {1}.", Name, Name.ToPhrase());
            }
        }

        public IDictionary<string, string> Constants
        {
            get
            {
                var constants = new Dictionary<string, string>();
                Values
                    .ForEach(v =>
                    {
                        constants.Add(HasUniqueNames ? v.Name : Name + v.Name, v.SerializedName);
                    });

                return constants;
            }
        }

        public string Documentation { get; set; }
    }
}
