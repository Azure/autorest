// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// Capture Virtual Machine parameters.
    /// </summary>
    public partial class RunCommandInput
    {
        /// <summary>
        /// Initializes a new instance of the RunCommandInput class.
        /// </summary>
        public RunCommandInput()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the RunCommandInput class.
        /// </summary>
        /// <param name="commandId">The run command id.</param>
        /// <param name="script">Optional. The script to be executed.  When
        /// this value is given, the given script will override the default
        /// script of the command.</param>
        /// <param name="parameters">The run command parameters.</param>
        public RunCommandInput(string commandId, IList<string> script = default(IList<string>), IList<RunCommandInputParameter> parameters = default(IList<RunCommandInputParameter>))
        {
            CommandId = commandId;
            Script = script;
            Parameters = parameters;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the run command id.
        /// </summary>
        [JsonProperty(PropertyName = "commandId")]
        public string CommandId { get; set; }

        /// <summary>
        /// Gets or sets optional. The script to be executed.  When this value
        /// is given, the given script will override the default script of the
        /// command.
        /// </summary>
        [JsonProperty(PropertyName = "script")]
        public IList<string> Script { get; set; }

        /// <summary>
        /// Gets or sets the run command parameters.
        /// </summary>
        [JsonProperty(PropertyName = "parameters")]
        public IList<RunCommandInputParameter> Parameters { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (CommandId == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "CommandId");
            }
            if (Parameters != null)
            {
                foreach (var element in Parameters)
                {
                    if (element != null)
                    {
                        element.Validate();
                    }
                }
            }
        }
    }
}
