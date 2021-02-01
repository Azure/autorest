/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// Media Type is: type "/" [tree "."] subtype ["+" suffix] * [";" parameter]

const json = "json";
const xml = "xml";
const application = "application";
const text = "text";
const multipart = "multipart";
const formData = "form-data";
const formEncoded = "x-www-form-urlencoded";

export enum KnownMediaType {
  Json = "json",
  Xml = "xml",
  Form = "form",
  Binary = "binary",
  Multipart = "multipart",
  Text = "text",

  Unknown = "unknown",
}

export enum FormatType {
  QueryParameter = "-query-parameter-",
  UriParameter = "-uri-parameter-",

  Header = "-header-",
  Cookie = "-cookie-",
}

export function parseMediaType(mediaType: string) {
  if (mediaType) {
    const parsed = /(application|audio|font|example|image|message|model|multipart|text|video|x-(?:[0-9A-Za-z!#$%&'*+.^_`|~-]+))\/([0-9A-Za-z!#$%&'*.^_`|~-]+)\s*(?:\+([0-9A-Za-z!#$%&'*.^_`|~-]+))?\s*(?:;.\s*(\S*))?/g.exec(
      mediaType,
    );
    if (parsed) {
      return {
        type: parsed[1],
        subtype: parsed[2],
        suffix: parsed[3],
        parameter: parsed[4],
      };
    }
  }
  return undefined;
}

export function knownMediaType(mediaType: string) {
  const mt = parseMediaType(mediaType);
  if (mt) {
    if ((mt.subtype === json || mt.suffix === json) && (mt.type === application || mt.type === text)) {
      return KnownMediaType.Json;
    }
    if ((mt.subtype === xml || mt.suffix === xml) && (mt.type === application || mt.type === text)) {
      return KnownMediaType.Xml;
    }
    if (mt.type === "audio" || mt.type === "image" || mt.type === "video" || mt.subtype === "octet-stream") {
      return KnownMediaType.Binary;
    }
    if (mt.type === application && mt.subtype === formEncoded) {
      return KnownMediaType.Form;
    }
    if (mt.type === "multipart" && mt.subtype === "form-data") {
      return KnownMediaType.Multipart;
    }
    if (mt.type === application) {
      // at this point, an unrecognized application/* is considered a binary format
      // since we don't have any other way of dealing with it.
      return KnownMediaType.Binary;
    }
    if (mt.type === "text") {
      return KnownMediaType.Text;
    }
  }

  // pseudo-media types for figuring out how to de/serialize from from/to other types.
  /* switch (mediaType) {
    case 'header':
      return KnownMediaType.Header;
    case 'cookie':
      return KnownMediaType.Cookie;
    case 'urlencoding':
      return KnownMediaType.Cookie;
  }
  */
  return KnownMediaType.Unknown;
}

export function normalizeMediaType(contentType: string) {
  if (contentType) {
    const mt = parseMediaType(contentType);
    if (mt) {
      return mt.suffix ? `${mt.type}/${mt.subtype}+${mt.suffix}` : `${mt.type}/${mt.subtype}`;
    }
  }
  return undefined;
}

export function isMediaTypeJson(mediaType: string): boolean {
  const mt = parseMediaType(mediaType);
  return mt ? (mt.subtype === json || mt.suffix === json) && (mt.type === application || mt.type === text) : false;
}

export function isMediaTypeXml(mediaType: string): boolean {
  const mt = parseMediaType(mediaType);
  return mt ? (mt.subtype === xml || mt.suffix === xml) && (mt.type === application || mt.type === text) : false;
}

export function isMediaTypeMultipartFormData(mediaType: string): boolean {
  const mt = parseMediaType(mediaType);
  return mt ? mt.type === multipart && mt.subtype === formData : false;
}
