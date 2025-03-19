import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace NotificationHubsClient;

union MSApiVersionType {
  string,
  `2015-01`: "2015-01",
  `2015-04`: "2015-04",
  `2015-08`: "2015-08",
  `2016-07`: "2016-07",
}

union NotificationHubContentModelType {
  string,
  `application/xml`: "application/xml",
}

union NotificationHubDescriptionModelXmlnsI {
  string,
  `http://www.w3.org/2001/XMLSchema-instance`: "http://www.w3.org/2001/XMLSchema-instance",
}

union NotificationHubDescriptionModelAuthorizationRulesItemIType {
  string,
  `http://www.w3.org/2001/XMLSchema-instance`: "http://www.w3.org/2001/XMLSchema-instance",
}

union NotificationHubDescriptionModelAuthorizationRulesItemClaimType {
  string,
  SharedAccessAuthorizationRule: "SharedAccessAuthorizationRule",
}

union RegistrationEntryModelXmlnsM {
  string,
  `http://schemas.microsoft.com/ado/2007/08/dataservices/metadata`: "http://schemas.microsoft.com/ado/2007/08/dataservices/metadata",
}

/**
 * PNS Platform for the installation
 */
union PlatformType {
  string,
  apns: "apns",
  wns: "wns",
  gcm: "gcm",
  baidu: "baidu",
  adm: "adm",
}

union InstallationPatchType {
  string,
  add: "add",
  remove: "remove",
  replace: "replace",
}

union FormatParameterType {
  string,
  apple: "apple",
  baidu: "baidu",
  gcm: "gcm",
  windows: "windows",
}

union RegistrationContentModelType {
  string,
  `application/xml`: "application/xml",
}

union AppleRegistrationContentModelXmlnsI {
  string,
  `http://www.w3.org/2001/XMLSchema-instance`: "http://www.w3.org/2001/XMLSchema-instance",
}

union AppleTemplateRegistrationContentModelXmlnsI {
  string,
  `http://www.w3.org/2001/XMLSchema-instance`: "http://www.w3.org/2001/XMLSchema-instance",
}

union BaiduRegistrationContentModelXmlnsI {
  string,
  `http://www.w3.org/2001/XMLSchema-instance`: "http://www.w3.org/2001/XMLSchema-instance",
}

union BaiduTemplateRegistrationContentModelXmlnsI {
  string,
  `http://www.w3.org/2001/XMLSchema-instance`: "http://www.w3.org/2001/XMLSchema-instance",
}

union GcmRegistrationContentModelXmlnsI {
  string,
  `http://www.w3.org/2001/XMLSchema-instance`: "http://www.w3.org/2001/XMLSchema-instance",
}

union GcmTemplateRegistrationContentModelXmlnsI {
  string,
  `http://www.w3.org/2001/XMLSchema-instance`: "http://www.w3.org/2001/XMLSchema-instance",
}

union WindowsRegistrationContentModelXmlnsI {
  string,
  `http://www.w3.org/2001/XMLSchema-instance`: "http://www.w3.org/2001/XMLSchema-instance",
}

union WindowsTemplateRegistrationContentModelXmlnsI {
  string,
  `http://www.w3.org/2001/XMLSchema-instance`: "http://www.w3.org/2001/XMLSchema-instance",
}

union ApiVersionType {
  string,
  `2015-01`: "2015-01",
  `2015-04`: "2015-04",
  `2015-08`: "2015-08",
  `2016-07`: "2016-07",
  `2020-06`: "2020-06",
}

/**
 * Content type for upload
 */
enum ContentType {
  /**
   * Content Type 'application/json;charset=utf-8'
   */
  `application/json;charset=utf-8`,

  /**
   * Content Type 'application/xml;charset=utf-8'
   */
  `application/xml;charset=utf-8`,
}

model NotificationHubEntryModel {
  content?: NotificationHubContentModel;
}

model NotificationHubContentModel {
  type?: NotificationHubContentModelType;
  NotificationHubDescription?: NotificationHubDescriptionModel;
}

model NotificationHubDescriptionModel {
  `xmlns:i`?: NotificationHubDescriptionModelXmlnsI;
  RegistrationTtl?: string;
  Location?: string;
  ApnsCredential?: PropertyBagModelItem[];
  GcmCredential?: PropertyBagModelItem[];
  WnsCredential?: PropertyBagModelItem[];
  AuthorizationRules?: NotificationHubDescriptionModelAuthorizationRulesItem[];
}

model PropertyBagModelItem {
  Name?: string;
  Value?: string;
}

model NotificationHubDescriptionModelAuthorizationRulesItem {
  `i:type`?: NotificationHubDescriptionModelAuthorizationRulesItemIType;
  ClaimType?: NotificationHubDescriptionModelAuthorizationRulesItemClaimType;
  ClaimValue?: string;
  Rights?: string[];
  CreatedTime?: string;
  ModifiedTime?: string;
  KeyName?: string;
  PrimaryKey?: string;
  SecondaryKey?: string;
}

model RegistrationEntryModel {
  content?: NotificationHubContentModel;
  `xmlns:m`?: RegistrationEntryModelXmlnsM;
  `m:etag`?: string;
}

@resource("{hubName}/installations/{installationId}")
model InstallationModel {
  /**
   * Installation Unique Identifier
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  installationId: string;

  /**
   * The user ID for the installation
   */
  userId?: string;

  /**
   * The date when the installation was made inactivate by the PNS.
   */
  @visibility(Lifecycle.Read)
  lastActiveOn?: string;

  /**
   * Date in W3C format of last update to this installation.
   */
  @visibility(Lifecycle.Read)
  lastUpdate?: string;

  /**
   * PNS Platform for the installation
   */
  platform: PlatformType;

  /**
   * The unique device handle for the PNS.
   */
  pushChannel: string;

  /**
   * This is true if the PNS expired the channel.
   */
  @visibility(Lifecycle.Read)
  expiredPushChannel?: boolean;

  /**
   * The tags for the installation for targeting
   */
  tags?: string[];

  /**
   * Set of named templates associated with the installation.
   */
  templates?: Record<InstallationTemplateModel>;

  /**
   * Set of secondary tiles associated with the installation. Applies only to the
   * 'wns' platform.
   */
  secondaryTiles?: Record<InstallationSecondaryTileModel>;
}

model InstallationTemplateModel {
  /**
   * Template for the body of the notification.
   */
  body: string;

  /**
   * Set of named headers associated with the template. Header values can contain
   * template parameters.
   */
  headers?: Record<string>;

  /**
   * Template expression evaluating in W3D date format.
   */
  expiry?: string;

  /**
   * The tags for the installation for targeting
   */
  tags?: string[];
}

model InstallationSecondaryTileModel {
  /**
   * ChannelUri for the secondary tile. Applies only to the 'wns' platform.
   */
  pushChannel: string;

  /**
   * The tags for the installation for targeting
   */
  tags?: string[];

  /**
   * Set of named templates associated with the secondary tile. Applies only to the
   * 'wns' platform.
   */
  templates?: Record<InstallationTemplateModel>;
}

model InstallationPatchModelItem {
  `op`: InstallationPatchType;
  path: string;
  value?: string;
}

model RegistrationContentModel {
  type?: RegistrationContentModelType;
  AppleRegistrationDescription?: AppleRegistrationContentModel;
  AppleTemplateRegistrationDescription?: AppleTemplateRegistrationContentModel;
  BaiduRegistrationDescription?: BaiduRegistrationContentModel;
  BaiduTemplateRegistrationDescription?: BaiduTemplateRegistrationContentModel;
  GcmRegistrationDescription?: GcmRegistrationContentModel;
  GcmTemplateRegistrationDescription?: GcmTemplateRegistrationContentModel;
  WindowsRegistrationDescription?: WindowsRegistrationContentModel;
  WindowsTemplateRegistrationDescription?: WindowsTemplateRegistrationContentModel;
}

model AppleRegistrationContentModel {
  `xmlns:i`?: AppleRegistrationContentModelXmlnsI;
  Tags?: string;
  DeviceToken: string;
}

model AppleTemplateRegistrationContentModel {
  `xmlns:i`?: AppleTemplateRegistrationContentModelXmlnsI;
  Tags?: string;
  DeviceToken: string;
  BodyTemplate: string;
  Expiry?: string;
}

model BaiduRegistrationContentModel {
  `xmlns:i`?: BaiduRegistrationContentModelXmlnsI;
  Tags?: string;
  BaiduUserId: string;
  BaiduChannelId: string;
}

model BaiduTemplateRegistrationContentModel {
  `xmlns:i`?: BaiduTemplateRegistrationContentModelXmlnsI;
  Tags?: string;
  BaiduUserId: string;
  BaiduChannelId: string;
  BodyTemplate: string;
}

model GcmRegistrationContentModel {
  `xmlns:i`?: GcmRegistrationContentModelXmlnsI;
  Tags?: string;
  GcmRegistrationId?: string;
}

model GcmTemplateRegistrationContentModel {
  `xmlns:i`?: GcmTemplateRegistrationContentModelXmlnsI;
  Tags?: string;
  GcmRegistrationId: string;
  BodyTemplate: string;
}

model WindowsRegistrationContentModel {
  `xmlns:i`?: WindowsRegistrationContentModelXmlnsI;
  Tags?: string;
  ChannelUri: string;
}

model WindowsTemplateRegistrationContentModel {
  `xmlns:i`?: WindowsTemplateRegistrationContentModelXmlnsI;
  Tags?: string;
  ChannelUri: string;
  BodyTemplate: string;
  WnsHeaders?: WindowsTemplateRegistrationContentModelWnsHeadersItem[];
}

model WindowsTemplateRegistrationContentModelWnsHeadersItem {
  Header?: string;
  Value?: string;
}
