// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Utilities;
using System.Text.RegularExpressions;
using YamlDotNet.RepresentationModel;

namespace AutoRest.Core.Logging
{
    public class ObjectPathPartProperty : ObjectPathPart
    {
        // conservative approximation
        private static readonly Regex regexValidES3DotNotationPropertyName = new Regex(@"^(?!do|if|in|for|int|new|try|var|byte|case|char|else|enum|goto|long|null|this|true|void|with|break|catch|class|const|false|final|float|short|super|throw|while|delete|double|export|import|native|public|return|static|switch|throws|typeof|boolean|default|extends|finally|package|private|abstract|continue|debugger|function|volatile|interface|protected|transient|implements|instanceof|synchronized)[a-zA-Z_][a-zA-Z_0-9]*$");

        public ObjectPathPartProperty(string property)
        {
            Property = property;
        }

        public string Property { get; }

        public override string JsonPointer => $"/{Property.Replace("~", "~0").Replace("/", "~1")}";

        public override string JsonPath => regexValidES3DotNotationPropertyName.IsMatch(Property) ? $".{Property}" : $"[{JsonConvert.SerializeObject(Property)}]";

        public override string ReadablePath => Property.StartsWith("/") ? Property : $"/{Property}";

        public override YamlNode SelectNode(ref YamlNode node)
        {
            var child = (node as YamlMappingNode)?.
                Children?.FirstOrDefault(pair => pair.Key.ToString().EqualsIgnoreCase(Property));
            node = child?.Value;
            return child?.Key;
        }
    }
}
