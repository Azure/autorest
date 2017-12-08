# Code Generation Modifiers

We need to be able to make an alias for a method and/or model types that the spec has changed, but the generated code should still contain methods/model types that are binary compatible with the original interface.

This generally affects openapi specs that are being corrected or updated to conform to standards, yet an sdk has been released with method or model types that are not correct to our standards, yet but we don't want to break compatibility.


## Scenarios to solve:
 Preserving binary compatibility when something is deleted:
 
 Properties: 
 - Add an arbitrary property that isn't in the wire format
 - Add an alias property that is wired to a different property
 - Mark a property as deprecated
 - Alter the type of a property ( used to be boolean, now an enum)
 - customize visibility (protected, public, private)

Operation:
  - Alias to another method
  - deprecate a method
  - create a do-nothing implementation (that returns a canned/default response? An exception? A warning?)
  - customize visibility
  

Models:
  - New Model Type
  - Mark a model as deprecated
  - customize model properties

 



!~~~ markdown

# Sample API
> see https://aka.ms/autorest

We're adding some new stuff to the code model here.


## Components section for declaritively creating new things in the code model.

``` yaml
components: # identifies items to be inserted into the code model.

  schemas: # schema items (models) that can be inserted
           # elements are: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#schema-object
    Cat: # add
      type: object
      properties:
        id: 
          type: integer
          format: int64 
        name:
          type: string
        shoeSize:
          forward-to: sizeOfShoe
        tailColor:
          implementation: 
            csharp: |
            {
              foo
            }
```            
              

``` yaml 
  # example, add some reusable parameters

components:
  parameters: # reusable parameters 
              # elements are a subset of https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#parameter-object 
    UserName:
      name: username
      description: the new users username 
      required: true
      schema:
        type: string

    Password:
      name: password
      description: their password
      required: true
      schema:
        type: string
```

``` yaml $(for-back-compat)
  # example, add some new operations...

components:
  operations: # operations to add to the code model
    - operationId: DoSomething: # operation name
      operationGroup: MyFunx    # operation group
      forward-to: GoSomewhere # creates an alias implementation that forwards to a different method

    - operationId: DoSomethingElse: # operation name
      operationGroup: MyFunx    # operation group
      deprecated: true
      visibility: 
        - protected
        - internal  

      parameters: 
       - $ref: "#/components/parameters/UserName"
       - $ref: "#/components/parameters/Password"

      implemention: 
        csharp: |
          {
            password = rot13(password);
            return this.DoSomething(username,password);
          }
        python: |
          password = bla.indentation.bla.self.bla.rot13(password)
          return self.DoSomething(username, password)
        ruby: |
          password = password if rot13 
        nodejs: |
          {
            return this.DoSomething(username,rot13(password))
          }
```

### Directives for Removing or Renaming operations

``` yaml 
directive:
  # remove a method 
  - remove-operation: myFunx_doSomething

  # rename a method
  - rename-operation: 
    from: myFunx_newMethod
    to: myFunx_doSomething

```
  










!~~~




Random thoughts:

~~~ markdown

# Sample API
> see https://aka.ms/autorest

``` yaml
directive: 
  - where-model: Cat
    property: Breed
      set: 
        name: TheBreed

  - where-model: Dog
    create-property: 
      name: Face
      type: FaceType 

  - where-operation: Petstore_close
    deprecate: true
    create-alias: CloseStore
    
  - where-operation: operations_ListOperationsByMyFriend
    


  - add-operation-group: MyFunx
  
  - where-operation-group: MyFunx
    set:
      deprecated: true
      client-name: foobarbinbaz
      protected: true

  - where-operation-group: MyFunx
    add-operation: 
      name: DoFantastic


  
      
      


  from: code-model-v1
  where: $..operationid[...]
  alias:
    name: operations_ListOperations
    deprecated: true


```

~~~