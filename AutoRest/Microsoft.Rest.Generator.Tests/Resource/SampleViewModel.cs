// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Text;

namespace Microsoft.Rest.Generator.Test.Resource
{
    public class SampleViewModel
    {
        private readonly List<string> _imports = new List<string>();

        public string Imports
        {
            get
            {
                var sb = new StringBuilder();
                _imports.ForEach(i => sb.AppendLine(string.Format("using {0};", i)));
                return sb.ToString();
            }
        }

        public string Namespace
        {
            get { return "Fixtures.Redis.Models"; }
        }

        public string Name
        {
            get { return "CacheSku"; }
        }

        public string OperationExceptionTypeString
        {
            get { return "CloudException"; }
        }
        public string SerializationBlock
        {
            get { return @"if (outputObject == null)
            {
                outputObject = new JObject();
            }
            if (this.Capacity != null)
            {
                outputObject[""Capacity""] = this.Capacity.Value;
            }
            if (this.Family != null)
            {
                outputObject[""Family""] = this.Family;
            }
            if (this.Name != null)
            {
                outputObject[""Name""] = this.Name;
            }
            return outputObject;"; }
        }

        public string DeserializationBlock
        {
            get { return @"if (inputObject != null && inputObject.Type != JTokenType.Null)
            {
                JToken capacityValue = inputObject[""Capacity""];
                if (capacityValue != null && capacityValue.Type != JTokenType.Null)
                {
                    this.Capacity = ((int)capacityValue);
                }
                JToken familyValue = inputObject[""Family""];
                if (familyValue != null && familyValue.Type != JTokenType.Null)
                {
                    this.Family = ((string)familyValue);
                }
                JToken nameValue = inputObject[""Name""];
                if (nameValue != null && nameValue.Type != JTokenType.Null)
                {
                    this.Name = ((string)nameValue);
                }
            }"; }
        }

        public List<SamplePropertyModel> Properties { get; private set; }

        public SampleViewModel()
        {
            _imports.Add("Microsoft.Rest");
            _imports.Add("System.Linq");
            _imports.Add("System.Text");

            Properties = new List<SamplePropertyModel>();
            Properties.Add(new SamplePropertyModel
            {
                Documentation = "Capacity of the given cache.",
                Name = "Capacity",
                ReadOnly = true,
                Type = "int?"
            });
            Properties.Add(new SamplePropertyModel
            {
                Documentation = "Family.",
                Name = "Family",
                ReadOnly = false,
                Type = "string"
            });
            Properties.Add(new SamplePropertyModel
            {
                Documentation = "Name of the cache.",
                Name = "Name",
                ReadOnly = false,
                Type = "string"
            });
        }
    }
}
