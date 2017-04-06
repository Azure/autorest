{
  "swagger": "2.0",
  "info": {
    "title": "LogicManagementClient",
    "description": "REST API for Azure Logic Apps.",
    "version": "2016-06-01"
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
      "description": "Azure Active Directory OAuth2 Flow.",
      "scopes": {
        "user_impersonation": "impersonate your user account"
      }
    }
  },
  "paths": {
    "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/workflows": {
      "get": {
        "tags": [
          "Workflows"
        ],
        "operationId": "Workflows_ListBySubscription",
        "description": "Gets a list of workflows by subscription.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          },
          {
            "name": "$filter",
            "description": "The filter to apply on the operation.",
            "in": "query",
            "required": false,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        },
        "x-ms-odata": "#/definitions/WorkflowFilter"
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows": {
      "get": {
        "tags": [
          "Workflows"
        ],
        "operationId": "Workflows_ListByResourceGroup",
        "description": "Gets a list of workflows by resource group.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          },
          {
            "name": "$filter",
            "description": "The filter to apply on the operation.",
            "in": "query",
            "required": false,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        },
        "x-ms-odata": "#/definitions/WorkflowFilter"
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}": {
      "get": {
        "tags": [
          "Workflows"
        ],
        "operationId": "Workflows_Get",
        "description": "Gets a workflow.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/Workflow"
            }
          }
        }
      },
      "put": {
        "tags": [
          "Workflows"
        ],
        "operationId": "Workflows_CreateOrUpdate",
        "description": "Creates or updates a workflow.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "workflow",
            "description": "The workflow.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/Workflow"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/Workflow"
            }
          },
          "201": {
            "description": "Created",
            "schema": {
              "$ref": "#/definitions/Workflow"
            }
          }
        }
      },
      "patch": {
        "tags": [
          "Workflows"
        ],
        "operationId": "Workflows_Update",
        "description": "Updates a workflow.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "workflow",
            "description": "The workflow.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/Workflow"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/Workflow"
            }
          }
        }
      },
      "delete": {
        "tags": [
          "Workflows"
        ],
        "operationId": "Workflows_Delete",
        "description": "Deletes a workflow.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          },
          "204": {
            "description": "No Content"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/disable": {
      "post": {
        "tags": [
          "Workflows"
        ],
        "operationId": "Workflows_Disable",
        "description": "Disables a workflow.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/enable": {
      "post": {
        "tags": [
          "Workflows"
        ],
        "operationId": "Workflows_Enable",
        "description": "Enables a workflow.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/generateUpgradedDefinition": {
      "post": {
        "tags": [
          "Workflows"
        ],
        "operationId": "Workflows_GenerateUpgradedDefinition",
        "description": "Generates the upgraded definition for a workflow.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "parameters",
            "description": "Parameters for generating an upgraded definition.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/GenerateUpgradedDefinitionParameters"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/Object"
            }
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions": {
      "get": {
        "tags": [
          "WorkflowVersions"
        ],
        "operationId": "WorkflowVersions_List",
        "description": "Gets a list of workflow versions.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowVersionListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/versions/{versionId}": {
      "get": {
        "tags": [
          "WorkflowVersions"
        ],
        "operationId": "WorkflowVersions_Get",
        "description": "Gets a workflow version.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "versionId",
            "description": "The workflow versionId.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowVersion"
            }
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/": {
      "get": {
        "tags": [
          "WorkflowTriggers"
        ],
        "operationId": "WorkflowTriggers_List",
        "description": "Gets a list of workflow triggers.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          },
          {
            "name": "$filter",
            "description": "The filter to apply on the operation.",
            "in": "query",
            "required": false,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowTriggerListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        },
        "x-ms-odata": "#/definitions/WorkflowTriggerFilter"
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}": {
      "get": {
        "tags": [
          "WorkflowTriggers"
        ],
        "operationId": "WorkflowTriggers_Get",
        "description": "Gets a workflow trigger.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "triggerName",
            "description": "The workflow trigger name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowTrigger"
            }
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/run": {
      "post": {
        "tags": [
          "WorkflowTriggers"
        ],
        "operationId": "WorkflowTriggers_Run",
        "description": "Runs a workflow trigger.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "triggerName",
            "description": "The workflow trigger name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "default": {
            "description": "All status codes are acceptable.",
            "schema": {
              "$ref": "#/definitions/Object"
            }
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/listCallbackUrl": {
      "post": {
        "tags": [
          "WorkflowTriggers"
        ],
        "operationId": "WorkflowTriggers_ListCallbackUrl",
        "description": "Gets the callback URL for a workflow trigger.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "triggerName",
            "description": "The workflow trigger name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowTriggerCallbackUrl"
            }
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories": {
      "get": {
        "tags": [
          "WorkflowTriggerHistories"
        ],
        "operationId": "WorkflowTriggerHistories_List",
        "description": "Gets a list of workflow trigger histories.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "triggerName",
            "description": "The workflow trigger name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          },
          {
            "name": "$filter",
            "description": "The filter to apply on the operation.",
            "in": "query",
            "required": false,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowTriggerHistoryListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        },
        "x-ms-odata": "#/definitions/WorkflowTriggerHistoryFilter"
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/triggers/{triggerName}/histories/{historyName}": {
      "get": {
        "tags": [
          "WorkflowTriggerHistories"
        ],
        "operationId": "WorkflowTriggerHistories_Get",
        "description": "Gets a workflow trigger history.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "triggerName",
            "description": "The workflow trigger name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "historyName",
            "description": "The workflow trigger history name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowTriggerHistory"
            }
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs": {
      "get": {
        "tags": [
          "WorkflowRuns"
        ],
        "operationId": "WorkflowRuns_List",
        "description": "Gets a list of workflow runs.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          },
          {
            "name": "$filter",
            "description": "The filter to apply on the operation.",
            "in": "query",
            "required": false,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowRunListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        },
        "x-ms-odata": "#/definitions/WorkflowRunFilter"
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}": {
      "get": {
        "tags": [
          "WorkflowRuns"
        ],
        "operationId": "WorkflowRuns_Get",
        "description": "Gets a workflow run.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "runName",
            "description": "The workflow run name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowRun"
            }
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/cancel": {
      "post": {
        "tags": [
          "WorkflowRuns"
        ],
        "operationId": "WorkflowRuns_Cancel",
        "description": "Cancels a workflow run.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "runName",
            "description": "The workflow run name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions": {
      "get": {
        "tags": [
          "WorkflowRunActions"
        ],
        "operationId": "WorkflowRunActions_List",
        "description": "Gets a list of workflow run actions.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "runName",
            "description": "The workflow run name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          },
          {
            "name": "$filter",
            "description": "The filter to apply on the operation.",
            "in": "query",
            "required": false,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowRunActionListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        },
        "x-ms-odata": "#/definitions/WorkflowRunActionFilter"
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/workflows/{workflowName}/runs/{runName}/actions/{actionName}": {
      "get": {
        "tags": [
          "WorkflowRunActions"
        ],
        "operationId": "WorkflowRunActions_Get",
        "description": "Gets a workflow run action.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "runName",
            "description": "The workflow run name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "actionName",
            "description": "The workflow action name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/WorkflowRunAction"
            }
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/locations/{location}/workflows/{workflowName}/validate": {
      "post": {
        "tags": [
          "Workflows"
        ],
        "operationId": "Workflows_Validate",
        "description": "Validates the workflow definition.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "location",
            "description": "The workflow location.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "workflowName",
            "description": "The workflow name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "workflow",
            "description": "The workflow definition.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/Workflow"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/providers/Microsoft.Logic/integrationAccounts": {
      "get": {
        "tags": [
          "IntegrationAccounts"
        ],
        "operationId": "IntegrationAccounts_ListBySubscription",
        "description": "Gets a list of integration accounts by subscription.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts": {
      "get": {
        "tags": [
          "IntegrationAccounts"
        ],
        "operationId": "IntegrationAccounts_ListByResourceGroup",
        "description": "Gets a list of integration accounts by resource group.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}": {
      "get": {
        "tags": [
          "IntegrationAccounts"
        ],
        "operationId": "IntegrationAccounts_Get",
        "description": "Gets an integration account.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccount"
            }
          }
        }
      },
      "put": {
        "tags": [
          "IntegrationAccounts"
        ],
        "operationId": "IntegrationAccounts_CreateOrUpdate",
        "description": "Creates or updates an integration account.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "integrationAccount",
            "description": "The integration account.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/IntegrationAccount"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccount"
            }
          },
          "201": {
            "description": "Created",
            "schema": {
              "$ref": "#/definitions/IntegrationAccount"
            }
          }
        }
      },
      "patch": {
        "tags": [
          "IntegrationAccounts"
        ],
        "operationId": "IntegrationAccounts_Update",
        "description": "Updates an integration account.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "integrationAccount",
            "description": "The integration account.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/IntegrationAccount"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccount"
            }
          }
        }
      },
      "delete": {
        "tags": [
          "IntegrationAccounts"
        ],
        "operationId": "IntegrationAccounts_Delete",
        "description": "Deletes an integration account.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          },
          "204": {
            "description": "No Content"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/listCallbackUrl": {
      "post": {
        "tags": [
          "IntegrationAccounts"
        ],
        "operationId": "IntegrationAccounts_GetCallbackUrl",
        "description": "Gets the integration account callback URL.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "parameters",
            "description": "The callback URL parameters.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/GetCallbackUrlParameters"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/CallbackUrl"
            }
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas": {
      "get": {
        "tags": [
          "IntegrationAccountSchemas"
        ],
        "operationId": "Schemas_ListByIntegrationAccounts",
        "description": "Gets a list of integration account schemas.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          },
          {
            "name": "$filter",
            "description": "The filter to apply on the operation.",
            "in": "query",
            "required": false,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountSchemaListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        },
        "x-ms-odata": "#/definitions/IntegrationAccountSchemaFilter"
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/schemas/{schemaName}": {
      "get": {
        "tags": [
          "IntegrationAccountSchemas"
        ],
        "operationId": "Schemas_Get",
        "description": "Gets an integration account schema.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "schemaName",
            "description": "The integration account schema name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountSchema"
            }
          }
        }
      },
      "put": {
        "tags": [
          "IntegrationAccountSchemas"
        ],
        "operationId": "Schemas_CreateOrUpdate",
        "description": "Creates or updates an integration account schema.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "schemaName",
            "description": "The integration account schema name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "schema",
            "description": "The integration account schema.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/IntegrationAccountSchema"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountSchema"
            }
          },
          "201": {
            "description": "Created",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountSchema"
            }
          }
        }
      },
      "delete": {
        "tags": [
          "IntegrationAccountSchemas"
        ],
        "operationId": "Schemas_Delete",
        "description": "Deletes an integration account schema.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "schemaName",
            "description": "The integration account schema name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          },
          "204": {
            "description": "No Content"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps": {
      "get": {
        "tags": [
          "IntegrationAccountMaps"
        ],
        "operationId": "Maps_ListByIntegrationAccounts",
        "description": "Gets a list of integration account maps.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          },
          {
            "name": "$filter",
            "description": "The filter to apply on the operation.",
            "in": "query",
            "required": false,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountMapListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        },
        "x-ms-odata": "#/definitions/IntegrationAccountMapFilter"
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/maps/{mapName}": {
      "get": {
        "tags": [
          "IntegrationAccountMaps"
        ],
        "operationId": "Maps_Get",
        "description": "Gets an integration account map.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "mapName",
            "description": "The integration account map name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountMap"
            }
          }
        }
      },
      "put": {
        "tags": [
          "IntegrationAccountMaps"
        ],
        "operationId": "Maps_CreateOrUpdate",
        "description": "Creates or updates an integration account map.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "mapName",
            "description": "The integration account map name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "map",
            "description": "The integration account map.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/IntegrationAccountMap"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountMap"
            }
          },
          "201": {
            "description": "Created",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountMap"
            }
          }
        }
      },
      "delete": {
        "tags": [
          "IntegrationAccountMaps"
        ],
        "operationId": "Maps_Delete",
        "description": "Deletes an integration account map.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "mapName",
            "description": "The integration account map name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          },
          "204": {
            "description": "No Content"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners": {
      "get": {
        "tags": [
          "IntegrationAccountPartners"
        ],
        "operationId": "Partners_ListByIntegrationAccounts",
        "description": "Gets a list of integration account partners.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          },
          {
            "name": "$filter",
            "description": "The filter to apply on the operation.",
            "in": "query",
            "required": false,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountPartnerListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        },
        "x-ms-odata": "#/definitions/IntegrationAccountPartnerFilter"
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/partners/{partnerName}": {
      "get": {
        "tags": [
          "IntegrationAccountPartners"
        ],
        "operationId": "Partners_Get",
        "description": "Gets an integration account partner.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "partnerName",
            "description": "The integration account partner name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountPartner"
            }
          }
        }
      },
      "put": {
        "tags": [
          "IntegrationAccountPartners"
        ],
        "operationId": "Partners_CreateOrUpdate",
        "description": "Creates or updates an integration account partner.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "partnerName",
            "description": "The integration account partner name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "partner",
            "description": "The integration account partner.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/IntegrationAccountPartner"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountPartner"
            }
          },
          "201": {
            "description": "Created",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountPartner"
            }
          }
        }
      },
      "delete": {
        "tags": [
          "IntegrationAccountPartners"
        ],
        "operationId": "Partners_Delete",
        "description": "Deletes an integration account partner.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "partnerName",
            "description": "The integration account partner name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          },
          "204": {
            "description": "No Content"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements": {
      "get": {
        "tags": [
          "IntegrationAccountAgreements"
        ],
        "operationId": "Agreements_ListByIntegrationAccounts",
        "description": "Gets a list of integration account agreements.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          },
          {
            "name": "$filter",
            "description": "The filter to apply on the operation.",
            "in": "query",
            "required": false,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountAgreementListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        },
        "x-ms-odata": "#/definitions/IntegrationAccountAgreementFilter"
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}": {
      "get": {
        "tags": [
          "IntegrationAccountAgreements"
        ],
        "operationId": "Agreements_Get",
        "description": "Gets an integration account agreement.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "agreementName",
            "description": "The integration account agreement name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountAgreement"
            }
          }
        }
      },
      "put": {
        "tags": [
          "IntegrationAccountAgreements"
        ],
        "operationId": "Agreements_CreateOrUpdate",
        "description": "Creates or updates an integration account agreement.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "agreementName",
            "description": "The integration account agreement name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "agreement",
            "description": "The integration account agreement.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/IntegrationAccountAgreement"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountAgreement"
            }
          },
          "201": {
            "description": "Created",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountAgreement"
            }
          }
        }
      },
      "delete": {
        "tags": [
          "IntegrationAccountAgreements"
        ],
        "operationId": "Agreements_Delete",
        "description": "Deletes an integration account agreement.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "agreementName",
            "description": "The integration account agreement name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          },
          "204": {
            "description": "No Content"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates": {
      "get": {
        "tags": [
          "IntegrationAccountCertificates"
        ],
        "operationId": "Certificates_ListByIntegrationAccounts",
        "description": "Gets a list of integration account certificates.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountCertificateListResult"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/certificates/{certificateName}": {
      "get": {
        "tags": [
          "IntegrationAccountCertificates"
        ],
        "operationId": "Certificates_Get",
        "description": "Gets an integration account certificate.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "certificateName",
            "description": "The integration account certificate name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountCertificate"
            }
          }
        }
      },
      "put": {
        "tags": [
          "IntegrationAccountCertificates"
        ],
        "operationId": "Certificates_CreateOrUpdate",
        "description": "Creates or updates an integration account certificate.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "certificateName",
            "description": "The integration account certificate name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "certificate",
            "description": "The integration account certificate.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/IntegrationAccountCertificate"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountCertificate"
            }
          },
          "201": {
            "description": "Created",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountCertificate"
            }
          }
        }
      },
      "delete": {
        "tags": [
          "IntegrationAccountCertificates"
        ],
        "operationId": "Certificates_Delete",
        "description": "Deletes an integration account certificate.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "certificateName",
            "description": "The integration account certificate name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          },
          "204": {
            "description": "No Content"
          }
        }
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions": {
      "get": {
        "tags": [
          "IntegrationAccountSessions"
        ],
        "operationId": "Sessions_ListByIntegrationAccounts",
        "description": "Gets a list of integration account sessions.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "$top",
            "description": "The number of items to be included in the result.",
            "in": "query",
            "required": false,
            "type": "integer",
            "format": "int32"
          },
          {
            "name": "$filter",
            "description": "The filter to apply on the operation.",
            "in": "query",
            "required": false,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountSessionListResult"
            }
          },
          "default": {
            "description": "Logic error response describing why the operation failed.",
            "schema": {
              "$ref": "#/definitions/ErrorResponse"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        },
        "x-ms-odata": "#/definitions/IntegrationAccountSessionFilter"
      }
    },
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/sessions/{sessionName}": {
      "get": {
        "tags": [
          "IntegrationAccountSessions"
        ],
        "operationId": "Sessions_Get",
        "description": "Gets an integration account session.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "sessionName",
            "description": "The integration account session name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountSession"
            }
          },
          "default": {
            "description": "Logic error response describing why the operation failed.",
            "schema": {
              "$ref": "#/definitions/ErrorResponse"
            }
          }
        }
      },
      "put": {
        "tags": [
          "IntegrationAccountSessions"
        ],
        "operationId": "Sessions_CreateOrUpdate",
        "description": "Creates or updates an integration account session.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "sessionName",
            "description": "The integration account session name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          },
          {
            "name": "session",
            "description": "The integration account session.",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/IntegrationAccountSession"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountSession"
            }
          },
          "201": {
            "description": "Created",
            "schema": {
              "$ref": "#/definitions/IntegrationAccountSession"
            }
          },
          "default": {
            "description": "Logic error response describing why the operation failed.",
            "schema": {
              "$ref": "#/definitions/ErrorResponse"
            }
          }
        }
      },
      "delete": {
        "tags": [
          "IntegrationAccountSessions"
        ],
        "operationId": "Sessions_Delete",
        "description": "Deletes an integration account session.",
        "parameters": [
          {
            "$ref": "#/parameters/subscriptionId"
          },
          {
            "name": "resourceGroupName",
            "description": "The resource group name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "integrationAccountName",
            "description": "The integration account name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "sessionName",
            "description": "The integration account session name.",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK"
          },
          "204": {
            "description": "No Content"
          },
          "default": {
            "description": "Logic error response describing why the operation failed.",
            "schema": {
              "$ref": "#/definitions/ErrorResponse"
            }
          }
        }
      }
    },
    "/providers/Microsoft.Logic/operations": {
      "get": {
        "tags": [
          "Operations"
        ],

        "description": "Lists all of the available Logic REST API operations.",
        "operationId": "ListOperations",
        "parameters": [
          {
            "$ref": "#/parameters/api-version"
          }
        ],
        "responses": {
          "200": {
            "description": "OK. The request has succeeded.",
            "schema": {
              "$ref": "#/definitions/OperationListResult"
            }
          },
          "default": {
            "description": "Logic error response describing why the operation failed.",
            "schema": {
              "$ref": "#/definitions/ErrorResponse"
            }
          }
        },
        "x-ms-pageable": {
          "nextLinkName": "nextLink"
        }
      }
    }
  },
  "definitions": {
    "Resource": {
      "properties": {
        "id": {
          "type": "string",
          "readOnly": true,
          "description": "The resource id."
        },
        "name": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the resource name."
        },
        "type": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the resource type."
        },
        "location": {
          "type": "string",
          "description": "The resource location."
        },
        "tags": {
          "type": "object",
          "additionalProperties": {
            "type": "string"
          },
          "description": "The resource tags."
        }
      },
      "x-ms-azure-resource": true,
      "description": "The base resource type."
    },
    "SubResource": {
      "properties": {
        "id": {
          "type": "string",
          "readOnly": true,
          "description": "The resource id."
        }
      },
      "x-ms-azure-resource": true,
      "description": "The sub resource type."
    },
    "Object": {
      "type": "object",
      "properties": { }
    },
    "ResourceReference": {
      "type": "object",
      "properties": {
        "id": {
          "type": "string",
          "readOnly": true,
          "description": "The resource id."
        },
        "name": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the resource name."
        },
        "type": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the resource type."
        }
      },
      "description": "The resource reference."
    },
    "Workflow": {
      "type": "object",
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/WorkflowProperties",
          "description": "The workflow properties."
        }
      },
      "description": "The workflow type.",
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ]
    },
    "WorkflowProperties": {
      "type": "object",
      "properties": {
        "provisioningState": {
          "$ref": "#/definitions/WorkflowProvisioningState",
          "readOnly": true,
          "description": "Gets the provisioning state."
        },
        "createdTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the created time."
        },
        "changedTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the changed time."
        },
        "state": {
          "$ref": "#/definitions/WorkflowState",
          "description": "The state."
        },
        "version": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the version."
        },
        "accessEndpoint": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the access endpoint."
        },
        "sku": {
          "$ref": "#/definitions/Sku",
          "description": "The sku."
        },
        "integrationAccount": {
          "$ref": "#/definitions/ResourceReference",
          "description": "The integration account."
        },
        "definition": {
          "$ref": "#/definitions/Object",
          "description": "The definition."
        },
        "parameters": {
          "type": "object",
          "additionalProperties": {
            "$ref": "#/definitions/WorkflowParameter"
          },
          "description": "The parameters."
        }
      },
      "description": "The workflow properties."
    },
    "WorkflowFilter": {
      "type": "object",
      "properties": {
        "state": {
          "$ref": "#/definitions/WorkflowState",
          "description": "The state of workflows."
        }
      },
      "description": "The workflow filter."
    },
    "WorkflowListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/Workflow"
          },
          "description": "The list of workflows."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of workflows."
    },
    "WorkflowVersion": {
      "type": "object",
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/WorkflowVersionProperties",
          "description": "The workflow version properties."
        }
      },
      "description": "The workflow version.",
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ]
    },
    "WorkflowVersionProperties": {
      "type": "object",
      "properties": {
        "createdTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the created time."
        },
        "changedTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the changed time."
        },
        "state": {
          "$ref": "#/definitions/WorkflowState",
          "description": "The state."
        },
        "version": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the version."
        },
        "accessEndpoint": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the access endpoint."
        },
        "sku": {
          "$ref": "#/definitions/Sku",
          "description": "The sku."
        },
        "integrationAccount": {
          "$ref": "#/definitions/ResourceReference",
          "description": "The integration account."
        },
        "definition": {
          "$ref": "#/definitions/Object",
          "description": "The definition."
        },
        "parameters": {
          "type": "object",
          "additionalProperties": {
            "$ref": "#/definitions/WorkflowParameter"
          },
          "description": "The parameters."
        }
      },
      "description": "The workflow version properties."
    },
    "WorkflowVersionListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/WorkflowVersion"
          },
          "description": "A list of workflow versions."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of workflow versions."
    },
    "WorkflowTrigger": {
      "type": "object",
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/WorkflowTriggerProperties",
          "description": "The workflow trigger properties."
        },
        "name": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the workflow trigger name."
        },
        "type": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the workflow trigger type."
        }
      },
      "description": "The workflow trigger.",
      "allOf": [
        {
          "$ref": "#/definitions/SubResource"
        }
      ]
    },
    "WorkflowTriggerProperties": {
      "type": "object",
      "properties": {
        "provisioningState": {
          "$ref": "#/definitions/WorkflowTriggerProvisioningState",
          "readOnly": true,
          "description": "Gets the provisioning state."
        },
        "createdTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the created time."
        },
        "changedTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the changed time."
        },
        "state": {
          "$ref": "#/definitions/WorkflowState",
          "readOnly": true,
          "description": "Gets the state."
        },
        "status": {
          "$ref": "#/definitions/WorkflowStatus",
          "readOnly": true,
          "description": "Gets the status."
        },
        "lastExecutionTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the last execution time."
        },
        "nextExecutionTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the next execution time."
        },
        "recurrence": {
          "$ref": "#/definitions/WorkflowTriggerRecurrence",
          "readOnly": true,
          "description": "Gets the workflow trigger recurrence."
        },
        "workflow": {
          "$ref": "#/definitions/ResourceReference",
          "readOnly": true,
          "description": "Gets the reference to workflow."
        }
      },
      "description": "The workflow trigger properties."
    },
    "WorkflowTriggerFilter": {
      "type": "object",
      "properties": {
        "state": {
          "$ref": "#/definitions/WorkflowState",
          "description": "The state of workflow trigger."
        }
      },
      "description": "The workflow trigger filter."
    },
    "WorkflowTriggerListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/WorkflowTrigger"
          },
          "description": "A list of workflow triggers."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of workflow triggers."
    },
    "WorkflowTriggerCallbackUrl": {
      "type": "object",
      "properties": {
        "value": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the workflow trigger callback URL."
        }
      },
      "description": "The workflow trigger callback URL."
    },
    "WorkflowTriggerHistory": {
      "type": "object",
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/WorkflowTriggerHistoryProperties",
          "description": "Gets the workflow trigger history properties."
        },
        "name": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the workflow trigger history name."
        },
        "type": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the workflow trigger history type."
        }
      },
      "description": "The workflow trigger history.",
      "allOf": [
        {
          "$ref": "#/definitions/SubResource"
        }
      ]
    },
    "WorkflowTriggerHistoryProperties": {
      "type": "object",
      "properties": {
        "startTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the start time."
        },
        "endTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the end time."
        },
        "status": {
          "$ref": "#/definitions/WorkflowStatus",
          "readOnly": true,
          "description": "Gets the status."
        },
        "code": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the code."
        },
        "error": {
          "$ref": "#/definitions/Object",
          "readOnly": true,
          "description": "Gets the error."
        },
        "trackingId": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the tracking id."
        },
        "correlation": {
          "$ref": "#/definitions/Correlation",
          "description": "The run correlation."
        },
        "inputsLink": {
          "$ref": "#/definitions/ContentLink",
          "readOnly": true,
          "description": "Gets the link to input parameters."
        },
        "outputsLink": {
          "$ref": "#/definitions/ContentLink",
          "readOnly": true,
          "description": "Gets the link to output parameters."
        },
        "fired": {
          "type": "boolean",
          "readOnly": true,
          "description": "Gets a value indicating whether trigger was fired."
        },
        "run": {
          "$ref": "#/definitions/ResourceReference",
          "readOnly": true,
          "description": "Gets the reference to workflow run."
        }
      },
      "description": "The workflow trigger history properties."
    },
    "WorkflowTriggerHistoryListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/WorkflowTriggerHistory"
          },
          "description": "A list of workflow trigger histories."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of workflow trigger histories."
    },
    "WorkflowTriggerHistoryFilter": {
      "type": "object",
      "properties": {
        "status": {
          "$ref": "#/definitions/WorkflowStatus",
          "description": "The status of workflow trigger history."
        }
      },
      "description": "The workflow trigger history filter."
    },
    "WorkflowRun": {
      "type": "object",
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/WorkflowRunProperties",
          "description": "The workflow run properties."
        },
        "name": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the workflow run name."
        },
        "type": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the workflow run type."
        }
      },
      "description": "The workflow run.",
      "allOf": [
        {
          "$ref": "#/definitions/SubResource"
        }
      ]
    },
    "WorkflowRunProperties": {
      "type": "object",
      "properties": {
        "startTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the start time."
        },
        "endTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the end time."
        },
        "status": {
          "$ref": "#/definitions/WorkflowStatus",
          "readOnly": true,
          "description": "Gets the status."
        },
        "code": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the code."
        },
        "error": {
          "$ref": "#/definitions/Object",
          "readOnly": true,
          "description": "Gets the error."
        },
        "correlationId": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the correlation id."
        },
        "correlation": {
          "$ref": "#/definitions/Correlation",
          "description": "The run correlation."
        },
        "workflow": {
          "$ref": "#/definitions/ResourceReference",
          "readOnly": true,
          "description": "Gets the reference to workflow version."
        },
        "trigger": {
          "$ref": "#/definitions/WorkflowRunTrigger",
          "readOnly": true,
          "description": "Gets the fired trigger."
        },
        "outputs": {
          "type": "object",
          "readOnly": true,
          "additionalProperties": {
            "$ref": "#/definitions/WorkflowOutputParameter"
          },
          "description": "Gets the outputs."
        },
        "response": {
          "$ref": "#/definitions/WorkflowRunTrigger",
          "readOnly": true,
          "description": "Gets the response of the flow run."
        }
      },
      "description": "The workflow run properties."
    },
    "WorkflowRunFilter": {
      "type": "object",
      "properties": {
        "status": {
          "$ref": "#/definitions/WorkflowStatus",
          "description": "The status of workflow run."
        }
      },
      "description": "The workflow run filter."
    },
    "WorkflowRunListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/WorkflowRun"
          },
          "description": "A list of workflow runs."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of workflow runs."
    },
    "WorkflowRunAction": {
      "type": "object",
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/WorkflowRunActionProperties",
          "description": "The workflow run action properties."
        },
        "name": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the workflow run action name."
        },
        "type": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the workflow run action type."
        }
      },
      "description": "The workflow run action.",
      "allOf": [
        {
          "$ref": "#/definitions/SubResource"
        }
      ]
    },
    "WorkflowRunActionProperties": {
      "type": "object",
      "properties": {
        "startTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the start time."
        },
        "endTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the end time."
        },
        "status": {
          "$ref": "#/definitions/WorkflowStatus",
          "readOnly": true,
          "description": "Gets the status."
        },
        "code": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the code."
        },
        "error": {
          "$ref": "#/definitions/Object",
          "readOnly": true,
          "description": "Gets the error."
        },
        "trackingId": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the tracking id."
        },
        "correlation": {
          "$ref": "#/definitions/Correlation",
          "description": "The correlation properties."
        },
        "inputsLink": {
          "$ref": "#/definitions/ContentLink",
          "readOnly": true,
          "description": "Gets the link to inputs."
        },
        "outputsLink": {
          "$ref": "#/definitions/ContentLink",
          "readOnly": true,
          "description": "Gets the link to outputs."
        },
        "trackedProperties": {
          "$ref": "#/definitions/Object",
          "readOnly": true,
          "description": "Gets the tracked properties."
        }
      },
      "description": "The workflow run action properties."
    },
    "WorkflowRunActionFilter": {
      "type": "object",
      "properties": {
        "status": {
          "$ref": "#/definitions/WorkflowStatus",
          "description": "The status of workflow run action."
        }
      },
      "description": "The workflow run action filter."
    },
    "WorkflowRunActionListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/WorkflowRunAction"
          },
          "description": "A list of workflow run actions."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of workflow run actions."
    },
    "SkuName": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Free",
        "Shared",
        "Basic",
        "Standard",
        "Premium"
      ],
      "x-ms-enum": {
        "name": "SkuName",
        "modelAsString": false
      },
      "description": "The sku name."
    },
    "WorkflowState": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Completed",
        "Enabled",
        "Disabled",
        "Deleted",
        "Suspended"
      ],
      "x-ms-enum": {
        "name": "WorkflowState",
        "modelAsString": false
      }
    },
    "WorkflowStatus": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Paused",
        "Running",
        "Waiting",
        "Succeeded",
        "Skipped",
        "Suspended",
        "Cancelled",
        "Failed",
        "Faulted",
        "TimedOut",
        "Aborted",
        "Ignored"
      ],
      "x-ms-enum": {
        "name": "WorkflowStatus",
        "modelAsString": false
      }
    },
    "ParameterType": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "String",
        "SecureString",
        "Int",
        "Float",
        "Bool",
        "Array",
        "Object",
        "SecureObject"
      ],
      "x-ms-enum": {
        "name": "ParameterType",
        "modelAsString": false
      }
    },
    "KeyType": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Primary",
        "Secondary"
      ],
      "x-ms-enum": {
        "name": "KeyType",
        "modelAsString": false
      }
    },
    "Sku": {
      "type": "object",
      "required": [
        "name"
      ],
      "properties": {
        "name": {
          "$ref": "#/definitions/SkuName",
          "description": "The name."
        },
        "plan": {
          "$ref": "#/definitions/ResourceReference",
          "description": "The reference to plan."
        }
      },
      "description": "The sku type."
    },
    "ContentLink": {
      "type": "object",
      "properties": {
        "uri": {
          "type": "string",
          "description": "The content link URI."
        },
        "contentVersion": {
          "type": "string",
          "description": "The content version."
        },
        "contentSize": {
          "type": "integer",
          "format": "int64",
          "description": "The content size."
        },
        "contentHash": {
          "$ref": "#/definitions/ContentHash",
          "description": "The content hash."
        },
        "metadata": {
          "$ref": "#/definitions/Object",
          "description": "The metadata."
        }
      },
      "description": "The content link."
    },
    "ContentHash": {
      "type": "object",
      "properties": {
        "algorithm": {
          "type": "string",
          "description": "The algorithm of the content hash."
        },
        "value": {
          "type": "string",
          "description": "The value of the content hash."
        }
      },
      "description": "The content hash."
    },
    "Correlation": {
      "type": "object",
      "properties": {
        "clientTrackingId": {
          "type": "string",
          "description": "The client tracking id."
        }
      },
      "description": "The correlation property."
    },
    "WorkflowParameter": {
      "type": "object",
      "properties": {
        "type": {
          "$ref": "#/definitions/ParameterType",
          "description": "The type."
        },
        "value": {
          "$ref": "#/definitions/Object",
          "description": "The value."
        },
        "metadata": {
          "$ref": "#/definitions/Object",
          "description": "The metadata."
        },
        "description": {
          "type": "string",
          "description": "The description."
        }
      },
      "description": "The workflow parameters."
    },
    "WorkflowOutputParameter": {
      "type": "object",
      "properties": {
        "error": {
          "$ref": "#/definitions/Object",
          "readOnly": true,
          "description": "Gets the error."
        }
      },
      "description": "The workflow output parameter.",
      "allOf": [
        {
          "$ref": "#/definitions/WorkflowParameter"
        }
      ]
    },
    "RecurrenceFrequency": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Second",
        "Minute",
        "Hour",
        "Day",
        "Week",
        "Month",
        "Year"
      ],
      "x-ms-enum": {
        "name": "RecurrenceFrequency",
        "modelAsString": false
      }
    },
    "RecurrenceSchedule": {
      "type": "object",
      "properties": {
        "minutes": {
          "type": "array",
          "items": {
            "type": "integer",
            "format": "int32"
          },
          "description": "The minutes."
        },
        "hours": {
          "type": "array",
          "items": {
            "type": "integer",
            "format": "int32"
          },
          "description": "The hours."
        },
        "weekDays": {
          "type": "array",
          "items": {
            "type": "string",
            "enum": [
              "Sunday",
              "Monday",
              "Tuesday",
              "Wednesday",
              "Thursday",
              "Friday",
              "Saturday"
            ],
            "x-ms-enum": {
              "name": "DaysOfWeek",
              "modelAsString": false
            }
          },
          "description": "The days of the week."
        },
        "monthDays": {
          "type": "array",
          "items": {
            "type": "integer",
            "format": "int32"
          },
          "description": "The month days."
        },
        "monthlyOccurrences": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/RecurrenceScheduleOccurrence"
          },
          "description": "The monthly occurrences."
        }
      },
      "description": "The recurrence schedule."
    },
    "RecurrenceScheduleOccurrence": {
      "type": "object",
      "properties": {
        "day": {
          "$ref": "#/definitions/DayOfWeek",
          "description": "The day of the week."
        },
        "occurrence": {
          "type": "integer",
          "format": "int32",
          "description": "The occurrence."
        }
      },
      "description": "The recurrence schedule occurence."
    },
    "WorkflowTriggerRecurrence": {
      "type": "object",
      "properties": {
        "frequency": {
          "$ref": "#/definitions/RecurrenceFrequency",
          "description": "The frequency."
        },
        "interval": {
          "type": "integer",
          "format": "int32",
          "description": "The interval."
        },
        "startTime": {
          "type": "string",
          "format": "date-time",
          "description": "The start time."
        },
        "endTime": {
          "type": "string",
          "format": "date-time",
          "description": "The end time."
        },
        "timeZone": {
          "type": "string",
          "description": "The time zone."
        },
        "schedule": {
          "$ref": "#/definitions/RecurrenceSchedule",
          "description": "The recurrence schedule."
        }
      },
      "description": "The workflow trigger recurrence."
    },
    "WorkflowRunTrigger": {
      "type": "object",
      "properties": {
        "name": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the name."
        },
        "inputs": {
          "$ref": "#/definitions/Object",
          "readOnly": true,
          "description": "Gets the inputs."
        },
        "inputsLink": {
          "$ref": "#/definitions/ContentLink",
          "readOnly": true,
          "description": "Gets the link to inputs."
        },
        "outputs": {
          "$ref": "#/definitions/Object",
          "readOnly": true,
          "description": "Gets the outputs."
        },
        "outputsLink": {
          "$ref": "#/definitions/ContentLink",
          "readOnly": true,
          "description": "Gets the link to outputs."
        },
        "startTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the start time."
        },
        "endTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "Gets the end time."
        },
        "trackingId": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the tracking id."
        },
        "correlation": {
          "$ref": "#/definitions/Correlation",
          "description": "The run correlation."
        },
        "code": {
          "type": "string",
          "readOnly": true,
          "description": "Gets the code."
        },
        "status": {
          "$ref": "#/definitions/WorkflowStatus",
          "readOnly": true,
          "description": "Gets the status."
        },
        "error": {
          "$ref": "#/definitions/Object",
          "readOnly": true,
          "description": "Gets the error."
        },
        "trackedProperties": {
          "$ref": "#/definitions/Object",
          "readOnly": true,
          "description": "Gets the tracked properties."
        }
      },
      "description": "The workflow run trigger."
    },
    "WorkflowTriggerProvisioningState": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Accepted",
        "Running",
        "Ready",
        "Creating",
        "Created",
        "Deleting",
        "Deleted",
        "Canceled",
        "Failed",
        "Succeeded",
        "Moving",
        "Updating",
        "Registering",
        "Registered",
        "Unregistering",
        "Unregistered",
        "Completed"
      ],
      "x-ms-enum": {
        "name": "WorkflowTriggerProvisioningState",
        "modelAsString": false
      }
    },
    "WorkflowProvisioningState": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Accepted",
        "Running",
        "Ready",
        "Creating",
        "Created",
        "Deleting",
        "Deleted",
        "Canceled",
        "Failed",
        "Succeeded",
        "Moving",
        "Updating",
        "Registering",
        "Registered",
        "Unregistering",
        "Unregistered",
        "Completed"
      ],
      "x-ms-enum": {
        "name": "WorkflowProvisioningState",
        "modelAsString": false
      }
    },
    "DayOfWeek": {
      "type": "string",
      "enum": [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
      ],
      "x-ms-enum": {
        "name": "DayOfWeek",
        "modelAsString": false
      }
    },
    "GenerateUpgradedDefinitionParameters": {
      "type": "object",
      "properties": {
        "targetSchemaVersion": {
          "type": "string",
          "description": "The target schema version."
        }
      },
      "description": "The parameters to generate upgraded definition."
    },
    "IntegrationAccountSkuName": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Free",
        "Standard"
      ],
      "x-ms-enum": {
        "name": "IntegrationAccountSkuName",
        "modelAsString": false
      }
    },
    "IntegrationAccount": {
      "type": "object",
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/IntegrationAccountProperties",
          "description": "The integration account properties."
        },
        "sku": {
          "$ref": "#/definitions/IntegrationAccountSku",
          "description": "The sku."
        }
      },
      "description": "The integration account.",
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ]
    },
    "IntegrationAccountProperties": {
      "type": "object",
      "properties": {
      }
    },
    "IntegrationAccountListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/IntegrationAccount"
          },
          "description": "The list of integration accounts."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of integration accounts."
    },
    "GetCallbackUrlParameters": {
      "type": "object",
      "properties": {
        "notAfter": {
          "type": "string",
          "format": "date-time",
          "description": "The expiry time."
        },
        "keyType": {
          "$ref": "#/definitions/KeyType",
          "description": "The key type."
        }
      },
      "description": "The callback url parameters."
    },
    "CallbackUrl": {
      "type": "object",
      "properties": {
        "value": {
          "type": "string",
          "description": "The URL value."
        }
      },
      "description": "The callback url."
    },
    "IntegrationAccountSchema": {
      "type": "object",
      "required": [
        "properties"
      ],
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/IntegrationAccountSchemaProperties",
          "description": "The integration account schema properties."
        }
      },
      "description": "The integration account schema.",
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ]
    },
    "IntegrationAccountSchemaProperties": {
      "type": "object",
      "required": [
        "schemaType"
      ],
      "properties": {
        "schemaType": {
          "$ref": "#/definitions/SchemaType",
          "description": "The schema type."
        },
        "targetNamespace": {
          "type": "string",
          "description": "The target namespace of the schema."
        },
        "documentName": {
          "type": "string",
          "description": "The document name."
        },
        "fileName": {
          "type": "string",
          "description": "The file name."
        },
        "createdTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "The created time."
        },
        "changedTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "The changed time."
        },
        "metadata": {
          "type": "object",
          "description": "The metadata.",
          "properties": {
          }
        },
        "content": {
          "type": "string",
          "description": "The content.",
          "properties": {
          }
        },
        "contentType": {
          "type": "string",
          "description": "The content type."
        },
        "contentLink": {
          "$ref": "#/definitions/ContentLink",
          "readOnly": true,
          "description": "The content link."
        }
      },
      "description": "The integration account schema properties."
    },
    "IntegrationAccountSchemaListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/IntegrationAccountSchema"
          },
          "description": "The list of integration account schemas."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of integration account schemas."
    },
    "IntegrationAccountSchemaFilter": {
      "type": "object",
      "required": [
        "schemaType"
      ],
      "properties": {
        "schemaType": {
          "$ref": "#/definitions/SchemaType",
          "description": "The schema type of integration account schema."
        }
      },
      "description": "The integration account schema filter for odata query."
    },
    "SchemaType": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Xml"
      ],
      "x-ms-enum": {
        "name": "SchemaType",
        "modelAsString": false
      }
    },
    "IntegrationAccountMap": {
      "type": "object",
      "required": [
        "properties"
      ],
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/IntegrationAccountMapProperties",
          "description": "The integration account map properties."
        }
      },
      "description": "The integration account map.",
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ]
    },
    "IntegrationAccountMapProperties": {
      "type": "object",
      "required": [
        "mapType"
      ],
      "properties": {
        "mapType": {
          "$ref": "#/definitions/MapType",
          "description": "The map type."
        },
        "parametersSchema": {
          "type": "object",
          "properties": {
            "ref": {
              "type": "string",
              "description": "The reference name."
            }
          },
          "description": "The parameters schema of integration account map."
        },
        "createdTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "The created time."
        },
        "changedTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "The changed time."
        },
        "content": {
          "type": "string",
          "description": "The content.",
          "properties": {
          }
        },
        "contentType": {
          "type": "string",
          "description": "The content type."
        },
        "contentLink": {
          "$ref": "#/definitions/ContentLink",
          "readOnly": true,
          "description": "The content link."
        },
        "metadata": {
          "type": "object",
          "description": "The metadata.",
          "properties": {
          }
        }
      },
      "description": "The integration account map."
    },
    "IntegrationAccountMapListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/IntegrationAccountMap"
          },
          "description": "The list of integration account maps."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of integration account maps."
    },
    "IntegrationAccountMapFilter": {
      "type": "object",
      "required": [
        "mapType"
      ],
      "properties": {
        "mapType": {
          "$ref": "#/definitions/MapType",
          "description": "The map type of integration account map."
        }
      },
      "description": "The integration account map filter for odata query."
    },
    "MapType": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Xslt"
      ],
      "x-ms-enum": {
        "name": "MapType",
        "modelAsString": false
      }
    },
    "IntegrationAccountSku": {
      "type": "object",
      "required": [
        "name"
      ],
      "properties": {
        "name": {
          "$ref": "#/definitions/IntegrationAccountSkuName",
          "description": "The sku name."
        }
      },
      "description": "The integration account sku."
    },
    "IntegrationAccountPartnerListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/IntegrationAccountPartner"
          },
          "description": "The list of integration account partners."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of integration account partners."
    },
    "IntegrationAccountPartnerFilter": {
      "type": "object",
      "required": [
        "partnerType"
      ],
      "properties": {
        "partnerType": {
          "$ref": "#/definitions/PartnerType",
          "description": "The partner type of integration account partner."
        }
      },
      "description": "The integration account partner filter for odata query."
    },
    "IntegrationAccountPartner": {
      "type": "object",
      "required": [
        "properties"
      ],
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/IntegrationAccountPartnerProperties",
          "description": "The integration account partner properties."
        }
      },
      "description": "The integration account partner.",
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ]
    },
    "IntegrationAccountPartnerProperties": {
      "type": "object",
      "required": [
        "partnerType",
        "content"
      ],
      "properties": {
        "partnerType": {
          "$ref": "#/definitions/PartnerType",
          "description": "The partner type."
        },
        "createdTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "The created time."
        },
        "changedTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "The changed time."
        },
        "metadata": {
          "type": "object",
          "description": "The metadata.",
          "properties": {
          }
        },
        "content": {
          "$ref": "#/definitions/PartnerContent",
          "description": "The partner content."
        }
      },
      "description": "The integration account partner properties."
    },
    "PartnerType": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "B2B"
      ],
      "x-ms-enum": {
        "name": "PartnerType",
        "modelAsString": false
      }
    },
    "PartnerContent": {
      "type": "object",
      "properties": {
        "b2b": {
          "$ref": "#/definitions/B2BPartnerContent",
          "description": "The B2B partner content."
        }
      },
      "description": "The integration account partner content."
    },
    "B2BPartnerContent": {
      "type": "object",
      "properties": {
        "businessIdentities": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/BusinessIdentity"
          },
          "description": "The list of partner business identities."
        }
      },
      "description": "The B2B partner content."
    },
    "BusinessIdentity": {
      "type": "object",
      "required": [
        "qualifier",
        "value"
      ],
      "properties": {
        "qualifier": {
          "type": "string",
          "description": "The business identity qualifier e.g. as2identity, ZZ, ZZZ, 31, 32"
        },
        "value": {
          "type": "string",
          "description": "The user defined business identity value."
        }
      },
      "description": "The integration account partner's business identity."
    },
    "IntegrationAccountAgreementListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/IntegrationAccountAgreement"
          },
          "description": "The list of integration account agreements."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of integration account agreements."
    },
    "IntegrationAccountAgreementFilter": {
      "type": "object",
      "required": [
        "agreementType"
      ],
      "properties": {
        "agreementType": {
          "$ref": "#/definitions/AgreementType",
          "description": "The agreement type of integration account agreement."
        }
      },
      "description": "The integration account agreement filter for odata query."
    },
    "IntegrationAccountAgreement": {
      "type": "object",
      "required": [
        "properties"
      ],
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/IntegrationAccountAgreementProperties",
          "description": "The integration account agreement properties."
        }
      },
      "description": "The integration account agreement.",
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ]
    },
    "IntegrationAccountAgreementProperties": {
      "type": "object",
      "required": [
        "hostPartner",
        "guestPartner",
        "hostIdentity",
        "guestIdentity",
        "agreementType",
        "content"
      ],
      "properties": {
        "createdTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "The created time."
        },
        "changedTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "The changed time."
        },
        "metadata": {
          "type": "object",
          "description": "The metadata.",
          "properties": {
          }
        },
        "agreementType": {
          "$ref": "#/definitions/AgreementType",
          "description": "The agreement type."
        },
        "hostPartner": {
          "type": "string",
          "description": "The integration account partner that is set as host partner for this agreement."
        },
        "guestPartner": {
          "type": "string",
          "description": "The integration account partner that is set as guest partner for this agreement."
        },
        "hostIdentity": {
          "$ref": "#/definitions/BusinessIdentity",
          "description": "The business identity of the host partner."
        },
        "guestIdentity": {
          "$ref": "#/definitions/BusinessIdentity",
          "description": "The business identity of the guest partner."
        },
        "content": {
          "$ref": "#/definitions/AgreementContent",
          "description": "The agreement content."
        }
      },
      "description": "The integration account agreement properties."
    },
    "AgreementType": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "AS2",
        "X12",
        "Edifact"
      ],
      "x-ms-enum": {
        "name": "AgreementType",
        "modelAsString": false
      }
    },
    "AgreementContent": {
      "type": "object",
      "properties": {
        "aS2": {
          "$ref": "#/definitions/AS2AgreementContent",
          "description": "The AS2 agreement content."
        },
        "x12": {
          "$ref": "#/definitions/X12AgreementContent",
          "description": "The X12 agreement content."
        },
        "edifact": {
          "$ref": "#/definitions/EdifactAgreementContent",
          "description": "The EDIFACT agreement content."
        }
      },
      "description": "The integration account agreement content."
    },
    "AS2AgreementContent": {
      "type": "object",
      "required": [
        "receiveAgreement",
        "sendAgreement"
      ],
      "properties": {
        "receiveAgreement": {
          "$ref": "#/definitions/AS2OneWayAgreement",
          "description": "The AS2 one-way receive agreement."
        },
        "sendAgreement": {
          "$ref": "#/definitions/AS2OneWayAgreement",
          "description": "The AS2 one-way send agreement."
        }
      },
      "description": "The integration account AS2 agreement content."
    },
    "AS2OneWayAgreement": {
      "type": "object",
      "required": [
        "senderBusinessIdentity",
        "receiverBusinessIdentity",
        "protocolSettings"
      ],
      "properties": {
        "senderBusinessIdentity": {
          "$ref": "#/definitions/BusinessIdentity",
          "description": "The sender business identity"
        },
        "receiverBusinessIdentity": {
          "$ref": "#/definitions/BusinessIdentity",
          "description": "The receiver business identity"
        },
        "protocolSettings": {
          "$ref": "#/definitions/AS2ProtocolSettings",
          "description": "The AS2 protocol settings."
        }
      },
      "description": "The integration account AS2 oneway agreement."
    },
    "AS2ProtocolSettings": {
      "type": "object",
      "required": [
        "messageConnectionSettings",
        "acknowledgementConnectionSettings",
        "mdnSettings",
        "securitySettings",
        "validationSettings",
        "envelopeSettings",
        "errorSettings"
      ],
      "properties": {
        "messageConnectionSettings": {
          "$ref": "#/definitions/AS2MessageConnectionSettings",
          "description": "The message connection settings."
        },
        "acknowledgementConnectionSettings": {
          "$ref": "#/definitions/AS2AcknowledgementConnectionSettings",
          "description": "The acknowledgement connection settings."
        },
        "mdnSettings": {
          "$ref": "#/definitions/AS2MdnSettings",
          "description": "The MDN settings."
        },
        "securitySettings": {
          "$ref": "#/definitions/AS2SecuritySettings",
          "description": "The security settings."
        },
        "validationSettings": {
          "$ref": "#/definitions/AS2ValidationSettings",
          "description": "The validation settings."
        },
        "envelopeSettings": {
          "$ref": "#/definitions/AS2EnvelopeSettings",
          "description": "The envelope settings."
        },
        "errorSettings": {
          "$ref": "#/definitions/AS2ErrorSettings",
          "description": "The error settings."
        }
      },
      "description": "The AS2 agreement protocol settings."
    },
    "AS2AcknowledgementConnectionSettings": {
      "type": "object",
      "required": [
        "ignoreCertificateNameMismatch",
        "supportHttpStatusCodeContinue",
        "keepHttpConnectionAlive",
        "unfoldHttpHeaders"
      ],
      "properties": {
        "ignoreCertificateNameMismatch": {
          "type": "boolean",
          "description": "The value indicating whether to ignore mismatch in certificate name."
        },
        "supportHttpStatusCodeContinue": {
          "type": "boolean",
          "description": "The value indicating whether to support HTTP status code 'CONTINUE'."
        },
        "keepHttpConnectionAlive": {
          "type": "boolean",
          "description": "The value indicating whether to keep the connection alive."
        },
        "unfoldHttpHeaders": {
          "type": "boolean",
          "description": "The value indicating whether to unfold the HTTP headers."
        }
      },
      "description": "The AS2 agreement acknowledegment connection settings."
    },
    "AS2MessageConnectionSettings": {
      "type": "object",
      "required": [
        "ignoreCertificateNameMismatch",
        "supportHttpStatusCodeContinue",
        "keepHttpConnectionAlive",
        "unfoldHttpHeaders"
      ],
      "properties": {
        "ignoreCertificateNameMismatch": {
          "type": "boolean",
          "description": "The value indicating whether to ignore mismatch in certificate name."
        },
        "supportHttpStatusCodeContinue": {
          "type": "boolean",
          "description": "The value indicating whether to support HTTP status code 'CONTINUE'."
        },
        "keepHttpConnectionAlive": {
          "type": "boolean",
          "description": "The value indicating whether to keep the connection alive."
        },
        "unfoldHttpHeaders": {
          "type": "boolean",
          "description": "The value indicating whether to unfold the HTTP headers."
        }
      },
      "description": "The AS2 agreement message connection settings."
    },
    "AS2MdnSettings": {
      "type": "object",
      "required": [
        "needMdn",
        "signMdn",
        "sendMdnAsynchronously",
        "signOutboundMdnIfOptional",
        "sendInboundMdnToMessageBox",
        "micHashingAlgorithm"
      ],
      "properties": {
        "needMdn": {
          "type": "boolean",
          "description": "The value indicating whether to send or request a MDN."
        },
        "signMdn": {
          "type": "boolean",
          "description": "The value indicating whether the MDN needs to be signed or not."
        },
        "sendMdnAsynchronously": {
          "type": "boolean",
          "description": "The value indicating whether to send the asynchronous MDN."
        },
        "receiptDeliveryUrl": {
          "type": "string",
          "description": "The receipt delivery URL."
        },
        "dispositionNotificationTo": {
          "type": "string",
          "description": "The disposition notification to header value."
        },
        "signOutboundMdnIfOptional": {
          "type": "boolean",
          "description": "The value indicating whether to sign the outbound MDN if optional."
        },
        "mdnText": {
          "type": "string",
          "description": "The MDN text."
        },
        "sendInboundMdnToMessageBox": {
          "type": "boolean",
          "description": "The value indicating whether to send inbound MDN to message box."
        },
        "micHashingAlgorithm": {
          "$ref": "#/definitions/HashingAlgorithm",
          "description": "The signing or hashing algorithm."
        }
      },
      "description": "The AS2 agreement mdn settings."
    },
    "AS2SecuritySettings": {
      "type": "object",
      "required": [
        "overrideGroupSigningCertificate",
        "enableNrrForInboundEncodedMessages",
        "enableNrrForInboundDecodedMessages",
        "enableNrrForOutboundMdn",
        "enableNrrForOutboundEncodedMessages",
        "enableNrrForOutboundDecodedMessages",
        "enableNrrForInboundMdn"
      ],
      "properties": {
        "overrideGroupSigningCertificate": {
          "type": "boolean",
          "description": "The value indicating whether to send or request a MDN."
        },
        "signingCertificateName": {
          "type": "string",
          "description": "The name of the signing certificate."
        },
        "encryptionCertificateName": {
          "type": "string",
          "description": "The name of the encryption certificate."
        },
        "enableNrrForInboundEncodedMessages": {
          "type": "boolean",
          "description": "The value indicating whether to enable NRR for inbound encoded messages."
        },
        "enableNrrForInboundDecodedMessages": {
          "type": "boolean",
          "description": "The value indicating whether to enable NRR for inbound decoded messages."
        },
        "enableNrrForOutboundMdn": {
          "type": "boolean",
          "description": "The value indicating whether to enable NRR for outbound MDN."
        },
        "enableNrrForOutboundEncodedMessages": {
          "type": "boolean",
          "description": "The value indicating whether to enable NRR for outbound encoded messages."
        },
        "enableNrrForOutboundDecodedMessages": {
          "type": "boolean",
          "description": "The value indicating whether to enable NRR for outbound decoded messages."
        },
        "enableNrrForInboundMdn": {
          "type": "boolean",
          "description": "The value indicating whether to enable NRR for inbound MDN."
        }
      },
      "description": "The AS2 agreement security settings."
    },
    "AS2ValidationSettings": {
      "type": "object",
      "required": [
        "overrideMessageProperties",
        "encryptMessage",
        "signMessage",
        "compressMessage",
        "checkDuplicateMessage",
        "interchangeDuplicatesValidityDays",
        "checkCertificateRevocationListOnSend",
        "checkCertificateRevocationListOnReceive",
        "encryptionAlgorithm"
      ],
      "properties": {
        "overrideMessageProperties": {
          "type": "boolean",
          "description": "The value indicating whether to override incoming message properties with those in agreement."
        },
        "encryptMessage": {
          "type": "boolean",
          "description": "The value indicating whether the message has to be encrypted."
        },
        "signMessage": {
          "type": "boolean",
          "description": "The value indicating whether the message has to be signed."
        },
        "compressMessage": {
          "type": "boolean",
          "description": "The value indicating whether the message has to be compressed."
        },
        "checkDuplicateMessage": {
          "type": "boolean",
          "default": 4,
          "description": "The value indicating whether to check for duplicate message."
        },
        "interchangeDuplicatesValidityDays": {
          "type": "integer",
          "format": "int32",
          "description": "The number of days to look back for duplicate interchange."
        },
        "checkCertificateRevocationListOnSend": {
          "type": "boolean",
          "description": "The value indicating whether to check for certificate revocation list on send."
        },
        "checkCertificateRevocationListOnReceive": {
          "type": "boolean",
          "description": "The value indicating whether to check for certificate revocation list on receive."
        },
        "encryptionAlgorithm": {
          "$ref": "#/definitions/EncryptionAlgorithm",
          "description": "The encryption algorithm."
        }
      },
      "description": "The AS2 agreement validation settings."
    },
    "AS2EnvelopeSettings": {
      "type": "object",
      "required": [
        "messageContentType",
        "transmitFileNameInMimeHeader",
        "fileNameTemplate",
        "suspendMessageOnFileNameGenerationError",
        "autogenerateFileName"
      ],
      "properties": {
        "messageContentType": {
          "type": "string",
          "description": "The message content type."
        },
        "transmitFileNameInMimeHeader": {
          "type": "boolean",
          "description": "The value indicating whether to transmit file name in mime header."
        },
        "fileNameTemplate": {
          "type": "string",
          "description": "The template for file name."
        },
        "suspendMessageOnFileNameGenerationError": {
          "type": "boolean",
          "description": "The value indicating whether to suspend message on file name generation error."
        },
        "autogenerateFileName": {
          "type": "boolean",
          "description": "The value indicating whether to auto generate file name."
        }
      },
      "description": "The AS2 agreement envelope settings."
    },
    "AS2ErrorSettings": {
      "type": "object",
      "required": [
        "suspendDuplicateMessage",
        "resendIfMdnNotReceived"
      ],
      "properties": {
        "suspendDuplicateMessage": {
          "type": "boolean",
          "description": "The value indicating whether to suspend duplicate message."
        },
        "resendIfMdnNotReceived": {
          "type": "boolean",
          "description": "The value indicating whether to resend message If MDN is not received."
        }
      },
      "description": "The AS2 agreement error settings."
    },
    "X12AgreementContent": {
      "type": "object",
      "required": [
        "receiveAgreement",
        "sendAgreement"
      ],
      "properties": {
        "receiveAgreement": {
          "$ref": "#/definitions/X12OneWayAgreement",
          "description": "The X12 one-way receive agreement."
        },
        "sendAgreement": {
          "$ref": "#/definitions/X12OneWayAgreement",
          "description": "The X12 one-way send agreement."
        }
      },
      "description": "The X12 agreement content."
    },
    "X12OneWayAgreement": {
      "type": "object",
      "required": [
        "senderBusinessIdentity",
        "receiverBusinessIdentity",
        "protocolSettings"
      ],
      "properties": {
        "senderBusinessIdentity": {
          "$ref": "#/definitions/BusinessIdentity",
          "description": "The sender business identity"
        },
        "receiverBusinessIdentity": {
          "$ref": "#/definitions/BusinessIdentity",
          "description": "The receiver business identity"
        },
        "protocolSettings": {
          "$ref": "#/definitions/X12ProtocolSettings",
          "description": "The X12 protocol settings."
        }
      },
      "description": "The X12 oneway agreement."
    },
    "X12ProtocolSettings": {
      "type": "object",
      "required": [
        "validationSettings",
        "framingSettings",
        "envelopeSettings",
        "acknowledgementSettings",
        "messageFilter",
        "securitySettings",
        "processingSettings",
        "schemaReferences"
      ],
      "properties": {
        "validationSettings": {
          "$ref": "#/definitions/X12ValidationSettings",
          "description": "The X12 validation settings."
        },
        "framingSettings": {
          "$ref": "#/definitions/X12FramingSettings",
          "description": "The X12 framing settings."
        },
        "envelopeSettings": {
          "$ref": "#/definitions/X12EnvelopeSettings",
          "description": "The X12 envelope settings."
        },
        "acknowledgementSettings": {
          "$ref": "#/definitions/X12AcknowledgementSettings",
          "description": "The X12 acknowledgment settings."
        },
        "messageFilter": {
          "$ref": "#/definitions/X12MessageFilter",
          "description": "The X12 message filter."
        },
        "securitySettings": {
          "$ref": "#/definitions/X12SecuritySettings",
          "description": "The X12 security settings."
        },
        "processingSettings": {
          "$ref": "#/definitions/X12ProcessingSettings",
          "description": "The X12 processing settings."
        },
        "envelopeOverrides": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/X12EnvelopeOverride"
          },
          "description": "The X12 envelope override settings."
        },
        "validationOverrides": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/X12ValidationOverride"
          },
          "description": "The X12 validation override settings."
        },
        "messageFilterList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/X12MessageIdentifier"
          },
          "description": "The X12 message filter list."
        },
        "schemaReferences": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/X12SchemaReference"
          },
          "description": "The X12 schema references."
        },
        "x12DelimiterOverrides": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/X12DelimiterOverrides"
          },
          "description": "The X12 delimiter override settings."
        }
      },
      "description": "The X12 agreement protocol settings."
    },
    "X12ValidationSettings": {
      "type": "object",
      "required": [
        "validateCharacterSet",
        "checkDuplicateInterchangeControlNumber",
        "interchangeControlNumberValidityDays",
        "checkDuplicateGroupControlNumber",
        "checkDuplicateTransactionSetControlNumber",
        "validateEdiTypes",
        "validateXsdTypes",
        "allowLeadingAndTrailingSpacesAndZeroes",
        "trimLeadingAndTrailingSpacesAndZeroes",
        "trailingSeparatorPolicy"
      ],
      "properties": {
        "validateCharacterSet": {
          "type": "boolean",
          "description": "The value indicating whether to validate character set in the message."
        },
        "checkDuplicateInterchangeControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to check for duplicate interchange control number."
        },
        "interchangeControlNumberValidityDays": {
          "type": "integer",
          "format": "int32",
          "description": "The validity period of interchange control number."
        },
        "checkDuplicateGroupControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to check for duplicate group control number."
        },
        "checkDuplicateTransactionSetControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to check for duplicate transaction set control number."
        },
        "validateEdiTypes": {
          "type": "boolean",
          "description": "The value indicating whether to Whether to validate EDI types."
        },
        "validateXsdTypes": {
          "type": "boolean",
          "description": "The value indicating whether to Whether to validate XSD types."
        },
        "allowLeadingAndTrailingSpacesAndZeroes": {
          "type": "boolean",
          "description": "The value indicating whether to allow leading and trailing spaces and zeroes."
        },
        "trimLeadingAndTrailingSpacesAndZeroes": {
          "type": "boolean",
          "description": "The value indicating whether to trim leading and trailing spaces and zeroes."
        },
        "trailingSeparatorPolicy": {
          "$ref": "#/definitions/TrailingSeparatorPolicy",
          "description": "The trailing separator policy."
        }
      },
      "description": "The X12 agreement validation settings."
    },
    "X12FramingSettings": {
      "type": "object",
      "required": [
        "dataElementSeparator",
        "componentSeparator",
        "replaceSeparatorsInPayload",
        "replaceCharacter",
        "segmentTerminator",
        "characterSet",
        "segmentTerminatorSuffix"
      ],
      "properties": {
        "dataElementSeparator": {
          "type": "integer",
          "format": "int32",
          "description": "The data element separator."
        },
        "componentSeparator": {
          "type": "integer",
          "format": "int32",
          "description": "The component separator."
        },
        "replaceSeparatorsInPayload": {
          "type": "boolean",
          "description": "The value indicating whether to replace separators in payload."
        },
        "replaceCharacter": {
          "type": "integer",
          "format": "int32",
          "description": "The replacement character."
        },
        "segmentTerminator": {
          "type": "integer",
          "format": "int32",
          "description": "The segment terminator."
        },
        "characterSet": {
          "$ref": "#/definitions/X12CharacterSet",
          "description": "The X12 character set."
        },
        "segmentTerminatorSuffix": {
          "$ref": "#/definitions/SegmentTerminatorSuffix",
          "description": "The segment terminator suffix."
        }
      },
      "description": "The X12 agreement framing settings."
    },
    "X12EnvelopeSettings": {
      "type": "object",
      "required": [
        "controlStandardsId",
        "useControlStandardsIdAsRepetitionCharacter",
        "senderApplicationId",
        "receiverApplicationId",
        "controlVersionNumber",
        "interchangeControlNumberLowerBound",
        "interchangeControlNumberUpperBound",
        "rolloverInterchangeControlNumber",
        "enableDefaultGroupHeaders",
        "groupControlNumberLowerBound",
        "groupControlNumberUpperBound",
        "rolloverGroupControlNumber",
        "groupHeaderAgencyCode",
        "groupHeaderVersion",
        "transactionSetControlNumberLowerBound",
        "transactionSetControlNumberUpperBound",
        "rolloverTransactionSetControlNumber",
        "overwriteExistingTransactionSetControlNumber",
        "groupHeaderDateFormat",
        "groupHeaderTimeFormat",
        "usageIndicator"
      ],
      "properties": {
        "controlStandardsId": {
          "type": "integer",
          "format": "int32",
          "description": "The controls standards id."
        },
        "useControlStandardsIdAsRepetitionCharacter": {
          "type": "boolean",
          "description": "The value indicating whether to use control standards id as repetition character."
        },
        "senderApplicationId": {
          "type": "string",
          "description": "The sender application id."
        },
        "receiverApplicationId": {
          "type": "string",
          "description": "The receiver application id."
        },
        "controlVersionNumber": {
          "type": "string",
          "description": "The control version number."
        },
        "interchangeControlNumberLowerBound": {
          "type": "integer",
          "format": "int32",
          "description": "The interchange  control number lower bound."
        },
        "interchangeControlNumberUpperBound": {
          "type": "integer",
          "format": "int32",
          "description": "The interchange  control number upper bound."
        },
        "rolloverInterchangeControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to rollover interchange control number."
        },
        "enableDefaultGroupHeaders": {
          "type": "boolean",
          "description": "The value indicating whether to enable default group headers."
        },
        "functionalGroupId": {
          "type": "string",
          "description": "The functional group id."
        },
        "groupControlNumberLowerBound": {
          "type": "integer",
          "format": "int32",
          "description": "The group control number lower bound."
        },
        "groupControlNumberUpperBound": {
          "type": "integer",
          "format": "int32",
          "description": "The group control number upper bound."
        },
        "rolloverGroupControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to rollover group control number."
        },
        "groupHeaderAgencyCode": {
          "type": "string",
          "description": "The group header agency code."
        },
        "groupHeaderVersion": {
          "type": "string",
          "description": "The group header version."
        },
        "transactionSetControlNumberLowerBound": {
          "type": "integer",
          "format": "int32",
          "description": "The transaction set control number lower bound."
        },
        "transactionSetControlNumberUpperBound": {
          "type": "integer",
          "format": "int32",
          "description": "The transaction set control number upper bound."
        },
        "rolloverTransactionSetControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to rollover transaction set control number."
        },
        "transactionSetControlNumberPrefix": {
          "type": "string",
          "description": "The transaction set control number prefix."
        },
        "transactionSetControlNumberSuffix": {
          "type": "string",
          "description": "The transaction set control number suffix."
        },
        "overwriteExistingTransactionSetControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to overwrite existing transaction set control number."
        },
        "groupHeaderDateFormat": {
          "$ref": "#/definitions/X12DateFormat",
          "description": "The group header date format."
        },
        "groupHeaderTimeFormat": {
          "$ref": "#/definitions/X12TimeFormat",
          "description": "The group header time format."
        },
        "usageIndicator": {
          "$ref": "#/definitions/UsageIndicator",
          "description": "The usage indicator."
        }
      },
      "description": "The X12 agreement envelope settings."
    },
    "X12AcknowledgementSettings": {
      "type": "object",
      "required": [
        "needTechnicalAcknowledgement",
        "batchTechnicalAcknowledgements",
        "needFunctionalAcknowledgement",
        "batchFunctionalAcknowledgements",
        "needImplementationAcknowledgement",
        "batchImplementationAcknowledgements",
        "needLoopForValidMessages",
        "sendSynchronousAcknowledgement",
        "acknowledgementControlNumberLowerBound",
        "acknowledgementControlNumberUpperBound",
        "rolloverAcknowledgementControlNumber"
      ],
      "properties": {
        "needTechnicalAcknowledgement": {
          "type": "boolean",
          "description": "The value indicating whether technical acknowledgement is needed."
        },
        "batchTechnicalAcknowledgements": {
          "type": "boolean",
          "description": "The value indicating whether to batch the technical acknowledgements."
        },
        "needFunctionalAcknowledgement": {
          "type": "boolean",
          "description": "The value indicating whether functional acknowledgement is needed."
        },
        "functionalAcknowledgementVersion": {
          "type": "string",
          "description": "The functional acknowledgement version."
        },
        "batchFunctionalAcknowledgements": {
          "type": "boolean",
          "description": "The value indicating whether to batch functional acknowledgements."
        },
        "needImplementationAcknowledgement": {
          "type": "boolean",
          "description": "The value indicating whether implementation acknowledgement is needed."
        },
        "implementationAcknowledgementVersion": {
          "type": "string",
          "description": "The implementation acknowledgement version."
        },
        "batchImplementationAcknowledgements": {
          "type": "boolean",
          "description": "The value indicating whether to batch implementation acknowledgements."
        },
        "needLoopForValidMessages": {
          "type": "boolean",
          "description": "The value indicating whether a loop is needed for valid messages."
        },
        "sendSynchronousAcknowledgement": {
          "type": "boolean",
          "description": "The value indicating whether to send synchronous acknowledgement."
        },
        "acknowledgementControlNumberPrefix": {
          "type": "string",
          "description": "The acknowledgement control number prefix."
        },
        "acknowledgementControlNumberSuffix": {
          "type": "string",
          "description": "The acknowledgement control number suffix."
        },
        "acknowledgementControlNumberLowerBound": {
          "type": "integer",
          "format": "int32",
          "description": "The acknowledgement control number lower bound."
        },
        "acknowledgementControlNumberUpperBound": {
          "type": "integer",
          "format": "int32",
          "description": "The acknowledgement control number upper bound."
        },
        "rolloverAcknowledgementControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to rollover acknowledgement control number."
        }
      },
      "description": "The X12 agreement acknowledgement settings."
    },
    "X12MessageFilter": {
      "type": "object",
      "required": [
        "messageFilterType"
      ],
      "properties": {
        "messageFilterType": {
          "$ref": "#/definitions/MessageFilterType",
          "description": "The message filter type."
        }
      },
      "description": "The X12 message filter for odata query."
    },
    "X12SecuritySettings": {
      "type": "object",
      "required": [
        "authorizationQualifier",
        "securityQualifier"
      ],
      "properties": {
        "authorizationQualifier": {
          "type": "string",
          "description": "The authorization qualifier."
        },
        "authorizationValue": {
          "type": "string",
          "description": "The authorization value."
        },
        "securityQualifier": {
          "type": "string",
          "description": "The security qualifier."
        },
        "passwordValue": {
          "type": "string",
          "description": "The password value."
        }
      },
      "description": "The X12 agreement security settings."
    },
    "X12ProcessingSettings": {
      "type": "object",
      "required": [
        "maskSecurityInfo",
        "convertImpliedDecimal",
        "preserveInterchange",
        "suspendInterchangeOnError",
        "createEmptyXmlTagsForTrailingSeparators",
        "useDotAsDecimalSeparator"
      ],
      "properties": {
        "maskSecurityInfo": {
          "type": "boolean",
          "description": "The value indicating whether to mask security information."
        },
        "convertImpliedDecimal": {
          "type": "boolean",
          "description": "The value indicating whether to convert numerical type to implied decimal."
        },
        "preserveInterchange": {
          "type": "boolean",
          "description": "The value indicating whether to preserve interchange."
        },
        "suspendInterchangeOnError": {
          "type": "boolean",
          "description": "The value indicating whether to suspend interchange on error."
        },
        "createEmptyXmlTagsForTrailingSeparators": {
          "type": "boolean",
          "description": "The value indicating whether to create empty xml tags for trailing separators."
        },
        "useDotAsDecimalSeparator": {
          "type": "boolean",
          "description": "The value indicating whether to use dot as decimal separator."
        }
      },
      "description": "The X12 processing settings."
    },
    "X12EnvelopeOverride": {
      "type": "object",
      "required": [
        "targetNamespace",
        "protocolVersion",
        "messageId",
        "responsibleAgencyCode",
        "headerVersion",
        "senderApplicationId",
        "receiverApplicationId",
        "dateFormat",
        "timeFormat"
      ],
      "properties": {
        "targetNamespace": {
          "type": "string",
          "description": "The target namespace on which this envelope settings has to be applied."
        },
        "protocolVersion": {
          "type": "string",
          "description": "The protocol version on which this envelope settings has to be applied."
        },
        "messageId": {
          "type": "string",
          "description": "The message id on which this envelope settings has to be applied."
        },
        "responsibleAgencyCode": {
          "type": "string",
          "description": "The responsible agency code."
        },
        "headerVersion": {
          "type": "string",
          "description": "The header version."
        },
        "senderApplicationId": {
          "type": "string",
          "description": "The sender application id."
        },
        "receiverApplicationId": {
          "type": "string",
          "description": "The receiver application id."
        },
        "functionalIdentifierCode": {
          "type": "string",
          "description": "The functional identifier code."
        },
        "dateFormat": {
          "$ref": "#/definitions/X12DateFormat",
          "description": "The date format."
        },
        "timeFormat": {
          "$ref": "#/definitions/X12TimeFormat",
          "description": "The time format."
        }
      },
      "description": "The X12 envelope override settings."
    },
    "X12ValidationOverride": {
      "type": "object",
      "required": [
        "messageId",
        "validateEdiTypes",
        "validateXsdTypes",
        "allowLeadingAndTrailingSpacesAndZeroes",
        "validateCharacterSet",
        "trimLeadingAndTrailingSpacesAndZeroes",
        "trailingSeparatorPolicy"
      ],
      "properties": {
        "messageId": {
          "type": "string",
          "description": "The message id on which the validation settings has to be applied."
        },
        "validateEdiTypes": {
          "type": "boolean",
          "description": "The value indicating whether to validate EDI types."
        },
        "validateXsdTypes": {
          "type": "boolean",
          "description": "The value indicating whether to validate XSD types."
        },
        "allowLeadingAndTrailingSpacesAndZeroes": {
          "type": "boolean",
          "description": "The value indicating whether to allow leading and trailing spaces and zeroes."
        },
        "validateCharacterSet": {
          "type": "boolean",
          "description": "The value indicating whether to validate character Set."
        },
        "trimLeadingAndTrailingSpacesAndZeroes": {
          "type": "boolean",
          "description": "The value indicating whether to trim leading and trailing spaces and zeroes."
        },
        "trailingSeparatorPolicy": {
          "$ref": "#/definitions/TrailingSeparatorPolicy",
          "description": "The trailing separator policy."
        }
      },
      "description": "The X12 validation override settings."
    },
    "X12MessageIdentifier": {
      "type": "object",
      "required": [
        "messageId"
      ],
      "properties": {
        "messageId": {
          "type": "string",
          "description": "The message id."
        }
      },
      "description": "The X12 message identifier."
    },
    "X12SchemaReference": {
      "type": "object",
      "required": [
        "messageId",
        "schemaVersion",
        "schemaName"
      ],
      "properties": {
        "messageId": {
          "type": "string",
          "description": "The message id."
        },
        "senderApplicationId": {
          "type": "string",
          "description": "The sender application id."
        },
        "schemaVersion": {
          "type": "string",
          "description": "The schema version."
        },
        "schemaName": {
          "type": "string",
          "description": "The schema name."
        }
      },
      "description": "The X12 schema reference."
    },
    "X12DelimiterOverrides": {
      "type": "object",
      "required": [
        "dataElementSeparator",
        "componentSeparator",
        "segmentTerminator",
        "segmentTerminatorSuffix",
        "replaceCharacter",
        "replaceSeparatorsInPayload"
      ],
      "properties": {
        "protocolVersion": {
          "type": "string",
          "description": "The protocol version."
        },
        "messageId": {
          "type": "string",
          "description": "The message id."
        },
        "dataElementSeparator": {
          "type": "integer",
          "format": "int32",
          "description": "The data element separator."
        },
        "componentSeparator": {
          "type": "integer",
          "format": "int32",
          "description": "The component separator."
        },
        "segmentTerminator": {
          "type": "integer",
          "format": "int32",
          "description": "The segment terminator."
        },
        "segmentTerminatorSuffix": {
          "$ref": "#/definitions/SegmentTerminatorSuffix",
          "description": "The segment terminator suffix."
        },
        "replaceCharacter": {
          "type": "integer",
          "format": "int32",
          "description": "The replacement character."
        },
        "replaceSeparatorsInPayload": {
          "type": "boolean",
          "description": "The value indicating whether to replace separators in payload."
        },
        "targetNamespace": {
          "type": "string",
          "description": "The target namespace on which this delimiter settings has to be applied."
        }
      },
      "description": "The X12 delimiter override settings."
    },
    "X12CharacterSet": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Basic",
        "Extended",
        "UTF8"
      ],
      "x-ms-enum": {
        "name": "X12CharacterSet",
        "modelAsString": false
      }
    },
    "SegmentTerminatorSuffix": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "None",
        "CR",
        "LF",
        "CRLF"
      ],
      "x-ms-enum": {
        "name": "SegmentTerminatorSuffix",
        "modelAsString": false
      }
    },
    "X12DateFormat": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "CCYYMMDD",
        "YYMMDD"
      ],
      "x-ms-enum": {
        "name": "X12DateFormat",
        "modelAsString": false
      }
    },
    "X12TimeFormat": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "HHMM",
        "HHMMSS",
        "HHMMSSdd",
        "HHMMSSd"
      ],
      "x-ms-enum": {
        "name": "X12TimeFormat",
        "modelAsString": false
      }
    },
    "UsageIndicator": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Test",
        "Information",
        "Production"
      ],
      "x-ms-enum": {
        "name": "UsageIndicator",
        "modelAsString": false
      }
    },
    "MessageFilterType": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Include",
        "Exclude"
      ],
      "x-ms-enum": {
        "name": "MessageFilterType",
        "modelAsString": false
      }
    },
    "HashingAlgorithm": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "None",
        "MD5",
        "SHA1",
        "SHA2256",
        "SHA2384",
        "SHA2512"
      ],
      "x-ms-enum": {
        "name": "HashingAlgorithm",
        "modelAsString": false
      }
    },
    "EncryptionAlgorithm": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "None",
        "DES3",
        "RC2",
        "AES128",
        "AES192",
        "AES256"
      ],
      "x-ms-enum": {
        "name": "EncryptionAlgorithm",
        "modelAsString": false
      }
    },
    "TrailingSeparatorPolicy": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "NotAllowed",
        "Optional",
        "Mandatory"
      ],
      "x-ms-enum": {
        "name": "TrailingSeparatorPolicy",
        "modelAsString": false
      }
    },
    "EdifactAgreementContent": {
      "type": "object",
      "required": [
        "receiveAgreement",
        "sendAgreement"
      ],
      "properties": {
        "receiveAgreement": {
          "$ref": "#/definitions/EdifactOneWayAgreement",
          "description": "The EDIFACT one-way receive agreement."
        },
        "sendAgreement": {
          "$ref": "#/definitions/EdifactOneWayAgreement",
          "description": "The EDIFACT one-way send agreement."
        }
      },
      "description": "The Edifact agreement content."
    },
    "EdifactOneWayAgreement": {
      "type": "object",
      "required": [
        "senderBusinessIdentity",
        "receiverBusinessIdentity",
        "protocolSettings"
      ],
      "properties": {
        "senderBusinessIdentity": {
          "$ref": "#/definitions/BusinessIdentity",
          "description": "The sender business identity"
        },
        "receiverBusinessIdentity": {
          "$ref": "#/definitions/BusinessIdentity",
          "description": "The receiver business identity"
        },
        "protocolSettings": {
          "$ref": "#/definitions/EdifactProtocolSettings",
          "description": "The EDIFACT protocol settings."
        }
      },
      "description": "The Edifact one way agreement."
    },
    "EdifactProtocolSettings": {
      "type": "object",
      "required": [
        "validationSettings",
        "framingSettings",
        "envelopeSettings",
        "acknowledgementSettings",
        "messageFilter",
        "processingSettings",
        "schemaReferences"
      ],
      "properties": {
        "validationSettings": {
          "$ref": "#/definitions/EdifactValidationSettings",
          "description": "The EDIFACT validation settings."
        },
        "framingSettings": {
          "$ref": "#/definitions/EdifactFramingSettings",
          "description": "The EDIFACT framing settings."
        },
        "envelopeSettings": {
          "$ref": "#/definitions/EdifactEnvelopeSettings",
          "description": "The EDIFACT envelope settings."
        },
        "acknowledgementSettings": {
          "$ref": "#/definitions/EdifactAcknowledgementSettings",
          "description": "The EDIFACT acknowledgement settings."
        },
        "messageFilter": {
          "$ref": "#/definitions/EdifactMessageFilter",
          "description": "The EDIFACT message filter."
        },
        "processingSettings": {
          "$ref": "#/definitions/EdifactProcessingSettings",
          "description": "The EDIFACT processing Settings."
        },
        "envelopeOverrides": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/EdifactEnvelopeOverride"
          },
          "description": "The EDIFACT envelope override settings."
        },
        "messageFilterList": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/EdifactMessageIdentifier"
          },
          "description": "The EDIFACT message filter list."
        },
        "schemaReferences": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/EdifactSchemaReference"
          },
          "description": "The EDIFACT schema references."
        },
        "validationOverrides": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/EdifactValidationOverride"
          },
          "description": "The EDIFACT validation override settings."
        },
        "edifactDelimiterOverrides": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/EdifactDelimiterOverride"
          },
          "description": "The EDIFACT delimiter override settings."
        }
      },
      "description": "The Edifact agreement protocol settings."
    },
    "EdifactValidationSettings": {
      "type": "object",
      "required": [
        "validateCharacterSet",
        "checkDuplicateInterchangeControlNumber",
        "interchangeControlNumberValidityDays",
        "checkDuplicateGroupControlNumber",
        "checkDuplicateTransactionSetControlNumber",
        "validateEdiTypes",
        "validateXsdTypes",
        "allowLeadingAndTrailingSpacesAndZeroes",
        "trimLeadingAndTrailingSpacesAndZeroes",
        "trailingSeparatorPolicy"
      ],
      "properties": {
        "validateCharacterSet": {
          "type": "boolean",
          "description": "The value indicating whether to validate character set in the message."
        },
        "checkDuplicateInterchangeControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to check for duplicate interchange control number."
        },
        "interchangeControlNumberValidityDays": {
          "type": "integer",
          "format": "int32",
          "description": "The validity period of interchange control number."
        },
        "checkDuplicateGroupControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to check for duplicate group control number."
        },
        "checkDuplicateTransactionSetControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to check for duplicate transaction set control number."
        },
        "validateEdiTypes": {
          "type": "boolean",
          "description": "The value indicating whether to Whether to validate EDI types."
        },
        "validateXsdTypes": {
          "type": "boolean",
          "description": "The value indicating whether to Whether to validate XSD types."
        },
        "allowLeadingAndTrailingSpacesAndZeroes": {
          "type": "boolean",
          "description": "The value indicating whether to allow leading and trailing spaces and zeroes."
        },
        "trimLeadingAndTrailingSpacesAndZeroes": {
          "type": "boolean",
          "description": "The value indicating whether to trim leading and trailing spaces and zeroes."
        },
        "trailingSeparatorPolicy": {
          "$ref": "#/definitions/TrailingSeparatorPolicy",
          "description": "The trailing separator policy."
        }
      },
      "description": "The Edifact agreement validation settings."
    },
    "EdifactFramingSettings": {
      "type": "object",
      "required": [
        "protocolVersion",
        "dataElementSeparator",
        "componentSeparator",
        "segmentTerminator",
        "releaseIndicator",
        "repetitionSeparator",
        "characterSet",
        "decimalPointIndicator",
        "segmentTerminatorSuffix"
      ],
      "properties": {
        "serviceCodeListDirectoryVersion": {
          "type": "string",
          "description": "The service code list directory version."
        },
        "characterEncoding": {
          "type": "string",
          "description": "The character encoding."
        },
        "protocolVersion": {
          "type": "integer",
          "format": "int32",
          "description": "The protocol version."
        },
        "dataElementSeparator": {
          "type": "integer",
          "format": "int32",
          "description": "The data element separator."
        },
        "componentSeparator": {
          "type": "integer",
          "format": "int32",
          "description": "The component separator."
        },
        "segmentTerminator": {
          "type": "integer",
          "format": "int32",
          "description": "The segment terminator."
        },
        "releaseIndicator": {
          "type": "integer",
          "format": "int32",
          "description": "The release indicator."
        },
        "repetitionSeparator": {
          "type": "integer",
          "format": "int32",
          "description": "The repetition separator."
        },
        "characterSet": {
          "$ref": "#/definitions/EdifactCharacterSet",
          "description": "The EDIFACT frame setting characterSet."
        },
        "decimalPointIndicator": {
          "$ref": "#/definitions/EdifactDecimalIndicator",
          "description": "The EDIFACT frame setting decimal indicator."
        },
        "segmentTerminatorSuffix": {
          "$ref": "#/definitions/SegmentTerminatorSuffix",
          "description": "The EDIFACT frame setting segment terminator suffix."
        }
      },
      "description": "The Edifact agreement framing settings."
    },
    "EdifactEnvelopeSettings": {
      "type": "object",
      "required": [
        "applyDelimiterStringAdvice",
        "createGroupingSegments",
        "enableDefaultGroupHeaders",
        "interchangeControlNumberLowerBound",
        "interchangeControlNumberUpperBound",
        "rolloverInterchangeControlNumber",
        "groupControlNumberLowerBound",
        "groupControlNumberUpperBound",
        "rolloverGroupControlNumber",
        "overwriteExistingTransactionSetControlNumber",
        "transactionSetControlNumberLowerBound",
        "transactionSetControlNumberUpperBound",
        "rolloverTransactionSetControlNumber",
        "isTestInterchange"
      ],
      "properties": {
        "groupAssociationAssignedCode": {
          "type": "string",
          "description": "The group association assigned code."
        },
        "communicationAgreementId": {
          "type": "string",
          "description": "The communication agreement id."
        },
        "applyDelimiterStringAdvice": {
          "type": "boolean",
          "description": "The value indicating whether to apply delimiter string advice."
        },
        "createGroupingSegments": {
          "type": "boolean",
          "description": "The value indicating whether to create grouping segments."
        },
        "enableDefaultGroupHeaders": {
          "type": "boolean",
          "description": "The value indicating whether to enable default group headers."
        },
        "recipientReferencePasswordValue": {
          "type": "string",
          "description": "The recipient reference password value."
        },
        "recipientReferencePasswordQualifier": {
          "type": "string",
          "description": "The recipient reference password qualifier."
        },
        "applicationReferenceId": {
          "type": "string",
          "description": "The application reference id."
        },
        "processingPriorityCode": {
          "type": "string",
          "description": "The processing priority code."
        },
        "interchangeControlNumberLowerBound": {
          "type": "integer",
          "format": "int64",
          "description": "The interchange control number lower bound."
        },
        "interchangeControlNumberUpperBound": {
          "type": "integer",
          "format": "int64",
          "description": "The interchange control number upper bound."
        },
        "rolloverInterchangeControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to rollover interchange control number."
        },
        "interchangeControlNumberPrefix": {
          "type": "string",
          "description": "The interchange control number prefix."
        },
        "interchangeControlNumberSuffix": {
          "type": "string",
          "description": "The interchange control number suffix."
        },
        "senderReverseRoutingAddress": {
          "type": "string",
          "description": "The sender reverse routing address."
        },
        "receiverReverseRoutingAddress": {
          "type": "string",
          "description": "The receiver reverse routing address."
        },
        "functionalGroupId": {
          "type": "string",
          "description": "The functional group id."
        },
        "groupControllingAgencyCode": {
          "type": "string",
          "description": "The group controlling agency code."
        },
        "groupMessageVersion": {
          "type": "string",
          "description": "The group message version."
        },
        "groupMessageRelease": {
          "type": "string",
          "description": "The group message release."
        },
        "groupControlNumberLowerBound": {
          "type": "integer",
          "format": "int64",
          "description": "The group control number lower bound."
        },
        "groupControlNumberUpperBound": {
          "type": "integer",
          "format": "int64",
          "description": "The group control number upper bound."
        },
        "rolloverGroupControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to rollover group control number."
        },
        "groupControlNumberPrefix": {
          "type": "string",
          "description": "The group control number prefix."
        },
        "groupControlNumberSuffix": {
          "type": "string",
          "description": "The group control number suffix."
        },
        "groupApplicationReceiverQualifier": {
          "type": "string",
          "description": "The group application receiver qualifier."
        },
        "groupApplicationReceiverId": {
          "type": "string",
          "description": "The group application receiver id."
        },
        "groupApplicationSenderQualifier": {
          "type": "string",
          "description": "The group application sender qualifier."
        },
        "groupApplicationSenderId": {
          "type": "string",
          "description": "The group application sender id."
        },
        "groupApplicationPassword": {
          "type": "string",
          "description": "The group application password."
        },
        "overwriteExistingTransactionSetControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to overwrite existing transaction set control number."
        },
        "transactionSetControlNumberPrefix": {
          "type": "string",
          "description": "The transaction set control number prefix."
        },
        "transactionSetControlNumberSuffix": {
          "type": "string",
          "description": "The transaction set control number suffix."
        },
        "transactionSetControlNumberLowerBound": {
          "type": "integer",
          "format": "int64",
          "description": "The transaction set control number lower bound."
        },
        "transactionSetControlNumberUpperBound": {
          "type": "integer",
          "format": "int64",
          "description": "The transaction set control number upper bound."
        },
        "rolloverTransactionSetControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to rollover transaction set control number."
        },
        "isTestInterchange": {
          "type": "boolean",
          "description": "The value indicating whether the message is a test interchange."
        },
        "senderInternalIdentification": {
          "type": "string",
          "description": "The sender internal identification."
        },
        "senderInternalSubIdentification": {
          "type": "string",
          "description": "The sender internal sub identification."
        },
        "receiverInternalIdentification": {
          "type": "string",
          "description": "The receiver internal identification."
        },
        "receiverInternalSubIdentification": {
          "type": "string",
          "description": "The receiver internal sub identification."
        }
      },
      "description": "The Edifact agreement envelope settings."
    },
    "EdifactAcknowledgementSettings": {
      "type": "object",
      "required": [
        "needTechnicalAcknowledgement",
        "batchTechnicalAcknowledgements",
        "needFunctionalAcknowledgement",
        "batchFunctionalAcknowledgements",
        "needLoopForValidMessages",
        "sendSynchronousAcknowledgement",
        "acknowledgementControlNumberLowerBound",
        "acknowledgementControlNumberUpperBound",
        "rolloverAcknowledgementControlNumber"
      ],
      "properties": {
        "needTechnicalAcknowledgement": {
          "type": "boolean",
          "description": "The value indicating whether technical acknowledgement is needed."
        },
        "batchTechnicalAcknowledgements": {
          "type": "boolean",
          "description": "The value indicating whether to batch the technical acknowledgements."
        },
        "needFunctionalAcknowledgement": {
          "type": "boolean",
          "description": "The value indicating whether functional acknowledgement is needed."
        },
        "batchFunctionalAcknowledgements": {
          "type": "boolean",
          "description": "The value indicating whether to batch functional acknowledgements."
        },
        "needLoopForValidMessages": {
          "type": "boolean",
          "description": "The value indicating whether a loop is needed for valid messages."
        },
        "sendSynchronousAcknowledgement": {
          "type": "boolean",
          "description": "The value indicating whether to send synchronous acknowledgement."
        },
        "acknowledgementControlNumberPrefix": {
          "type": "string",
          "description": "The acknowledgement control number prefix."
        },
        "acknowledgementControlNumberSuffix": {
          "type": "string",
          "description": "The acknowledgement control number suffix."
        },
        "acknowledgementControlNumberLowerBound": {
          "type": "integer",
          "format": "int32",
          "description": "The acknowledgement control number lower bound."
        },
        "acknowledgementControlNumberUpperBound": {
          "type": "integer",
          "format": "int32",
          "description": "The acknowledgement control number upper bound."
        },
        "rolloverAcknowledgementControlNumber": {
          "type": "boolean",
          "description": "The value indicating whether to rollover acknowledgement control number."
        }
      },
      "description": "The Edifact agreement acknowledgement settings."
    },
    "EdifactMessageFilter": {
      "type": "object",
      "required": [
        "messageFilterType"
      ],
      "properties": {
        "messageFilterType": {
          "$ref": "#/definitions/MessageFilterType",
          "description": "The message filter type."
        }
      },
      "description": "The Edifact message filter for odata query."
    },
    "EdifactProcessingSettings": {
      "type": "object",
      "required": [
        "maskSecurityInfo",
        "preserveInterchange",
        "suspendInterchangeOnError",
        "createEmptyXmlTagsForTrailingSeparators",
        "useDotAsDecimalSeparator"
      ],
      "properties": {
        "maskSecurityInfo": {
          "type": "boolean",
          "description": "The value indicating whether to mask security information."
        },
        "preserveInterchange": {
          "type": "boolean",
          "description": "The value indicating whether to preserve interchange."
        },
        "suspendInterchangeOnError": {
          "type": "boolean",
          "description": "The value indicating whether to suspend interchange on error."
        },
        "createEmptyXmlTagsForTrailingSeparators": {
          "type": "boolean",
          "description": "The value indicating whether to create empty xml tags for trailing separators."
        },
        "useDotAsDecimalSeparator": {
          "type": "boolean",
          "description": "The value indicating whether to use dot as decimal separator."
        }
      },
      "description": "The Edifact agreement protocol settings."
    },
    "EdifactEnvelopeOverride": {
      "type": "object",
      "properties": {
        "messageId": {
          "type": "string",
          "description": "The message id on which this envelope settings has to be applied."
        },
        "messageVersion": {
          "type": "string",
          "description": "The message version on which this envelope settings has to be applied."
        },
        "messageRelease": {
          "type": "string",
          "description": "The message release version on which this envelope settings has to be applied."
        },
        "messageAssociationAssignedCode": {
          "type": "string",
          "description": "The message association assigned code."
        },
        "targetNamespace": {
          "type": "string",
          "description": "The target namespace on which this envelope settings has to be applied."
        },
        "functionalGroupId": {
          "type": "string",
          "description": "The functional group id."
        },
        "senderApplicationQualifier": {
          "type": "string",
          "description": "The sender application qualifier."
        },
        "senderApplicationId": {
          "type": "string",
          "description": "The sender application id."
        },
        "receiverApplicationQualifier": {
          "type": "string",
          "description": "The receiver application qualifier."

        },
        "receiverApplicationId": {
          "type": "string",
          "description": "The receiver application id."
        },
        "controllingAgencyCode": {
          "type": "string",
          "description": "The controlling agency code."
        },
        "groupHeaderMessageVersion": {
          "type": "string",
          "description": "The group header message version."
        },
        "groupHeaderMessageRelease": {
          "type": "string",
          "description": "The group header message release."
        },
        "associationAssignedCode": {
          "type": "string",
          "description": "The association assigned code."
        },
        "applicationPassword": {
          "type": "string",
          "description": "The application password."
        }
      },
      "description": "The Edifact enevlope override settings."
    },
    "EdifactMessageIdentifier": {
      "type": "object",
      "required": [
        "messageId"
      ],
      "properties": {
        "messageId": {
          "type": "string",
          "description": "The message id on which this envelope settings has to be applied."
        }
      },
      "description": "The Edifact message identifier."
    },
    "EdifactSchemaReference": {
      "type": "object",
      "required": [
        "messageId",
        "messageVersion",
        "messageRelease",
        "schemaName"
      ],
      "properties": {
        "messageId": {
          "type": "string",
          "description": "The message id."
        },
        "messageVersion": {
          "type": "string",
          "description": "The message version."
        },
        "messageRelease": {
          "type": "string",
          "description": "The message release version."
        },
        "senderApplicationId": {
          "type": "string",
          "description": "The sender application id."
        },
        "senderApplicationQualifier": {
          "type": "string",
          "description": "The sender application qualifier."
        },
        "associationAssignedCode": {
          "type": "string",
          "description": "The association assigned code."
        },
        "schemaName": {
          "type": "string",
          "description": "The schema name."
        }
      },
      "description": "The Edifact schema reference."
    },
    "EdifactValidationOverride": {
      "type": "object",
      "required": [
        "messageId",
        "enforceCharacterSet",
        "validateEdiTypes",
        "validateXsdTypes",
        "allowLeadingAndTrailingSpacesAndZeroes",
        "trailingSeparatorPolicy",
        "trimLeadingAndTrailingSpacesAndZeroes"
      ],
      "properties": {
        "messageId": {
          "type": "string",
          "description": "The message id on which the validation settings has to be applied."
        },
        "enforceCharacterSet": {
          "type": "boolean",
          "description": "The value indicating whether to validate character Set."
        },
        "validateEdiTypes": {
          "type": "boolean",
          "description": "The value indicating whether to validate EDI types."
        },
        "validateXsdTypes": {
          "type": "boolean",
          "description": "The value indicating whether to validate XSD types."
        },
        "allowLeadingAndTrailingSpacesAndZeroes": {
          "type": "boolean",
          "description": "The value indicating whether to allow leading and trailing spaces and zeroes."
        },
        "trailingSeparatorPolicy": {
          "$ref": "#/definitions/TrailingSeparatorPolicy",
          "description": "The trailing separator policy."
        },
        "trimLeadingAndTrailingSpacesAndZeroes": {
          "type": "boolean",
          "description": "The value indicating whether to trim leading and trailing spaces and zeroes."
        }
      },
      "description": "The Edifact validation override settings."
    },
    "EdifactDelimiterOverride": {
      "type": "object",
      "required": [
        "dataElementSeparator",
        "componentSeparator",
        "segmentTerminator",
        "repetitionSeparator",
        "segmentTerminatorSuffix",
        "decimalPointIndicator",
        "releaseIndicator"
      ],
      "properties": {
        "messageId": {
          "type": "string",
          "description": "The message id."
        },
        "messageVersion": {
          "type": "string",
          "description": "The message version."
        },
        "messageRelease": {
          "type": "string",
          "description": "The message releaseversion."
        },
        "dataElementSeparator": {
          "type": "integer",
          "format": "int32",
          "description": "The data element separator."
        },
        "componentSeparator": {
          "type": "integer",
          "format": "int32",
          "description": "The component separator."
        },
        "segmentTerminator": {
          "type": "integer",
          "format": "int32",
          "description": "The segment terminator."
        },
        "repetitionSeparator": {
          "type": "integer",
          "format": "int32",
          "description": "The repetition separator."
        },
        "segmentTerminatorSuffix": {
          "$ref": "#/definitions/SegmentTerminatorSuffix",
          "description": "The segment terminator suffix."
        },
        "decimalPointIndicator": {
          "$ref": "#/definitions/EdifactDecimalIndicator",
          "description": "The decimal point indicator."
        },
        "releaseIndicator": {
          "type": "integer",
          "format": "int32",
          "description": "The release indicator."
        },
        "messageAssociationAssignedCode": {
          "type": "string",
          "description": "The message association assigned code."
        },
        "targetNamespace": {
          "type": "string",
          "description": "The target namespace on which this delimiter settings has to be applied."
        }
      },
      "description": "The Edifact delimiter override settings."
    },
    "EdifactCharacterSet": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "UNOB",
        "UNOA",
        "UNOC",
        "UNOD",
        "UNOE",
        "UNOF",
        "UNOG",
        "UNOH",
        "UNOI",
        "UNOJ",
        "UNOK",
        "UNOX",
        "UNOY",
        "KECA"
      ],
      "x-ms-enum": {
        "name": "EdifactCharacterSet",
        "modelAsString": false
      }
    },
    "EdifactDecimalIndicator": {
      "type": "string",
      "enum": [
        "NotSpecified",
        "Comma",
        "Decimal"
      ],
      "x-ms-enum": {
        "name": "EdifactDecimalIndicator",
        "modelAsString": false
      }
    },
    "IntegrationAccountCertificateListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/IntegrationAccountCertificate"
          },
          "description": "The list of integration account certificates."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of integration account certificates."
    },
    "IntegrationAccountCertificate": {
      "type": "object",
      "required": [
        "properties"
      ],
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/IntegrationAccountCertificateProperties",
          "description": "The integration account certificate properties."
        }
      },
      "description": "The integration account certificate.",
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ]
    },
    "IntegrationAccountCertificateProperties": {
      "type": "object",
      "properties": {
        "createdTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "The created time."
        },
        "changedTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "The changed time."
        },
        "metadata": {
          "type": "object",
          "description": "The metadata.",
          "properties": {
          }
        },
        "key": {
          "$ref": "#/definitions/KeyVaultKeyReference",
          "description": "The key details in the key vault."
        },
        "publicCertificate": {
          "type": "string",
          "description": "The public certificate."
        }
      },
      "description": "The integration account certificate properties."
    },
    "KeyVaultKeyReference": {
      "type": "object",
      "required": [
        "keyVault",
        "keyName"
      ],
      "properties": {
        "keyVault": {
          "type": "object",
          "description": "The key vault reference.",
          "properties": {
            "id": {
              "type": "string",
              "description": "The resource id."
            },
            "name": {
              "type": "string",
              "readOnly": true,
              "description": "The resource name."
            },
            "type": {
              "type": "string",
              "readOnly": true,
              "description": "The resource type."
            }
          }
        },
        "keyName": {
          "type": "string",
          "description": "The private key name in key vault."
        },
        "keyVersion": {
          "type": "string",
          "description": "The private key version in key vault."
        }
      },
      "description": "The reference to the key vault key."
    },
    "IntegrationAccountSessionFilter": {
      "type": "object",
      "required": [
        "changedTime"
      ],
      "properties": {
        "changedTime": {
          "type": "string",
          "format": "date-time",
          "description": "The changed time of integration account sessions."
        }
      },
      "description": "The integration account session filter."
    },
    "IntegrationAccountSessionListResult": {
      "type": "object",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/IntegrationAccountSession"
          },
          "description": "The list of integration account sessions."
        },
        "nextLink": {
          "type": "string",
          "description": "The URL to get the next set of results."
        }
      },
      "description": "The list of integration account sessions."
    },
    "IntegrationAccountSession": {
      "type": "object",
      "required": [
        "properties"
      ],
      "properties": {
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/IntegrationAccountSessionProperties",
          "description": "The integration account session properties."
        }
      },
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ],
      "description": "The integration account session."
    },
    "IntegrationAccountSessionProperties": {
      "type": "object",
      "properties": {
        "createdTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "The created time."
        },
        "changedTime": {
          "type": "string",
          "format": "date-time",
          "readOnly": true,
          "description": "The changed time."
        },
        "content": {
          "$ref": "#/definitions/Object",
          "description": "The session content."
        }
      },
      "description": "The integration account session properties."
    },
    "Operation": {
      "description": "Logic REST API operation",
      "type": "object",
      "properties": {
        "name": {
          "description": "Operation name: {provider}/{resource}/{operation}",
          "type": "string"
        },
        "display": {
          "description": "The object that represents the operation.",
          "properties": {
            "provider": {
              "description": "Service provider: Microsoft.Logic",
              "type": "string"
            },
            "resource": {
              "description": "Resource on which the operation is performed: Profile, endpoint, etc.",
              "type": "string"
            },
            "operation": {
              "description": "Operation type: Read, write, delete, etc.",
              "type": "string"
            }
          }
        }
      }
    },
    "OperationListResult": {
      "description": "Result of the request to list Logic operations. It contains a list of operations and a URL link to get the next set of results.",
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/Operation"
          },
          "description": "List of Logic operations supported by the Logic resource provider."
        },
        "nextLink": {
          "type": "string",
          "description": "URL to get the next set of operation list results if there are any."
        }
      }
    },
    "ErrorResponse": {
       "description": "Error reponse indicates Logic service is not able to process the incoming request. The error property contains the error details.",
      "type": "object",
      "properties": {
        "error": {
          "$ref": "#/definitions/ErrorProperties",
          "description": "The error properties."
        }
      }
    },
    "ErrorProperties": {
      "description": "Error properties indicate why the Logic service was not able to process the incoming request. The reason is provided in the error message.",
      "type": "object",
      "properties": {
        "code": {
          "description": "Error code.",
          "type": "string"
        },
        "message": {
          "description": "Error message indicating why the operation failed.",
          "type": "string"
        }
      }
    }
  },
  "parameters": {
    "subscriptionId": {
      "name": "subscriptionId",
      "description": "The subscription id.",
      "in": "path",
      "required": true,
      "type": "string"
    },
    "api-version": {
      "name": "api-version",
      "description": "The API version.",
      "in": "query",
      "default": true,
      "required": true,
      "type": "string"
    }
  }
}