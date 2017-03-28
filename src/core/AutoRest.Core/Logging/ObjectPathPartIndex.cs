// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using YamlDotNet.RepresentationModel;

namespace AutoRest.Core.Logging
{
    public class ObjectPathPartIndex : ObjectPathPart
    {
        public ObjectPathPartIndex(int index)
        {
            Index = index;
        }

        public int Index { get; }

        public override string JsonPointer => $"/{Index + 1}";

        public override string JsonPath => $"[{Index + 1}]";

        public override string ReadablePath => JsonPath;

        public override object RawPath => Index;

        public override YamlNode SelectNode(ref YamlNode node)
        {
            var snode = node as YamlSequenceNode;
            node = snode != null && 0 <= Index && Index < snode.Children.Count
                ? snode.Children[Index]
                : null;
            return node;
        }
    }
}
