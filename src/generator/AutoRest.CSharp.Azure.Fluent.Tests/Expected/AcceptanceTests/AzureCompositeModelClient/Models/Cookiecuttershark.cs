// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsAzureCompositeModelClient.Models
{
    using AcceptanceTestsAzureCompositeModelClient;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    [JsonObject("cookiecuttershark")]
    public partial class Cookiecuttershark : Shark
    {
        /// <summary>
        /// Initializes a new instance of the Cookiecuttershark class.
        /// </summary>
        public Cookiecuttershark() { }

        /// <summary>
        /// Initializes a new instance of the Cookiecuttershark class.
        /// </summary>
        public Cookiecuttershark(double length, System.DateTime birthday, string species = default(string), IList<FishInner> siblings = default(IList<FishInner>), int? age = default(int?))
            : base(length, birthday, species, siblings, age)
        {
        }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public override void Validate()
        {
            base.Validate();
        }
    }
}
