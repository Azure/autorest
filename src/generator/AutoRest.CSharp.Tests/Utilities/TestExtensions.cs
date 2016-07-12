// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Net;
using System.Runtime.CompilerServices;

namespace AutoRest.CSharp.Tests.Utilities
{
    public static class TestExtensions
    {
        public static HttpStatusCode ToStatusCode(this string statusCode)
        {
            HttpStatusCode returnCode;
            switch (statusCode)
            {
                case "202":
                    returnCode = HttpStatusCode.Accepted;
                    break;
                case "300":
                    returnCode = HttpStatusCode.Ambiguous;
                    break;
                case "502":
                    returnCode = HttpStatusCode.BadGateway;
                    break;
                case "400":
                    returnCode = HttpStatusCode.BadRequest;
                    break;
                case "409":
                    returnCode = HttpStatusCode.Conflict;
                    break;
                case "100":
                    returnCode = HttpStatusCode.Continue;
                    break;
                case "201":
                    returnCode = HttpStatusCode.Created;
                    break;
                case "417":
                    returnCode = HttpStatusCode.ExpectationFailed;
                    break;
                case "403":
                    returnCode = HttpStatusCode.Forbidden;
                    break;
                case "302":
                    returnCode = HttpStatusCode.Found;
                    break;
                case "504":
                    returnCode = HttpStatusCode.GatewayTimeout;
                    break;
                case "410":
                    returnCode = HttpStatusCode.Gone;
                    break;
                case "505":
                    returnCode = HttpStatusCode.HttpVersionNotSupported;
                    break;
                case "500":
                    returnCode = HttpStatusCode.InternalServerError;
                    break;
                case "411":
                    returnCode = HttpStatusCode.LengthRequired;
                    break;
                case "405":
                    returnCode = HttpStatusCode.MethodNotAllowed;
                    break;
                case "301":
                    returnCode = HttpStatusCode.Moved;
                    break;
                case "204":
                    returnCode = HttpStatusCode.NoContent;
                    break;
                case "203":
                    returnCode = HttpStatusCode.NonAuthoritativeInformation;
                    break;
                case "406":
                    returnCode = HttpStatusCode.NotAcceptable;
                    break;
                case "404":
                    returnCode = HttpStatusCode.NotFound;
                    break;
                case "501":
                    returnCode = HttpStatusCode.NotImplemented;
                    break;
                case "304":
                    returnCode = HttpStatusCode.NotModified;
                    break;
                case "206":
                    returnCode = HttpStatusCode.PartialContent;
                    break;
                case "402":
                    returnCode = HttpStatusCode.PaymentRequired;
                    break;
                case "412":
                    returnCode = HttpStatusCode.PreconditionFailed;
                    break;
                case "407":
                    returnCode = HttpStatusCode.ProxyAuthenticationRequired;
                    break;
                case "307":
                    returnCode = HttpStatusCode.RedirectKeepVerb;
                    break;
                case "303":
                    returnCode = HttpStatusCode.RedirectMethod;
                    break;
                case "416":
                    returnCode = HttpStatusCode.RequestedRangeNotSatisfiable;
                    break;
                case "413":
                    returnCode = HttpStatusCode.RequestEntityTooLarge;
                    break;
                case "408":
                    returnCode = HttpStatusCode.RequestTimeout;
                    break;
                case "414":
                    returnCode = HttpStatusCode.RequestUriTooLong;
                    break;
                case "205":
                    returnCode = HttpStatusCode.ResetContent;
                    break;
                case "503":
                    returnCode = HttpStatusCode.ServiceUnavailable;
                    break;
                case "101":
                    returnCode = HttpStatusCode.SwitchingProtocols;
                    break;
                case "401":
                    returnCode = HttpStatusCode.Unauthorized;
                    break;
                case "415":
                    returnCode = HttpStatusCode.UnsupportedMediaType;
                    break;
                case "306":
                    returnCode = HttpStatusCode.Unused;
                    break;
                case "426":
                    returnCode = HttpStatusCode.UpgradeRequired;
                    break;
                case "305":
                    returnCode = HttpStatusCode.UseProxy;
                    break;
                default:
                    returnCode = HttpStatusCode.OK;
                    break;
            }
            return returnCode;
        }

        public static bool DirectoryExists(this string path)
        {
            try
            {
                return Directory.Exists(path);
            }
            catch
            {
            }
            return false;
        }

        public static string CombinePath(this string basePath, string additionalPath)
        {
            if (basePath == null)
            {
                basePath = Directory.GetCurrentDirectory();
            }
            if (additionalPath == null)
            {
                return basePath;
            }

            try
            {
                return Path.Combine(basePath, additionalPath);
            }
            catch
            {
            }
            return null;
        }

        public static string FindFolderByWalkingUpPath(this string folderName, string currentDirectory = null)
        {
            try
            {
                currentDirectory = currentDirectory ?? Environment.CurrentDirectory;
                if (!string.IsNullOrEmpty(currentDirectory))
                {
                    try
                    {
                        currentDirectory = Path.GetFullPath(currentDirectory);
                    }
                    catch
                    {
                    }

                    while (!string.IsNullOrEmpty(currentDirectory))
                    {
                        var chkPath = Path.Combine(currentDirectory, folderName);
                        if (chkPath.DirectoryExists())
                        {
                            return chkPath;
                        }
                        currentDirectory = Path.GetDirectoryName(currentDirectory);
                    }
                }
            }
            catch
            {
            }
            return null;
        }
    }
}
