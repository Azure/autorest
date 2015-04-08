// 
// Copyright (c) Microsoft and contributors.  All rights reserved.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//   http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// 
// See the License for the specific language governing permissions and
// limitations under the License.
// 

var dateFormat = require('dateformat');

/**
* Formats a date into a RFC 1123 string.
*
* @param {date} date The date to format.
* @return {string} The date formated in the RFC 1123 date format.
*/
exports.format = function (date) {
  return dateFormat(date, 'ddd, dd mmm yyyy HH:MM:ss Z');
};

/**
* Parses an RFC 1123 date string into a date object.
*
* @param {string} stringDateTime The string with the date to parse in the RFC 1123 format.
* @return {date} The parsed date.
*/
exports.parse = function (stringDateTime) {
  return new Date(stringDateTime);
};