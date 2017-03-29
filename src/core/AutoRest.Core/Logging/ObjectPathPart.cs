// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using YamlDotNet.RepresentationModel;

namespace AutoRest.Core.Logging
{
    public abstract class ObjectPathPart
    {
        public abstract string JsonPointer { get; }

        public abstract string JsonPath { get; }

        public abstract string ReadablePath { get; }

        public abstract object RawPath { get; }

        /// <summary>
        /// Selects the child node according to this path part.
        /// Returns null if such node was not found.
        /// </summary>
        public abstract YamlNode SelectNode(ref YamlNode node);
    }
}
