// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Runtime.InteropServices.WindowsRuntime;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using System;

namespace Microsoft.Azure.Authentication
{
    /// <summary>
    /// An abstract store for active directory token data.  Can be used to persist token metadata across 
    /// application sessions. Implementers may use the GetStoreData and LoadStoreData methods to save and load 
    /// data from an external store.  The abstract methods 
    /// </summary>
    public abstract class ActiveDirectoryTokenStore
    {
        private TokenCache _cache;

        /// <summary>
        /// Initializes an active directory token store with no initial token data.
        /// </summary>
        protected ActiveDirectoryTokenStore() 
            : this(new TokenCache())
        {
        }

        /// <summary>
        /// Initializes an active directory token store with the given initial token data.
        /// </summary>
        /// <param name="data"></param>
        protected ActiveDirectoryTokenStore(byte[] data) 
            : this(new TokenCache(data))
        {
        }

        /// <summary>
        /// Initializes an active directory token store with the given backing token cache.
        /// </summary>
        /// <param name="cache"></param>
        protected ActiveDirectoryTokenStore(TokenCache cache)
        {
            if(cache == null)
            {
                throw new ArgumentNullException("cache");
            }
            cache.BeforeAccess =
                (args) => BeginAccessToken(args.ClientId, args.Resource, args.UniqueId, args.DisplayableId);
            cache.AfterAccess = 
                (args) => EndAccessToken(args.ClientId, args.Resource, args.UniqueId, args.DisplayableId);
            cache.BeforeWrite = 
                (args) => BeginWriteToken(args.ClientId, args.Resource, args.UniqueId, args.DisplayableId);
            this._cache = cache;
        }

        /// <summary>
        /// Abstract method.  Called before the token store is accessed. Handle the notification that the token 
        /// store is about to be accessed.  Can be used by implementing types to load token data from an external 
        /// store, like a database or file system.
        /// </summary>
        /// <param name="clientId">The client Id associated with the token to be accessed.</param>
        /// <param name="audience">The audience of the token to be accessed.</param>
        /// <param name="uniqueId">The active directory unique id of the principal associated with the token to be accessed.</param>
        /// <param name="userId">The display user id (if any) associated with the token to be accessed.</param>
        protected abstract void BeginAccessToken(string clientId, string audience, string uniqueId, string userId);
        
        /// <summary>
        /// Abstract method.  Called after an access to the token store has completed. Handle the notification that 
        /// the token store access has completed.  Can be used by implementing types to store token data to an 
        /// external store, like a database or file system.
        /// </summary>
        /// <param name="clientId">The client Id associated with the token that was accessed.</param>
        /// <param name="audience">The audience of the token that was acessed.</param>
        /// <param name="uniqueId">The active directory unique id of the principal associated with the token that was accessed.</param>
        /// <param name="userId">The display user id (if any) associated with the token that was accessed.</param>
        protected abstract void EndAccessToken(string clientId, string audience, string uniqueId, string userId);

        /// <summary>
        /// Abstract method.  Called Before any change is made to the token store. Handle the notification that a 
        /// token is about to be written to the token store. Can be used by implementing types to retrieve and load 
        /// token data from an external store, like a database or file system.
        /// </summary>
        /// <param name="clientId">The client Id associated with the token to be written.</param>
        /// <param name="audience">The authority of the token to be written.</param>
        /// <param name="uniqueId">The active directory unique id of the principal associated with the token to be written.</param>
        /// <param name="userId">The display user id (if any) associated with the token to be written.</param>
        protected abstract void BeginWriteToken(string clientId, string audience, string uniqueId, string userId);

        /// <summary>
        /// Get the number of records in the store.
        /// </summary>
        public int Count
        {
            get { return this._cache.Count; }
        }

        /// <summary>
        /// Gets a value indicating whether the state of the token store has changed.
        /// </summary>
        public bool HasStateChanged
        {
            get { return this._cache.HasStateChanged; }
        }

        /// <summary>
        /// Clears all tokens from the store.
        /// </summary>
        public void Clear()
        {
            this._cache.Clear();
        }

        /// <summary>
        /// Get all data from the token cache.  May be used by implementing classes to write data to an external 
        /// store like a database or file system.
        /// </summary>
        /// <returns>The token data in the store as an array of bytes.</returns>
        public byte[] GetStoreData()
        {
            return this._cache.Serialize();
        }

        /// <summary>
        /// Replace the token data in the store with the given data.
        /// </summary>
        /// <param name="data">The token data to load into the store.</param>
        public void LoadStoreData([ReadOnlyArray] byte[] data)
        {
            this._cache.Deserialize(data);
        }

        /// <summary>
        /// The internal token cache used by the token store.
        /// </summary>
        internal TokenCache TokenCache
        {
            get { return this._cache; }
        }
    }
}
