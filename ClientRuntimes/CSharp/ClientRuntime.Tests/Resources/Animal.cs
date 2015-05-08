// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using Newtonsoft.Json;

namespace Microsoft.Rest.ClientRuntime.Tests.Resources
{
    [JsonObject("animal")]
    public class Animal
    {
        [JsonProperty("name")]
        public string Name { get; set; }
    }

    [JsonObject("dog")]
    public class Dog : Animal
    {
        [JsonProperty("likesDogfood")]
        public bool LikesDogfood { get; set; }
    }

    [JsonObject("cat")]
    public class Cat : Animal
    {
        [JsonProperty("likesMice")]
        public bool LikesMice { get; set; }

        [JsonProperty("dislikes")]
        public Animal Dislikes { get; set; }
    }

    public class Zoo
    {
        public int Id { get; set; }
        private List<Animal> _animals = new List<Animal>();
        public List<Animal> Animals { get { return _animals; } set { _animals = value; } }
    }
}
