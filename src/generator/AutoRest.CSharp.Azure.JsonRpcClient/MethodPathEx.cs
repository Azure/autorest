using AutoRest.Core.Model;
using System;
using System.Collections.Generic;

namespace AutoRest.CSharp.Azure.JsonRpcClient
{
    public static class MethodPathEx
    {
        public static IEnumerable<Tuple<string, bool>> GetPathParts(this Method method)
        {
            var url = method.Url.Value;
            while (url != string.Empty)
            {
                var index = url.IndexOf('{');

                if (index < 0)
                {
                    yield return Tuple.Create(url, false);
                    break;
                }

                if (index > 0)
                {
                    yield return Tuple.Create(url.Substring(0, index), false);
                }

                url = url.Substring(index + 1);

                index = url.IndexOf('}');

                if (index <= 0)
                {
                    throw new Exception("invalid url: " + method.Url.Value);
                }

                yield return Tuple.Create(url.Substring(0, index), true);

                url = url.Substring(index + 1);
            }
        }
    }
}
