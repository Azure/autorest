import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace NotificationHubsClient;

enum MSApiVersionType {
  `2015-01`,
  `2015-04`,
  `2015-08`,
  `2016-07`,
}

enum NotificationHubContentModelType {
  `application/xml`,
}

enum NotificationHubDescriptionModelXmlnsI {
  `http://www.w3.org/2001/XMLSchema-instance`,
}

enum NotificationHubDescriptionModelAuthorizationRulesItemIType {
  `http://www.w3.org/2001/XMLSchema-instance`,
}

enum NotificationHubDescriptionModelAuthorizationRulesItemClaimType {
  SharedAccessAuthorizationRule,
}

enum RegistrationEntryModelXmlnsM {
  `http://schemas.microsoft.com/ado/2007/08/dataservices/metadata`,
}

enum PlatformType {
  apns,
  wns,
  gcm,
  baidu,
  adm,
}

enum InstallationPatchType {
  add,
  remove,
  replace,
}

enum FormatParameterType {
  apple,
  baidu,
  gcm,
  windows,
}

enum RegistrationContentModelType {
  `application/xml`,
}

enum AppleRegistrationContentModelXmlnsI {
  `http://www.w3.org/2001/XMLSchema-instance`,
}

enum AppleTemplateRegistrationContentModelXmlnsI {
  `http://www.w3.org/2001/XMLSchema-instance`,
}

enum BaiduRegistrationContentModelXmlnsI {
  `http://www.w3.org/2001/XMLSchema-instance`,
}

enum BaiduTemplateRegistrationContentModelXmlnsI {
  `http://www.w3.org/2001/XMLSchema-instance`,
}

enum GcmRegistrationContentModelXmlnsI {
  `http://www.w3.org/2001/XMLSchema-instance`,
}

enum GcmTemplateRegistrationContentModelXmlnsI {
  `http://www.w3.org/2001/XMLSchema-instance`,
}

enum WindowsRegistrationContentModelXmlnsI {
  `http://www.w3.org/2001/XMLSchema-instance`,
}

enum WindowsTemplateRegistrationContentModelXmlnsI {
  `http://www.w3.org/2001/XMLSchema-instance`,
}

enum ApiVersionType {
  `2015-01`,
  `2015-04`,
  `2015-08`,
  `2016-07`,
  `2020-06`,
}
@Azure.Core.fixed
enum ContentType {
  @doc("Content Type 'application/json;charset=utf-8'")
  `application/json;charset=utf-8`,
  @doc("Content Type 'application/xml;charset=utf-8'")
  `application/xml;charset=utf-8`,
}

model NotificationHubEntryModel {
  content?: NotificationHubContentModel;
}

model NotificationHubContentModel {
  type?: NotificationHubContentModelType;

  @projectedName("json", "NotificationHubDescription")
  notificationHubDescription?: NotificationHubDescriptionModel;
}

model NotificationHubDescriptionModel {
  @projectedName("json", "xmlns:i")
  xmlnsI?: NotificationHubDescriptionModelXmlnsI;

  @projectedName("json", "RegistrationTtl")
  registrationTtl?: string;

  @projectedName("json", "Location")
  location?: string;

  @projectedName("json", "ApnsCredential")
  apnsCredential?: PropertyBagModelItem[];

  @projectedName("json", "GcmCredential")
  gcmCredential?: PropertyBagModelItem[];

  @projectedName("json", "WnsCredential")
  wnsCredential?: PropertyBagModelItem[];

  @projectedName("json", "AuthorizationRules")
  authorizationRules?: NotificationHubDescriptionModelAuthorizationRulesItem[];
}

model PropertyBagModelItem {
  @projectedName("json", "Name")
  name?: string;

  @projectedName("json", "Value")
  value?: string;
}

model NotificationHubDescriptionModelAuthorizationRulesItem {
  @projectedName("json", "i:type")
  iType?: NotificationHubDescriptionModelAuthorizationRulesItemIType;

  @projectedName("json", "ClaimType")
  claimType?: NotificationHubDescriptionModelAuthorizationRulesItemClaimType;

  @projectedName("json", "ClaimValue")
  claimValue?: string;

  @projectedName("json", "Rights")
  rights?: string[];

  @projectedName("json", "CreatedTime")
  createdTime?: string;

  @projectedName("json", "ModifiedTime")
  modifiedTime?: string;

  @projectedName("json", "KeyName")
  keyName?: string;

  @projectedName("json", "PrimaryKey")
  primaryKey?: string;

  @projectedName("json", "SecondaryKey")
  secondaryKey?: string;
}

model RegistrationEntryModel {
  content?: NotificationHubContentModel;

  @projectedName("json", "xmlns:m")
  xmlnsM?: RegistrationEntryModelXmlnsM;

  @projectedName("json", "m:etag")
  mEtag?: string;
}

@resource("{hubName}/installations/{installationId}")
model InstallationModel {
  @doc("Installation Unique Identifier")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  installationId: string;

  @doc("The user ID for the installation")
  userId?: string;

  @doc("The date when the installation was made inactivate by the PNS.")
  @visibility("read")
  lastActiveOn?: string;

  @doc("Date in W3C format of last update to this installation.")
  @visibility("read")
  lastUpdate?: string;

  @doc("PNS Platform for the installation")
  platform: PlatformType;

  @doc("The unique device handle for the PNS.")
  pushChannel: string;

  @doc("This is true if the PNS expired the channel.")
  @visibility("read")
  expiredPushChannel?: boolean;

  @doc("The tags for the installation for targeting")
  tags?: string[];

  @doc("Set of named templates associated with the installation.")
  templates?: Record<InstallationTemplateModel>;

  @doc("""
Set of secondary tiles associated with the installation. Applies only to the
'wns' platform.
""")
  secondaryTiles?: Record<InstallationSecondaryTileModel>;
}

model InstallationTemplateModel {
  @doc("Template for the body of the notification.")
  body: string;

  @doc("""
Set of named headers associated with the template. Header values can contain
template parameters.
""")
  headers?: Record<string>;

  @doc("Template expression evaluating in W3D date format.")
  expiry?: string;

  @doc("The tags for the installation for targeting")
  tags?: string[];
}

model InstallationSecondaryTileModel {
  @doc("ChannelUri for the secondary tile. Applies only to the 'wns' platform.")
  pushChannel: string;

  @doc("The tags for the installation for targeting")
  tags?: string[];

  @doc("""
Set of named templates associated with the secondary tile. Applies only to the
'wns' platform.
""")
  templates?: Record<InstallationTemplateModel>;
}

model InstallationPatchModelItem {
  `op`: InstallationPatchType;
  path: string;
  value?: string;
}

model RegistrationContentModel {
  type?: RegistrationContentModelType;

  @projectedName("json", "AppleRegistrationDescription")
  appleRegistrationDescription?: AppleRegistrationContentModel;

  @projectedName("json", "AppleTemplateRegistrationDescription")
  appleTemplateRegistrationDescription?: AppleTemplateRegistrationContentModel;

  @projectedName("json", "BaiduRegistrationDescription")
  baiduRegistrationDescription?: BaiduRegistrationContentModel;

  @projectedName("json", "BaiduTemplateRegistrationDescription")
  baiduTemplateRegistrationDescription?: BaiduTemplateRegistrationContentModel;

  @projectedName("json", "GcmRegistrationDescription")
  gcmRegistrationDescription?: GcmRegistrationContentModel;

  @projectedName("json", "GcmTemplateRegistrationDescription")
  gcmTemplateRegistrationDescription?: GcmTemplateRegistrationContentModel;

  @projectedName("json", "WindowsRegistrationDescription")
  windowsRegistrationDescription?: WindowsRegistrationContentModel;

  @projectedName("json", "WindowsTemplateRegistrationDescription")
  windowsTemplateRegistrationDescription?: WindowsTemplateRegistrationContentModel;
}

model AppleRegistrationContentModel {
  @projectedName("json", "xmlns:i")
  xmlnsI?: AppleRegistrationContentModelXmlnsI;

  @projectedName("json", "Tags")
  tags?: string;

  @projectedName("json", "DeviceToken")
  deviceToken: string;
}

model AppleTemplateRegistrationContentModel {
  @projectedName("json", "xmlns:i")
  xmlnsI?: AppleTemplateRegistrationContentModelXmlnsI;

  @projectedName("json", "Tags")
  tags?: string;

  @projectedName("json", "DeviceToken")
  deviceToken: string;

  @projectedName("json", "BodyTemplate")
  bodyTemplate: string;

  @projectedName("json", "Expiry")
  expiry?: string;
}

model BaiduRegistrationContentModel {
  @projectedName("json", "xmlns:i")
  xmlnsI?: BaiduRegistrationContentModelXmlnsI;

  @projectedName("json", "Tags")
  tags?: string;

  @projectedName("json", "BaiduUserId")
  baiduUserId: string;

  @projectedName("json", "BaiduChannelId")
  baiduChannelId: string;
}

model BaiduTemplateRegistrationContentModel {
  @projectedName("json", "xmlns:i")
  xmlnsI?: BaiduTemplateRegistrationContentModelXmlnsI;

  @projectedName("json", "Tags")
  tags?: string;

  @projectedName("json", "BaiduUserId")
  baiduUserId: string;

  @projectedName("json", "BaiduChannelId")
  baiduChannelId: string;

  @projectedName("json", "BodyTemplate")
  bodyTemplate: string;
}

model GcmRegistrationContentModel {
  @projectedName("json", "xmlns:i")
  xmlnsI?: GcmRegistrationContentModelXmlnsI;

  @projectedName("json", "Tags")
  tags?: string;

  @projectedName("json", "GcmRegistrationId")
  gcmRegistrationId?: string;
}

model GcmTemplateRegistrationContentModel {
  @projectedName("json", "xmlns:i")
  xmlnsI?: GcmTemplateRegistrationContentModelXmlnsI;

  @projectedName("json", "Tags")
  tags?: string;

  @projectedName("json", "GcmRegistrationId")
  gcmRegistrationId: string;

  @projectedName("json", "BodyTemplate")
  bodyTemplate: string;
}

model WindowsRegistrationContentModel {
  @projectedName("json", "xmlns:i")
  xmlnsI?: WindowsRegistrationContentModelXmlnsI;

  @projectedName("json", "Tags")
  tags?: string;

  @projectedName("json", "ChannelUri")
  channelUri: string;
}

model WindowsTemplateRegistrationContentModel {
  @projectedName("json", "xmlns:i")
  xmlnsI?: WindowsTemplateRegistrationContentModelXmlnsI;

  @projectedName("json", "Tags")
  tags?: string;

  @projectedName("json", "ChannelUri")
  channelUri: string;

  @projectedName("json", "BodyTemplate")
  bodyTemplate: string;

  @projectedName("json", "WnsHeaders")
  wnsHeaders?: WindowsTemplateRegistrationContentModelWnsHeadersItem[];
}

model WindowsTemplateRegistrationContentModelWnsHeadersItem {
  @projectedName("json", "Header")
  header?: string;

  @projectedName("json", "Value")
  value?: string;
}
