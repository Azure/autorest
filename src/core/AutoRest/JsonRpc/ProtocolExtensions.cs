
using System;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Perks.JsonRPC
{
    public static class ProtocolExtensions {
        private static Type[] primitives = new Type[] { typeof(bool), typeof(int),typeof(float), typeof(double), typeof(short), typeof(long), typeof(ushort), typeof(uint), typeof(ulong), typeof(byte),typeof(sbyte)};
        private static bool IsPrimitive( this object value ) => primitives.Contains(value.GetType());

        ///<Summary>
        /// Ensures a given string is safe to transport in JSON
        ///</Summary>
        static string ToLiteral(string input) {
          return string.IsNullOrEmpty(input) ?
            input:
            input.
              Replace( "\\","\\\\" ). // backslashes
              Replace( "\"","\\\"" ). // quotes
              Replace( "\0","\\0" ).  // nulls
              Replace( "\a","\\a" ).  // alert
              Replace( "\b","\\b" ).  // backspace
              Replace( "\f","\\f" ).  // formfeed
              Replace( "\n","\\n" ).  // newline
              Replace( "\r","\\r" ).  // return
              Replace( "\t","\\t" ).  // tab
              Replace( "\v","\\v" );  // vertical tab
        }

        ///<Summary>
        /// Converts the value to a Primitive and reutrns the JSON Primitive equivalent
        ///</Summary>
        internal static string Quote(this object value) => 
            value == null ? "null":                                                // null values
              primitives.Contains(value.GetType()) ? value.ToString().ToLower() :  // primitive values (number,boolean)
              $"\"{ToLiteral(value.ToString())}\"";                                // everything else.
        
        ///<Summary>
        /// Converts the value to an object/string/primitive representation 
        ///</Summary>
        internal static string ToJsonValue( this object value ) =>
          value == null || value is string || value.IsPrimitive() ?   // if this is simple or primitive
            Quote(value) :                                            // just return the formatted valuue
            Newtonsoft.Json.JsonConvert.SerializeObject(value);       // otherwise serialize it.

        ///<Summary>
        /// Creates a comma-separated Json Object notation { ... } from the array of strings
        ///</Summary>
        private static string JsonObject(params string[] members ) =>
           $"{{{members.Aggregate((c,e) =>$"{c},{e}")}}}";
        
        ///<Summary>
        /// creates a comma-separated Json Array notation [ ... ] from the array of values
        ///</Summary>
        internal static string JsonArray( this IEnumerable<object> values ) => 
            $"[{values.Select(ToJsonValue).Aggregate((c,e) => $"{c},{e}")}]";

        ///<Summary>
        /// Returns a quoted string and a serialized value for a key/value pair {"key": "value" }
        ///</Summary>
        internal static string MemberValue(this string key, object value) => MemberObject(key,ToJsonValue(value));
        
        ///<Summary>
        /// Returns a quotes string and the value for a key/value pair (rawValue must be JSON encoded already)
        ///</Summary>
        private static string MemberObject(this string key, string rawValue) => $"{Quote(key)}:{rawValue}";

        ///<Summary>
        /// Returns the JSON-RPC protocol pair
        ///</Summary>
        private static string Protocol = MemberValue("jsonRpc","2.0");
        
        ///<Summary>
        /// Formats 'id' member
        ///</Summary>
        private static string Id(this string id) => MemberValue("id",id);

        ///<Summary>
        /// Formats 'result' member
        ///</Summary>
        private static string Result(this string rawValue) => MemberObject("result",rawValue);
        
        ///<Summary>
        /// Formats 'method' member
        ///</Summary>
        private static string Method(this string value) => MemberValue("method",value);
        
        
        ///<Summary>
        /// Formats 'params' member for an array of value
        ///</Summary>
        private static string Params(this IEnumerable<object> values) => Params(values.JsonArray());

        ///<Summary>
        /// Formats a 'params' member for a previously-json-formatted rawContent value
        ///</Summary>
        private static string Params(this string rawContent) =>  $"{Quote("params")}:{rawContent}";

        ///<Summary>
        /// Generates a Response JSON object
        ///</Summary>
        internal static string Response (string id, string result) => 
            JsonObject(
              Protocol,
              Id(id),
              Result(result)
            );
            
        ///<Summary>
        /// Generates an Error JSON object
        ///</Summary>
        internal static string Error( string id,  int code, string message ) =>
            JsonObject(
              Protocol,
              Id(id),
              MemberObject( "error", JsonObject(MemberValue("code", code),
              MemberValue("message",message)
            )));

        ///<Summary>
        /// Generates a Notification JSON object (array parameters syntax)
        ///</Summary>
        public static string Notification(string methodName, params object[] values ) => 
          values == null || values.Length == 0 ?
            // without any values, this doesn't need parameters
            ProtocolExtensions.JsonObject(Protocol,methodName.Method()):

            // with values 
            ProtocolExtensions.JsonObject(Protocol,methodName.Method(),Params(values));

        ///<Summary>
        /// Generates a Notification JSON object (object parameter syntax)
        ///</Summary>    
        public static string NotificationWithObject(string methodName, object parameter ) =>
          parameter == null || parameter is string || parameter.IsPrimitive() ? 
            // if you pass in null, a string, or a primitive
            // this has to be passed as an array
            ProtocolExtensions.JsonObject(Protocol,methodName.Method(),Params(new[]{parameter})):
            
            // pass as an object
            ProtocolExtensions.JsonObject(Protocol,methodName.Method(),Params(parameter.ToJsonValue()));        

        ///<Summary>
        /// Generates a Request JSON object (array syntax)
        ///</Summary>
        public static string Request(string id, string methodName, params object[] values ) => 
          values == null || values.Length == 0 ?
            // without any values, this doesn't need parameters
            ProtocolExtensions.JsonObject(Protocol,methodName.Method(),Id(id)):
            
            // with values 
            ProtocolExtensions.JsonObject(Protocol,methodName.Method(),Params(values),Id(id));
            
        ///<Summary>
        /// Generates a Request JSON object (object parameter syntax)
        ///</Summary>
        public static string RequestWithObject(string id, string methodName, object parameter ) =>
          parameter == null || parameter is string || parameter.IsPrimitive() ? 
            // if you pass in null, a string, or a primitive
            // this has to be passed as an array
            ProtocolExtensions.JsonObject(Protocol,methodName.Method(),Params(new[]{parameter}),Id(id)):
            
            // pass as an object
            ProtocolExtensions.JsonObject(Protocol,methodName.Method(),Params(parameter.ToJsonValue()), Id(id));
    }
}
