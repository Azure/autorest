// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 
'use strict';

var Constants = {
  /**
  * Defines constants for long running operation states.
  *
  * @const
  * @type {string}
  */
  LongRunningOperationStates: {
    InProgress: 'InProgress',
    Succeeded: 'Succeeded',
    Failed: 'Failed',
    Canceled: 'Canceled'
  }
};

exports = module.exports = Constants;
