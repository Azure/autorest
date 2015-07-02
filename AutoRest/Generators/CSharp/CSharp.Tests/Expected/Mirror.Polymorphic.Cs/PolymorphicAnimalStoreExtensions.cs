namespace Fixtures.MirrorPolymorphic
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class PolymorphicAnimalStoreExtensions
    {
            /// <summary>
            /// The Products endpoint returns information about the Uber products offered
            /// at a given location. The response includes the display name and other
            /// details about each product, and lists the products in the proper display
            /// order.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='animalCreateOrUpdateParameter'>
            /// An Animal
            /// </param>
            public static Animal CreateOrUpdatePolymorphicAnimals(this IPolymorphicAnimalStore operations, Animal animalCreateOrUpdateParameter = default(Animal))
            {
                return Task.Factory.StartNew(s => ((IPolymorphicAnimalStore)s).CreateOrUpdatePolymorphicAnimalsAsync(animalCreateOrUpdateParameter), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// The Products endpoint returns information about the Uber products offered
            /// at a given location. The response includes the display name and other
            /// details about each product, and lists the products in the proper display
            /// order.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='animalCreateOrUpdateParameter'>
            /// An Animal
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Animal> CreateOrUpdatePolymorphicAnimalsAsync( this IPolymorphicAnimalStore operations, Animal animalCreateOrUpdateParameter = default(Animal), CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Animal> result = await operations.CreateOrUpdatePolymorphicAnimalsWithOperationResponseAsync(animalCreateOrUpdateParameter, null, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

    }
}
