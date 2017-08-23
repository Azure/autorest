using AutoRest.Core.Model;
using System;
using System.Collections.Generic;

namespace AutoRest.CSharp.Azure.JsonRpcClient
{
    public static class MethodPathEx
    {
        /// <summary>
        /// Split a swagger path to a sequence of tokens.
        /// The format of path is "constant{id}constant{id}".
        /// A token is either a constant { "..value..", false } or an identifier { "...id...", true }.
        /// </summary>
        /// <param name="path">a swagger path</param>
        /// <returns></returns>
        public static IEnumerable<Tuple<string, bool>> GetParts(this string path)
        {
            while (path != string.Empty)
            {
                var index = path.IndexOf('{');

                if (index < 0)
                {
                    yield return Tuple.Create(path, false);
                    break;
                }

                if (index > 0)
                {
                    yield return Tuple.Create(path.Substring(0, index), false);
                }

                path = path.Substring(index + 1);

                index = path.IndexOf('}');

                if (index <= 0)
                {
                    throw new Exception("invalid url: " + path);
                }

                yield return Tuple.Create(path.Substring(0, index), true);

                path = path.Substring(index + 1);
            }
        }
        
        /// <summary>
        /// Parse a swagger URI.
        /// </summary>
        /// <param name="method"></param>
        /// <returns></returns>
        public static IEnumerable<Tuple<string, bool>> GetUriParts(this Method method)
            => method.MethodGroup.CodeModel.BaseUrl.GetParts();

        /// <summary>
        /// Parse a swagger path.
        /// </summary>
        /// <param name="method"></param>
        /// <returns></returns>
        public static IEnumerable<Tuple<string, bool>> GetPathParts(this Method method)
            => method.Url.GetParts();
    }
}
