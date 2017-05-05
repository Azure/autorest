// --------------------------------------------------------------------------------------------------------------------
// <copyright>
//   Copyright (c) Microsoft. All rights reserved.
// </copyright>
// --------------------------------------------------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace Microsoft.Perks.JsonRPC
{
    public interface ICallerResponse
    {
        bool SetCompleted(JToken result);
        bool SetException(JToken error);
        bool SetCancelled();
    }

    public class CallerResponse<T> : TaskCompletionSource<T>, ICallerResponse
    {
        public string Id { get; private set; }
        private Action<JObject> _setResult;

        public CallerResponse(string id, Action<JObject> setResult)
        {
            Id = id;
            _setResult = setResult;
        }
        public CallerResponse(string id)
        {
            Id = id;
        }

        public bool SetCompleted(JToken result)
        {
#if false          
            Log.WriteLine($"The jtoken for the result is {result}");
            var value = result.ToObject<T>();
            Log.WriteLine($"Deserialized {value}");
            Log.WriteLine($" try setting response {TrySetResult(value)}");
            return true;
#endif            
            return TrySetResult(result.ToObject<T>());
        }

        public bool SetException(JToken error)
        {
            return TrySetException(error.ToObject<Exception>());
        }

        public bool SetCancelled()
        {
            return TrySetCanceled();
        }
    }
}