using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Core
{
    class Schedule
    {
        public ITransformer Transformer { get; set; }

        public IEnumerable<Schedule> Continuations { get; set; }

        public async Task Run(object input)
        {
            var output = await Transformer.Transform(input).ConfigureAwait(false);
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
