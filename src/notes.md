# Pipeline:

  [STEP]: Load each input file  (convert OAI2 to OAI3 on the fly)

  input-files: (... )
  LOADEROAI2 => TRANSFORM => SCHEMAVALIDATOROAI2 => CONVERT ...
                                                                 >    TRANSFORM => Tree Shaker => (merge or compose)...
  LOADEROAI3 => TRANSFORM => SCHEMAVALIDATOROAI3 =>         ...

                                                  ^...(compose-special) => linter/model-validator


   https://github.com/Azure/azure-openapi-arm-validator

  [STEP] - ALL INPUTS ARE NOT OAI3

  [the converted file] /de => /com/schem
/


abc.json
  dog:
    $ref: abs.vde.json#doggy
    $ref: abs.vde.json#catty
  cat:
    $ref: abs.sim.json#some

  get a list of references to visit.


vde.json
x-ms-secondary-file:true
  doggy:
    $ref: fre.son#lol
  stuff:
    $ref: xyz.json#pop

xyz.json
    pop:





  [STEP]: Tree Shaker: (many-inputs)
    - take each file and move everything to /components/* and have no-inlined items at all (same process as remodeler)
    OUTPUT: ``

  generators make the choice by referencing the merge :

  - [STEP] Merge Step: (many-inputs) -- current generators (aka 'composer')
      - merging must be conflict free (since we're not going to adjust the OAI3 format)
      OUTPUT: `openapi-document/identity`

  - [STEP] Merge Step: (many-inputs) -- new modeler required (aka 'profilizer')
    - turn Maps into arrays (with no JsonPointer $refs left, this is totally cool.) components.schemas..[@_key_ == 'UNIQUEID']
    - add `x-ms-metadata` on every operation, parameter, schema (component?),
      (ensure that each x-ms-metadata gets a generated unique ID# )

    - take all the inputs and merge them into a single OAI3-like doc
    - change $refs JsonPointer to point to the unique reference instead via JsonPath.

    OUTPUT: `flat-openapi-document/identity`

    - [STEP] deduplicator
      walk thru all the models and consolodate duplicates.


  Modeler : 'imodeler2'
    INPUT: `flat-openapi-document/identity`
    OUTPUT: `code-model-v1` (+with metadata);


- Add a means to do something like DataSource.skip:
  if a plugin, and all the child plugins are marked 'drain: false' then act like skip mode.
  -

paths:  {
  "/foo/x" : {
    "operationId": "xxx",
    "other thing": "xxx"
  }
  "/foo/y" : {
    "operationId": "yyy",
    "other thing": "yyy"
  }
}

paths: [
  {
    _key_: '/foo/x',
    x-ms-metadata: {
      version: 2017-01-01
      source: ...json
    }

    "operationId": "xxx",
    "other thing": "xxx"
  },
  {
    _key_: '/foo/x',
    x-ms-metadata: {
      version: 2018-01-01
      source: ...json
    }
    "operationId": "xxx",
    "other thing": "xxx"
  },
  {
    _key_: '/foo/y',
    "operationId": "yyy",
    "other thing": "yyy"
    "parameters" : [
      "foo": {
        "$ref" : "#/components/parameter/foo
      },
      {

      }

    ]
  },
]
