using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

namespace Microsoft.Perks.JsonRPC
{
    public class Connection : IDisposable{
        private TextWriter _writer;
        private PeekingTextReader _reader; 
        private bool _isDisposed = false; 
        private int _requestId;
        private Dictionary<string, ICallerResponse> _tasks = new Dictionary<string, ICallerResponse>(); 
        
        private Task _loop;

        public event Action<string> OnDebug; 

        public Connection(TextWriter writer, TextReader reader ) {
            _writer = writer;
            _reader = new PeekingTextReader(reader);
            _loop = Task.Factory.StartNew(Listen);
        }

        private CancellationTokenSource _cancellationTokenSource = new CancellationTokenSource();
        private CancellationToken  _cancellationToken=> _cancellationTokenSource.Token;
        public bool IsAlive => !_cancellationToken.IsCancellationRequested && _writer != null && _reader != null;

        public void Stop() {
          _cancellationTokenSource.Cancel();
        }

        private async Task<JToken> ReadJson() {
            var jsonText = string.Empty;
            JToken json = null;
            while( json == null ) {
                jsonText += await _reader.ReadLineAsync(); // + "\n";
                if( jsonText.StartsWith("{") && jsonText.EndsWith("}") ) {
                    // try to parse it.
                    try {
                        json = JObject.Parse(jsonText);
                        if( json != null) {
                            return json;
                        }
                    } catch {
                        // not enough text?
                    }
                } else if( jsonText.StartsWith("[") && jsonText.EndsWith("]") ) {
                    // try to parse it.
                    // Log($"It's an array (batch!)");
                    try {
                        json = JArray.Parse(jsonText);
                        if( json != null) {
                            return json;
                        }
                    } catch {
                        // not enough text?
                    }
                }
            }
            return json;
        }
        private Dictionary<string,Func<JToken,Task<string>>> _dispatch = new Dictionary<string,Func<JToken,Task<string>>>();
        public void Dispatch<T>(string path, Func<Task<T>> method) {
          _dispatch.Add(path, async (input)=>{
            var result = await method();
            if( result == null) {
              return "null";
            }
            return JsonConvert.SerializeObject(result);
          });
        }

        public void Dispatch(string path, Func<Task<string>> method) {
          _dispatch.Add(path, async (input)=>{
            var result = await method();
            if( result == null) {
              return "null";
            }
            return ProtocolExtensions.Quote(result);
          });
        }
        
        private JToken[] ReadArguments(JToken input, int expectedArgs ) {
          var args = (input as JArray)?.ToArray();
          var arg = (input as JObject);

          if( expectedArgs == 0 ) {
            if( args == null && arg == null )  {
              // expected zero, recieved zero
              return new JToken[0];
            }
            
            throw new Exception($"Invalid nubmer of arguments {args.Length} or argument object passed '{arg}' for this call. Expected {expectedArgs}");
          }

          if(args.Length == expectedArgs) {
            // passed as an array
            return args;
          }

          if( expectedArgs == 1 ) {
            if( args.Length == 0 && arg != null ) {
              // passed as an object
              return  new JToken[] { arg };
            }
          }

          throw new Exception($"Invalid nubmer of arguments {args.Length} for this call. Expected {expectedArgs}");
        }

        public void DispatchNotification(string path, Action method ) {
          _dispatch.Add( path, async (input)=> {
            method();
            return null;
          });
        }

        public void Dispatch<P1,T>(string path, Func<P1,Task<T>> method) {
        }

        public void Dispatch<P1,P2,T>(string path, Func<P1,P2,Task<T>> method) {
           _dispatch.Add(path, async (input)=>{
            var args = ReadArguments(input,2);
            var a1 = args[0].Value<P1>();
            var a2 = args[1].Value<P2>();

            var result = await method(a1,a2);
            if( result == null) {
              return "null";
            }
            return ProtocolExtensions.ToJsonValue(result);
          });
        }
        
        private async Task<JToken> ReadJson(int contentLength) {
            var buffer = new char[contentLength+1];
            var chars = await _reader.ReadAsync(buffer, 0, contentLength);
            while( chars < contentLength) {
                chars += await _reader.ReadAsync( buffer, chars, contentLength - chars );
            }
            var jsonText = new String(buffer);
            if( jsonText.StartsWith("{")) {
                return JObject.Parse(jsonText);
            }
            return JArray.Parse(jsonText);
        }

        private void Log(string text) {
          if( OnDebug != null ) {
            OnDebug(text);
          }
        }
        
        private async Task<bool> Listen() {
          while( IsAlive ) {
            try {
              //Log("Listen");
              var ch = await _reader?.PeekAsync();
              if( null == ch) {
                  // didn't get anything. start again, it'll know if we're shutting down
                  continue;
              }

              if( '{' == ch || '[' == ch ) {
                  // looks like a json block or array. let's do this.
                  // don't wait for this to finish!
                  Process(await ReadJson());

                  // we're done here, start again.
                  continue;
              }
                  
              // We're looking at headers
              // Log("Found Headers:");
              var headers = new Dictionary<string,string>();
              var line = await _reader.ReadLineAsync();
              while( !string.IsNullOrWhiteSpace(line)) { 
                // Log($"     '{line}'");
                var bits = line.Split(new[]{':'},2);
                if( bits.Length != 2 ) {
                    // Log($"header not right! {line}");
                }
                headers.Add( bits[0].Trim(), bits[1].Trim());
                line = await _reader.ReadLineAsync();
              }

              ch = await _reader?.PeekAsync();
              // the next character had better be a { or [
              if( '{' == ch || '[' == ch ) {
                if( headers.TryGetValue("Content-Length", out string value) && Int32.TryParse( value, out int contentLength) ) {
                    // don't wait for this to finish!
                    Process(await ReadJson(contentLength));
                    continue;
                }
                // looks like a json block or array. let's do this.
                // don't wait for this to finish!
                Process(await ReadJson());
                // we're done here, start again.
                continue;
              }    

              // Log("SHOULD NEVER GET HERE!");
              return false;
            
            } catch(Exception e) {
                if( IsAlive ) {
                    // Log($"Error during Listen {e.GetType().Name}/{e.Message}/{e.StackTrace}");
                    continue;
                }
            }
          }
            return false;
        }

        public async Task Process( JToken content ) {
            // Log("IN PROCESS");
            if( content == null ) {
                // Log("BAD CONTENT");
                return;
            }
            if( content is JObject ) {
                Log($"RECV '{content}'");

                var jobject = content as JObject;
                try {

                    if( jobject.Properties().Any(each => each.Name == "method")) {
                        var method = jobject.Property("method").Value.ToString();
                        var id = jobject.Property("id")?.Value.ToString();
                        // this is a method call.
                        // pass it to the service that is listening...
                        //Log($"Dispatching: {method}");
                        if( _dispatch.TryGetValue(method,out Func<JToken,Task<string>> fn) ) {
                          var parameters = jobject.Property("params").Value;
                          var result = await fn( parameters );
                          if( id != null ) {
                            // if this is a request, send the response.
                            await this.Send( ProtocolExtensions.Response(id, result));
                          }
                          // 
                        }
                        return;
                    }

                    // this is a result from a previous call.
                    if( jobject.Properties().Any(each => each.Name == "result")) {
                        var id = jobject.Property("id")?.Value.ToString();
                        if (!string.IsNullOrEmpty(id))
                        {

                            var f = _tasks[id];
                            _tasks.Remove(id);
                            //Log($"result data: {jobject.Property("result").Value.ToString()}");
                            f.SetCompleted(jobject.Property("result").Value);
                            //Log("Should have unblocked?");
                        }
                        
                    }

                } catch( Exception e ) {
                    //Log($"[PROCESS ERROR]: {e.GetType().FullName}/{e.Message}/{e.StackTrace}");
                    //Log($"[LISTEN CONTENT]: {jobject.ToString()}");
                }
            }
            if( content is JArray) {
                //Log("TODO: Batch");
                return;
            }
        }

        // This code added to correctly implement the disposable pattern.
        public void Dispose()
        {
            Dispose(true);
        }

        protected virtual void Dispose(bool disposing)
        {
            // ensure that we are in a cancelled state.
            _cancellationTokenSource?.Cancel();
            if (!_isDisposed)
            {
                // make sure we can't dispose twice
                _isDisposed = true;
                if (disposing)
                {
                    foreach( var t in _tasks.Values ) {
                        t.SetCancelled();
                    }

                    _writer?.Dispose();
                    _writer = null;
                    _reader?.Dispose();
                    _reader = null;

                    _cancellationTokenSource?.Dispose();
                    _cancellationTokenSource = null;
                }
            }
        }

        private readonly Semaphore _streamReady = new Semaphore(1, 1);
        private async Task Send( string text ) { 
            _streamReady.WaitOne();
            Log($"SEND {text}");
            await _writer.WriteAsync( $"Content-Length: {text.Length}\r\n\r\n");
            await  _writer.WriteAsync(text);
            _streamReady.Release();
        }

        public async Task SendError(string id, int code, string message) {
            await Send( ProtocolExtensions.Error(id, code, message)).ConfigureAwait(false);
        }
        public async Task Respond(string request, string value ) {
            await Send( ProtocolExtensions.Response(request, value ) ).ConfigureAwait(false);
        }

        public async Task Notify(string methodName, params object[] values ) => 
            await Send( ProtocolExtensions.Notification(methodName, values) ).ConfigureAwait(false);
        public async Task NotifyWithObject(string methodName, object parameter ) =>
            await Send( ProtocolExtensions.NotificationWithObject( methodName, parameter)).ConfigureAwait(false);
     
        public async Task<T> Request<T>(string methodName, params object[] values ) {
            var id = Interlocked.Increment(ref _requestId).ToString();
            var response =  new CallerResponse<T>(id);
            _tasks.Add( id,response);
            await Send( ProtocolExtensions.Request(id, methodName, values)).ConfigureAwait(false);
            return await response.Task.ConfigureAwait(false);
        }

        public async Task<T> RequestWithObject<T>(string methodName, object parameter ) {
            var id = Interlocked.Increment(ref _requestId).ToString();
            var response =  new CallerResponse<T>(id);
            _tasks.Add( id,response);
            await Send( ProtocolExtensions.Request(id, methodName, parameter)).ConfigureAwait(false);
            return await response.Task.ConfigureAwait(false);
        }

        public async Task Batch(IEnumerable<string> calls ) =>
            await Send( calls.JsonArray() );

        public System.Runtime.CompilerServices.TaskAwaiter GetAwaiter() => _loop.GetAwaiter();



    }
}