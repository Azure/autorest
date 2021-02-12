import * as assert from "assert";
import * as path from "path";
import {
  parseFile,
  compareFile,
  extractSourceDetails,
  SourceDetails
} from "../../src/languages/python";
import { MessageType } from "../../src/comparers";

describe.only("Python Parser", function() {
  it("extracts semantic elements from source", function() {
    const parseTree = parseFile(
      path.resolve(__dirname, "../artifacts/python/old/models.py")
    );
    const sourceDetails: SourceDetails = extractSourceDetails(parseTree);

    assert.deepEqual(sourceDetails, {
      classes: [
        {
          name: "Error",
          superclasses: [
            {
              name: "msrest.serialization.Model"
            }
          ],
          methods: [
            {
              name: "__init__",
              body:
                "super(Error, self).__init__(**kwargs)\n        self.status = status\n        self.message = message",
              parameters: [
                {
                  name: "self",
                  type: undefined,
                  defaultValue: undefined
                },
                {
                  name: "*",
                  type: undefined,
                  defaultValue: undefined
                },
                {
                  name: "status",
                  type: "Optional[int]",
                  defaultValue: "None"
                },
                {
                  name: "message",
                  type: "Optional[str]",
                  defaultValue: "None"
                },
                {
                  name: "**kwargs",
                  type: undefined,
                  defaultValue: undefined
                }
              ],
              returnType: undefined
            }
          ],
          assignments: [
            {
              name: "_attribute_map",
              value:
                "{\n        'status': {'key': 'status', 'type': 'int'},\n        'message': {'key': 'message', 'type': 'str'},\n    }"
            }
          ]
        },
        {
          name: "RefColorConstant",
          superclasses: [
            {
              name: "msrest.serialization.Model"
            }
          ],
          assignments: [
            {
              name: "color_constant",
              value: '"green-color"'
            }
          ],
          methods: [
            {
              name: "__init__",
              body:
                "super(RefColorConstant, self).__init__(**kwargs)\n        self.field1 = field1",
              parameters: [
                {
                  name: "self",
                  type: undefined,
                  defaultValue: undefined
                },
                {
                  name: "*",
                  type: undefined,
                  defaultValue: undefined
                },
                {
                  name: "field1",
                  type: "Optional[str]",
                  defaultValue: "None"
                },
                {
                  name: "**kwargs",
                  type: undefined,
                  defaultValue: undefined
                }
              ],
              returnType: undefined
            }
          ]
        }
      ]
    });
  });

  it("compares source files and finds changes", () => {
    const basePath = path.resolve(__dirname, "../artifacts/python");
    const compareResult = compareFile(
      {
        name: "models.py",
        basePath: basePath + "/old/"
      },
      {
        name: "models.py",
        basePath: basePath + "/new/"
      }
    );

    assert.deepEqual(compareResult, {
      message: "models.py",
      type: MessageType.Changed,
      children: [
        {
          message: "Classes",
          type: MessageType.Outline,
          children: [
            {
              message: "Error",
              type: MessageType.Changed,
              children: [
                {
                  message: "Superclasses",
                  type: MessageType.Outline,
                  children: [
                    {
                      message: "msrest.serialization.Model",
                      type: MessageType.Removed
                    },
                    {
                      message: "msrest.serialization.Model2",
                      type: MessageType.Added
                    }
                  ]
                },
                {
                  message: "Methods",
                  type: MessageType.Outline,
                  children: [
                    {
                      message: "__init__",
                      type: MessageType.Changed,
                      children: [
                        {
                          message: "Parameters",
                          type: MessageType.Outline,
                          children: [
                            {
                              message: "message",
                              type: MessageType.Changed,
                              children: [
                                {
                                  message: "Default Value",
                                  type: MessageType.Outline,
                                  children: [
                                    {
                                      message: "None",
                                      type: MessageType.Removed
                                    },
                                    {
                                      message: '"gorp"',
                                      type: MessageType.Added
                                    }
                                  ]
                                }
                              ]
                            }
                          ]
                        }
                      ]
                    }
                  ]
                },
                {
                  message: "Fields",
                  type: MessageType.Outline,
                  children: [
                    {
                      message: "_EXCEPTION_TYPE",
                      type: MessageType.Added
                    },
                    {
                      message: "_attribute_map",
                      type: MessageType.Changed,
                      children: [
                        {
                          message: "Value",
                          type: MessageType.Outline,
                          children: [
                            {
                              message: "{\n",
                              type: MessageType.Plain
                            },
                            {
                              message:
                                "        'status': {'key': 'status', 'type': 'int'},\n",
                              type: MessageType.Removed
                            },
                            {
                              message:
                                "        'status': {'key': 'status', 'type': 'str'},\n",
                              type: MessageType.Added
                            },
                            {
                              message:
                                "        'message': {'key': 'message', 'type': 'str'},\n    }",
                              type: MessageType.Plain
                            }
                          ]
                        }
                      ]
                    }
                  ]
                }
              ]
            },
            {
              message: "RefColorConstant",
              type: MessageType.Changed,
              children: [
                {
                  message: "Superclasses",
                  type: MessageType.Outline,
                  children: [
                    {
                      message: "msrest.serialization.Model",
                      type: MessageType.Removed
                    },
                    {
                      message: "msrest.serialization.Model2",
                      type: MessageType.Added
                    }
                  ]
                },
                {
                  message: "Methods",
                  type: 0,
                  children: [
                    {
                      message: "__init__",
                      type: 4,
                      children: [
                        {
                          message: "Parameters",
                          type: 0,
                          children: [
                            {
                              message: "field1",
                              type: 4,
                              children: [
                                {
                                  message: "Default Value",
                                  type: 0,
                                  children: [
                                    {
                                      message: "None",
                                      type: 3
                                    },
                                    {
                                      message: "22",
                                      type: 2
                                    }
                                  ]
                                }
                              ]
                            }
                          ]
                        },
                        {
                          message: "Body",
                          type: 0,
                          children: [
                            {
                              message:
                                "super(RefColorConstant, self).__init__(**kwargs)\n        self.field1 = field1",
                              type: 3
                            },
                            {
                              message: "InvalidButOK",
                              type: 2
                            }
                          ]
                        }
                      ]
                    }
                  ]
                },
                {
                  message: "Fields",
                  type: MessageType.Outline,
                  children: [
                    {
                      message: "color_constant",
                      type: MessageType.Changed,
                      children: [
                        {
                          message: "Value",
                          type: MessageType.Outline,
                          children: [
                            {
                              message: '"green-color"',
                              type: MessageType.Removed
                            },
                            {
                              message: '"purple-color"',
                              type: MessageType.Added
                            }
                          ]
                        }
                      ]
                    },
                    {
                      message: "other_thing",
                      type: MessageType.Added
                    },
                    {
                      message: "self.field1",
                      type: MessageType.Added
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    });
  });
});
