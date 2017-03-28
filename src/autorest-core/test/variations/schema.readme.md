# AutoRest configuration schema

``` yaml
version: <semver>|latest|current...
  # version of autorest to use 

azure-arm: false|true
  # false - is not an azure resource - no azure rules apply
  # true - is intended to be an azure resource
  
process: single|composite|both 
  # when processing multiple swagger input documents:
  # single - process each document independently
  # composite - merge the input files into a single swagger document
  # both - run each one independently, and merge them as a composite document and run that too.

output-folder: <path>

namespace: <string> 
  # the code namespace to generate the target files into

directive: #array of directives:
  - from: <document-identity>             # document-id to match (swagger 'title' )
    where: <document-query>               # jsonpath query to match 
    reason: <string>                      # [?]comment as to why this directive is added
    # one of:
    supress: <message-id to suppress>     # suppress messages with matching message-id and this selection node
    set: <document-change>                # modify DOM with change before sending to plugin
    transform: <document-transformation>  # modify document via code before sending to plugin
```


### Built-in meta-variables 
``` yaml

base-folder: 
  # the folder that the configuration file is installed in.

document:identity: 
  # the name of the current document being processed (in swagger, this is the 'title' )
```

### Plugins:
``` yaml
# specifing a plugin in the configuration will make that 
<plugin-name>: 


```