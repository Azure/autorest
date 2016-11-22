using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;

namespace AutoRest.Core
{
    public class Schedule
    {
        public ITransformer Transformer { get; set; }

        public IEnumerable<Schedule> Continuations { get; set; }

        public async Task Run(object input)
        {
            object output = null;
            try
            {
                Logger.LogInfo("> {0}", Transformer.Name); // TODO: resx
                output = await Transformer.TransformAsync(input).ConfigureAwait(false);
                Logger.LogInfo("< {0} (triggering: {1})", Transformer.Name, string.Join(", ", Continuations.Select(c => c.Transformer.Name))); // TODO: resx
            }
            catch (Exception exception)
            {
                throw ErrorManager.CreateError(exception, Resources.TransformerError, Transformer.Name, exception.Message);
            }
            var continuationTasks = Continuations.AsParallel().Select(c => c.Run(output));
            await Task.WhenAll(continuationTasks).ConfigureAwait(false);
        }

        // TODO: the following is just convenience for now - reevaluate
        /// <summary>
        /// Appends given transformer to the schedule and returns the nested schedule (=> "fluent")
        /// </summary>
        public static Schedule FromLinearPipeline(params ITransformer[] pipeline) =>
            pipeline.Length == 0
                ? null
                : new Schedule
                {
                    Transformer = pipeline.First(),
                    Continuations = new[] {FromLinearPipeline(pipeline.Skip(1).ToArray())}.Where(c => c != null)
                };
    }
}
