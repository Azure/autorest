// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using YamlDotNet.Core;
using YamlDotNet.Core.Events;
using YamlDotNet.Serialization;

namespace AutoRest.Swagger
{
    public class YamlBoolDeserializer : INodeDeserializer
    {
        public bool Deserialize(EventReader reader, Type expectedType, Func<EventReader, Type, object> nestedObjectDeserializer, out object value)
        {
            if (reader == null)
            {
                value = null;
                return false;
            }

            // only try this if we're targeting a boolean or an untyped object
            if (expectedType == typeof(object) || expectedType == typeof(bool) ) 
            {
                // peek at the current token
                Scalar scalar = reader.Peek<Scalar>();

                // if it's unquoted 
                if (scalar != null && scalar.Style == ScalarStyle.Plain)
                {
                    // and the value is actually true or false
                    switch (scalar.Value.ToUpperInvariant())
                    {
                        case "TRUE":
                            value = true;
                            reader.Allow<Scalar>();
                            return true;
                        case "FALSE":
                            value = false;
                            reader.Allow<Scalar>();
                            return true;

                    }
                }
            }

            // otherwise, fall thru
            value = null;
            return false;
        }
    }
}