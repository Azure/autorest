// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.Python.Model
{
    public class PropertyPy : Property
    {
        public PropertyPy()
        {
            Name.OnGet += value =>
            {
                if (!(Parent is CodeModel))
                {
                    if (IsSpecialConstant && IsConstant && !value.StartsWith("self."))
                    {
                        return $"self.{value.ToPythonCase()}";
                    }
                }
                return value.ToPythonCase();
            };
            DefaultValue.OnGet += value => value.Else(PythonConstants.None);
        }

        public override string SerializedName
        {
            get
            {
                if (base.SerializedName != null && base.SerializedName.IndexOf(".") > -1 && base.SerializedName.IndexOf("\\\\") == -1 && !Extensions.ContainsKey("x-ms-client-flatten-original-type-name"))
                {
                    return base.SerializedName.Replace(".", "\\\\.")?.Replace("\\\\\\\\", "\\\\");
                }
                return base.SerializedName;
            }
            set => base.SerializedName = value;
        }

        public bool IsSpecialConstant { get; set; }
    }
}