// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using YamlDotNet.RepresentationModel;

namespace AutoRest.Core.Logging
{
    public class ObjectPathPartProperty : ObjectPathPart
    {
        public ObjectPathPartProperty(string property)
        {
            Property = property;
        }

        public string Property { get; }

        public override string XPath => Property.StartsWith("/") ? Property : $"/{Property}";

        public override YamlNode SelectNode(ref YamlNode node)
        {
            var child = (node as YamlMappingNode)?.
                Children?.FirstOrDefault(pair => pair.Key.ToString().Equals(Property, StringComparison.InvariantCultureIgnoreCase));
            node = child?.Value;
            return child?.Key;
        }
    }
}
