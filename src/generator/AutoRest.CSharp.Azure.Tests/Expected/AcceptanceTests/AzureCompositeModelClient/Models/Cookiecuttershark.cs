// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsAzureCompositeModelClient.Models
{
    using System;		
    using System.Linq;
    using System.Collections.Generic;		
    using Newtonsoft.Json;		
    using Microsoft.Rest;		
    using Microsoft.Rest.Serialization;		
    using Microsoft.Rest.Azure;		

    [Newtonsoft.Json.JsonObject("cookiecuttershark")]
    public partial class Cookiecuttershark : Shark
    {
        /// <summary>
        /// Initializes a new instance of the Cookiecuttershark class.
        /// </summary>
        public Cookiecuttershark() { }

        /// <summary>
        /// Initializes a new instance of the Cookiecuttershark class.
        /// </summary>
        public Cookiecuttershark(double length, System.DateTime birthday, string species = default(string), System.Collections.Generic.IList<Fish> siblings = default(System.Collections.Generic.IList<Fish>), int? age = default(int?))
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
