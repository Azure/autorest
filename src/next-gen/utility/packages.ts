/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as fs from 'fs';
import * as https from 'https';
import * as mkdirp from 'mkdirp';
import * as path from 'path';
import * as tmp from 'tmp';
import { parse as parseUrl } from 'url';
import * as yauzl from 'yauzl';
import * as util from './common';
import { Logger } from './logger';
import { PlatformInformation } from './platform';
import { getProxyAgent } from './proxy';

export interface Package {
    description: string;
    url: string;
    fallbackUrl?: string;
    installPath?: string;
    platforms: string[];
    runtimeIds: string[];
    architectures: string[];
    binaries: string[];
    tmpFile: tmp.SynchrounousResult;
}

export interface Status {
    setMessage: (text: string) => void;
    setDetail: (text: string) => void;
}

export class PackageError extends Error {
    // Do not put PII (personally identifiable information) in the 'message' field as it will be logged to telemetry
    constructor(public message: string, 
                public pkg: Package = null, 
                public innerError: any = null) {
        super(message);
    }
}

export class PackageManager {
    private allPackages: Package[];

    public constructor(
        private platformInfo: PlatformInformation,
        private packageJSON: any) {

        // Ensure our temp files get cleaned up in case of error.
        tmp.setGracefulCleanup();
    }

    public DownloadPackages(logger: Logger, status: Status, proxy: string, strictSSL: boolean): Promise<void> {
        return this.GetPackages()
            .then(packages => {
                return util.buildPromiseChain(packages, pkg => downloadPackage(pkg, logger, status, proxy, strictSSL));
            });
    }

    public InstallPackages(logger: Logger, status: Status): Promise<void> {
        return this.GetPackages()
            .then(packages => {
                return util.buildPromiseChain(packages, pkg => installPackage(pkg, logger, status));
            });
    }

    private GetAllPackages(): Promise<Package[]> {
        return new Promise<Package[]>((resolve, reject) => {
            if (this.allPackages) {
                resolve(this.allPackages);
            }
            else if (this.packageJSON.runtimeDependencies) {
                this.allPackages = <Package[]>this.packageJSON.runtimeDependencies;

                // Convert relative binary paths to absolute
                for (let pkg of this.allPackages) {
                    if (pkg.binaries) {
                        pkg.binaries = pkg.binaries.map(value => path.resolve(getBaseInstallPath(pkg), value));
                    }
                }

                resolve(this.allPackages);
            }
            else {
                reject(new PackageError("Package manifest does not exist."));
            }
        });
    }

    private GetPackages(): Promise<Package[]> {
        return this.GetAllPackages()
            .then(list => {
                return list.filter(pkg => {
                    if (pkg.runtimeIds) {
                        if (!this.platformInfo.runtimeId || pkg.runtimeIds.indexOf(this.platformInfo.runtimeId) === -1) {
                            return false;
                        }
                    }

                    if (pkg.architectures && pkg.architectures.indexOf(this.platformInfo.architecture) === -1) {
                        return false;
                    }

                    if (pkg.platforms && pkg.platforms.indexOf(this.platformInfo.platform) === -1) {
                        return false;
                    }

                    return true;
                });
            });
    }
}

function getBaseInstallPath(pkg: Package): string {
    let basePath = util.getExtensionPath();
    if (pkg.installPath) {
        basePath = path.join(basePath, pkg.installPath);
    }

    return basePath;
}

function getNoopStatus(): Status {
    return {
        setMessage: text => { },
        setDetail: text => { }
    };
}

function downloadPackage(pkg: Package, logger: Logger, status: Status, proxy: string, strictSSL: boolean): Promise<void> {
    status = status || getNoopStatus();

    logger.append(`Downloading package '${pkg.description}' `);
    
    status.setMessage("$(cloud-download) Downloading packages");
    status.setDetail(`Downloading package '${pkg.description}'...`);

    return new Promise<tmp.SynchrounousResult>((resolve, reject) => {
        tmp.file({ prefix: 'package-' }, (err, path, fd, cleanupCallback) => {
            if (err) {
                return reject(new PackageError('Error from tmp.file', pkg, err));
            }

            resolve(<tmp.SynchrounousResult>{ name: path, fd: fd, removeCallback: cleanupCallback });
        });
    }).then(tmpResult => {
        pkg.tmpFile = tmpResult;

        let result = downloadFile(pkg.url, pkg, logger, status, proxy, strictSSL)
            .then(() => logger.appendLine(' Done!'));

        // If the package has a fallback Url, and downloading from the primary Url failed, try again from 
        // the fallback. This is used for debugger packages as some users have had issues downloading from
        // the CDN link.
        if (pkg.fallbackUrl) {
            result = result.catch((primaryUrlError) => {
                logger.append(`\tRetrying from '${pkg.fallbackUrl}' `);
                return downloadFile(pkg.fallbackUrl, pkg, logger, status, proxy, strictSSL)
                    .then(() => logger.appendLine(' Done!'))
                    .catch(() => primaryUrlError);
            });
        }

        return result;
    });
}

function downloadFile(urlString: string, pkg: Package, logger: Logger, status: Status, proxy: string, strictSSL: boolean): Promise<void> {
    const url = parseUrl(urlString);

    const options: https.RequestOptions = {
        host: url.host,
        path: url.path,
        agent: getProxyAgent(url, proxy, strictSSL),
        rejectUnauthorized: util.isBoolean(strictSSL) ? strictSSL : true
    };

    return new Promise<void>((resolve, reject) => {
        if (!pkg.tmpFile || pkg.tmpFile.fd == 0) {
            return reject(new PackageError("Temporary package file unavailable", pkg));
        }

        let request = https.request(options, response => {
            if (response.statusCode === 301 || response.statusCode === 302) {
                // Redirect - download from new location
                return resolve(downloadFile(response.headers.location, pkg, logger, status, proxy, strictSSL));
            }

            if (response.statusCode != 200) {
                // Download failed - print error message
                logger.appendLine(`failed (error code '${response.statusCode}')`);
                return reject(new PackageError(response.statusCode.toString(), pkg));
            }
            
            // Downloading - hook up events
            let packageSize = parseInt(response.headers['content-length'], 10);
            let downloadedBytes = 0;
            let downloadPercentage = 0;
            let dots = 0;
            let tmpFile = fs.createWriteStream(null, { fd: pkg.tmpFile.fd });

            logger.append(`(${Math.ceil(packageSize / 1024)} KB) `);

            response.on('data', data => {
                downloadedBytes += data.length;

                // Update status bar item with percentage
                let newPercentage = Math.ceil(100 * (downloadedBytes / packageSize));
                if (newPercentage !== downloadPercentage) {
                    status.setDetail(`Downloading package '${pkg.description}'... ${downloadPercentage}%`);
                    downloadPercentage = newPercentage;
                }

                // Update dots after package name in output console
                let newDots = Math.ceil(downloadPercentage / 5);
                if (newDots > dots) {
                    logger.append('.'.repeat(newDots - dots));
                    dots = newDots;
                }
            });

            response.on('end', () => {
                resolve();
            });

            response.on('error', err => {
                reject(new PackageError(`Reponse error: ${err.message || 'NONE'}`, pkg, err));
            });

            // Begin piping data from the response to the package file
            response.pipe(tmpFile, { end: false });
        });

        request.on('error', err => {
            reject(new PackageError(`Request error: ${err.message || 'NONE'}`, pkg, err));
        });

        // Execute the request
        request.end();
    });
}

function installPackage(pkg: Package, logger: Logger, status?: Status): Promise<void> {
    status = status || getNoopStatus();

    logger.appendLine(`Installing package '${pkg.description}'`);

    status.setMessage("$(desktop-download) Installing packages...");
    status.setDetail(`Installing package '${pkg.description}'`);

    return new Promise<void>((resolve, reject) => {
        if (!pkg.tmpFile || pkg.tmpFile.fd == 0) {
            return reject(new PackageError('Downloaded file unavailable', pkg));
        }

        yauzl.fromFd(pkg.tmpFile.fd, { lazyEntries: true }, (err, zipFile) => {
            if (err) {
                return reject(new PackageError('Immediate zip file error', pkg, err));
            }

            zipFile.readEntry();

            zipFile.on('entry', (entry: yauzl.Entry) => {
                let absoluteEntryPath = path.resolve(getBaseInstallPath(pkg), entry.fileName);

                if (entry.fileName.endsWith('/')) {
                    // Directory - create it
                    mkdirp(absoluteEntryPath, { mode: 0o775 }, err => {
                        if (err) {
                            return reject(new PackageError('Error creating directory for zip directory entry:' + err.code || '', pkg, err));
                        }

                        zipFile.readEntry();
                    });
                }
                else {
                    // File - extract it
                    zipFile.openReadStream(entry, (err, readStream) => {
                        if (err) {
                            return reject(new PackageError('Error reading zip stream', pkg, err));
                        }

                        mkdirp(path.dirname(absoluteEntryPath), { mode: 0o775 }, err => {
                            if (err) {
                                return reject(new PackageError('Error creating directory for zip file entry', pkg, err));
                            }

                            // Make sure executable files have correct permissions when extracted
                            let fileMode = pkg.binaries && pkg.binaries.indexOf(absoluteEntryPath) !== -1
                                ? 0o755
                                : 0o664;

                            readStream.pipe(fs.createWriteStream(absoluteEntryPath, { mode: fileMode }));
                            readStream.on('end', () => zipFile.readEntry());
                        });
                    });
                }
            });

            zipFile.on('end', () => {
                resolve();
            });

            zipFile.on('error', err => {
                reject(new PackageError('Zip File Error:' + err.code || '', pkg, err));
            });
        });
    }).then(() => {
        // Clean up temp file
        pkg.tmpFile.removeCallback();
    });
}
