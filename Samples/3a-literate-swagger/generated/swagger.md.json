{
  "swagger": "2.0",
  "info": {
    "title": "Search Management",
    "description": "This client that can be used to manage Azure Search services and API keys.\n\nASd\n\n- ASd\n- qawe\n",
    "version": "2015-02-28"
  },
  "host": "management.azure.com",
  "schemes": [
    "https"
  ],
  "consumes": [
    "application/json"
  ],
  "produces": [
    "application/json"
  ],
  "security": [
    {
      "azure_auth": [
        "user_impersonation"
      ]
    }
  ],
  "securityDefinitions": {
    "azure_auth": {
      "type": "oauth2",
      "authorizationUrl": "https://login.microsoftonline.com/common/oauth2/authorize",
      "flow": "implicit",
      "description": "Azure Active Directory OAuth2 Flow",
      "scopes": {
        "user_impersonation": "impersonate your user account"
      }
    }
  },
  "paths": {
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}/listQueryKeys": {
      "get": {
        "tags": [
          "QueryKeys"
        ],
        "operationId": "QueryKeys_List",
        "description": "Returns the list of query API keys for the given Azure Search service.",
        "externalDocs": {
          "url": "https://msdn.microsoft.com/library/azure/dn832701.aspx"
        },
        "parameters": [
          {
            "$ref": "#/parameters/ResourceGroupName"
          },
          {
            "$ref": "#/parameters/SearchServiceName"
          },
          {
            "$ref": "#/parameters/ApiVersion"
          },
          {
            "$ref": "#/parameters/SubscriptionId"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/ListQueryKeysResult"
            }
          },
          "default": {
            "$ref": "#/responses/error"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{serviceName}": {
      "put": {
        "tags": [
          "Services"
        ],
        "operationId": "Services_CreateOrUpdate",
        "description": "Creates or updates a Search service in the given resource group.\nIf the Search service already exists, all properties will be updated with the given values.",
        "externalDocs": {
          "url": "https://msdn.microsoft.com/library/azure/dn832687.aspx"
        },
        "parameters": [
          {
            "$ref": "#/parameters/ResourceGroupName"
          },
          {
            "$ref": "#/parameters/SearchServiceName"
          },
          {
            "name": "parameters",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/SearchServiceCreateOrUpdateParameters"
            },
            "description": "#parameter-parameters"
          },
          {
            "$ref": "#/parameters/ApiVersion"
          },
          {
            "$ref": "#/parameters/SubscriptionId"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/SearchServiceResource"
            }
          },
          "201": {
            "description": "Created",
            "schema": {
              "$ref": "#/definitions/SearchServiceResource"
            }
          },
          "default": {
            "$ref": "#/responses/error"
          }
        }
      },
      "delete": {
        "tags": [
          "Services"
        ],
        "operationId": "Services_Delete",
        "description": "Deletes a Search service in the given resource group, along with its associated resources.",
        "externalDocs": {
          "url": "https://msdn.microsoft.com/library/azure/dn832692.aspx"
        },
        "parameters": [
          {
            "$ref": "#/parameters/ResourceGroupName"
          },
          {
            "$ref": "#/parameters/SearchServiceName"
          },
          {
            "$ref": "#/parameters/ApiVersion"
          },
          {
            "$ref": "#/parameters/SubscriptionId"
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          },
          "204": {
            "description": "No Content"
          },
          "404": {
            "description": "Not Found"
          },
          "default": {
            "$ref": "#/responses/error"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices": {
      "get": {
        "tags": [
          "Services"
        ],
        "operationId": "Services_List",
        "description": "Returns a list of all Search services in the given resource group.",
        "externalDocs": {
          "url": "https://msdn.microsoft.com/library/azure/dn832688.aspx"
        },
        "parameters": [
          {
            "$ref": "#/parameters/ResourceGroupName"
          },
          {
            "$ref": "#/parameters/ApiVersion"
          },
          {
            "$ref": "#/parameters/SubscriptionId"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/SearchServiceListResult"
            }
          },
          "default": {
            "$ref": "#/responses/error"
          }
        }
      }
    }
  },
  "definitions": {
    "ListQueryKeysResult": {
      "properties": {
        "value": {
          "readOnly": true,
          "type": "array",
          "items": {
            "$ref": "#/definitions/QueryKey"
          },
          "description": "The query keys for the Azure Search service."
        }
      },
      "description": "Response containing the query API keys for a given Azure Search service.\n\n##### Examples\nI am content under a subheading "
    },
    "QueryKey": {
      "properties": {
        "name": {
          "readOnly": true,
          "type": "string",
          "description": "The name of the query API key; may be empty."
        },
        "key": {
          "readOnly": true,
          "type": "string",
          "description": "The value of the query API key."
        }
      },
      "description": "Describes an API key for a given Azure Search service that has permissions for query operations only."
    },
    "SearchServiceProperties": {
      "properties": {
        "replicaCount": {
          "type": "integer",
          "format": "int32",
          "minimum": 1,
          "maximum": 6,
          "description": "The number of replicas in the Search service."
        },
        "partitionCount": {
          "type": "integer",
          "format": "int32",
          "description": "The number of partitions in the Search service; if specified, it can be 1, 2, 3, 4, 6, or 12."
        }
      },
      "description": "Defines properties of an Azure Search service that can be modified."
    },
    "SearchServiceCreateOrUpdateParameters": {
      "properties": {
        "location": {
          "type": "string",
          "description": "The geographic location of the Search service."
        },
        "tags": {
          "type": "object",
          "additionalProperties": {
            "type": "string"
          },
          "description": "Tags to help categorize the Search service in the Azure Portal."
        },
        "properties": {
          "$ref": "#/definitions/SearchServiceProperties",
          "description": "Properties of the Search service."
        }
      },
      "description": "Properties that describe an Azure Search service."
    },
    "SearchServiceResource": {
      "properties": {
        "id": {
          "readOnly": true,
          "type": "string",
          "description": "The resource Id of the Azure Search service."
        },
        "name": {
          "externalDocs": {
            "url": "https://msdn.microsoft.com/library/azure/dn857353.aspx"
          },
          "type": "string",
          "description": "The name of the Search service."
        },
        "location": {
          "type": "string",
          "description": "The geographic location of the Search service."
        },
        "tags": {
          "type": "object",
          "additionalProperties": {
            "type": "string"
          },
          "description": "Tags to help categorize the Search service in the Azure Portal."
        }
      },
      "description": "Describes an Azure Search service and its current state."
    },
    "SearchServiceListResult": {
      "properties": {
        "value": {
          "readOnly": true,
          "type": "array",
          "items": {
            "$ref": "#/definitions/SearchServiceResource"
          },
          "description": "The Search services in the resource group."
        }
      },
      "description": "Response containing a list of Azure Search services for a given resource group."
    },
    "Error": {
      "type": "object",
      "properties": {
        "code": {
          "type": "integer"
        },
        "message": {
          "type": "string"
        },
        "details": {
          "schema": {
            "$ref": "#/definitions/ErrorDetails"
          }
        }
      }
    },
    "ErrorDetails": {
      "properties": {
        "code": {
          "type": "string"
        },
        "target": {
          "type": "string"
        },
        "message": {
          "type": "string"
        }
      }
    }
  },
  "parameters": {
    "SubscriptionId": {
      "name": "subscriptionId",
      "in": "path",
      "required": true,
      "type": "string",
      "description": "Gets subscription credentials which uniquely identify Microsoft Azure subscription.\nThe subscription ID forms part of the URI for every service call."
    },
    "ApiVersion": {
      "name": "api-version",
      "in": "query",
      "required": true,
      "type": "string",
      "description": "The client API version."
    },
    "ResourceGroupName": {
      "name": "resourceGroupName",
      "in": "path",
      "required": true,
      "type": "string",
      "x-ms-parameter-location": "method",
      "description": "The name of the resource group within the current subscription."
    },
    "SearchServiceName": {
      "name": "serviceName",
      "in": "path",
      "required": true,
      "type": "string",
      "x-ms-parameter-location": "method",
      "description": "The name of the Search service to operate on."
    }
  },
  "responses": {
    "error": {
      "description": "OK",
      "schema": {
        "$ref": "#/definitions/Error"
      }
    }
  }
}