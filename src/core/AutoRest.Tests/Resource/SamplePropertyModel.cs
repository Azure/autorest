// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Text;

namespace AutoRest.Core.Tests.Resource
{
    public class SamplePropertyModel
    {
        private string _documentation;

        public string Documentation
        {
            get
            {
                var sb = new StringBuilder();
                sb.AppendLine("/// <summary>");
                sb.AppendLine("/// " + _documentation);
                sb.Append("/// </summary>");
                return sb.ToString();
            }
            set { _documentation = value; }
        }

        public string Type { get; set; }
        public string Name { get; set; }
        public bool ReadOnly { get; set; }
    }
}
