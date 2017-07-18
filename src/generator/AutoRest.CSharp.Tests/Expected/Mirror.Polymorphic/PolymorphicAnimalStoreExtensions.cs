// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Fixtures.MirrorPolymorphic
{
    using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for PolymorphicAnimalStore.
    /// </summary>
    public static partial class PolymorphicAnimalStoreExtensions
    {
            /// <summary>
            /// Product Types
            /// </summary>
            /// <remarks>
            /// The Products endpoint returns information about the Uber products offered
            /// at a given location. The response includes the display name and other
            /// details about each product, and lists the products in the proper display
            /// order.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='animalCreateOrUpdateParameter'>
            /// An Animal
            /// </param>
            public static Animal CreateOrUpdatePolymorphicAnimals(this IPolymorphicAnimalStore operations, Animal animalCreateOrUpdateParameter = default(Animal))
            {
                return operations.CreateOrUpdatePolymorphicAnimalsAsync(animalCreateOrUpdateParameter).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Product Types
            /// </summary>
            /// <remarks>
            /// The Products endpoint returns information about the Uber products offered
            /// at a given location. The response includes the display name and other
            /// details about each product, and lists the products in the proper display
            /// order.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='animalCreateOrUpdateParameter'>
            /// An Animal
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<Animal> CreateOrUpdatePolymorphicAnimalsAsync(this IPolymorphicAnimalStore operations, Animal animalCreateOrUpdateParameter = default(Animal), CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.CreateOrUpdatePolymorphicAnimalsWithHttpMessagesAsync(animalCreateOrUpdateParameter, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
