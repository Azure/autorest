namespace Times.Wire.Search
{
    using Runtime;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;


    /// <summary>A class that contains the module-common code and data.</summary>
    /// <notes>
    /// This class is where you can add things to modify the module.
    /// As long as it's in the 'private/custom' folder, it won't get deleted
    /// when you use --clear-output-folder in autorest.
    /// </notes>
    public partial class Module
    {
        partial void CustomInit()
        {
            // we need to add a step at the end of the pipeline 
            // to attach the API key 

            // once for the regular pipeline
            this._pipeline.Append(AddApiKey);

            // once for the pipeline that supports a proxy
            this._pipelineWithProxy.Append(AddApiKey);
        }

        protected async Task<HttpResponseMessage> AddApiKey(HttpRequestMessage request, IEventListener callback, ISendAsync next)
        {
            // does the request already have a query?
            var sepChar = string.IsNullOrEmpty(request.RequestUri.Query) ? "?" : "&";

            // add on the apikey
            request.RequestUri = new System.Uri(
                request.RequestUri.AbsoluteUri +
                sepChar +
                "apikey=" +
                // we'll cheat and pull it from the environment :D
                System.Environment.GetEnvironmentVariable("TimesApiKey")
                );

            // let it go on.
            return await next.SendAsync(request, callback);
        }
    }
}
