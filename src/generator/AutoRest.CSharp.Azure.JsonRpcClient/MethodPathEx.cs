using AutoRest.Core.Model;
using System;
using System.Collections.Generic;

namespace AutoRest.CSharp.Azure.JsonRpcClient
{
    public static class MethodPathEx
    {
        public static IEnumerable<Tuple<string, bool>> GetParts(this string value)
        {
            while (value != string.Empty)
            {
                var index = value.IndexOf('{');

                if (index < 0)
                {
                    yield return Tuple.Create(value, false);
                    break;
                }

                if (index > 0)
                {
                    yield return Tuple.Create(value.Substring(0, index), false);
                }

                value = value.Substring(index + 1);

                index = value.IndexOf('}');

                if (index <= 0)
                {
                    throw new Exception("invalid url: " + value);
                }

                yield return Tuple.Create(value.Substring(0, index), true);

                value = value.Substring(index + 1);
            }
        }

        public static IEnumerable<Tuple<string, bool>> GetUriParts(this Method method)
            => method.MethodGroup.CodeModel.BaseUrl.GetParts();

        public static IEnumerable<Tuple<string, bool>> GetPathParts(this Method method)
            => method.Url.Value.GetParts();
    }
}
