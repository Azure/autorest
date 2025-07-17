import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using NotificationHubsClient;

@@clientName(NotificationHubContentModel.NotificationHubDescription,
  "notificationHubDescription"
);

@@clientName(NotificationHubDescriptionModel.`xmlns:i`, "xmlnsI");
@@clientName(NotificationHubDescriptionModel.RegistrationTtl,
  "registrationTtl"
);
@@clientName(NotificationHubDescriptionModel.Location, "location");
@@clientName(NotificationHubDescriptionModel.ApnsCredential, "apnsCredential");
@@clientName(NotificationHubDescriptionModel.GcmCredential, "gcmCredential");
@@clientName(NotificationHubDescriptionModel.WnsCredential, "wnsCredential");
@@clientName(NotificationHubDescriptionModel.AuthorizationRules,
  "authorizationRules"
);

@@clientName(PropertyBagModelItem.Name, "name");
@@clientName(PropertyBagModelItem.Value, "value");

@@clientName(NotificationHubDescriptionModelAuthorizationRulesItem.`i:type`,
  "iType"
);
@@clientName(NotificationHubDescriptionModelAuthorizationRulesItem.ClaimType,
  "claimType"
);
@@clientName(NotificationHubDescriptionModelAuthorizationRulesItem.ClaimValue,
  "claimValue"
);
@@clientName(NotificationHubDescriptionModelAuthorizationRulesItem.Rights,
  "rights"
);
@@clientName(NotificationHubDescriptionModelAuthorizationRulesItem.CreatedTime,
  "createdTime"
);
@@clientName(NotificationHubDescriptionModelAuthorizationRulesItem.ModifiedTime,
  "modifiedTime"
);
@@clientName(NotificationHubDescriptionModelAuthorizationRulesItem.KeyName,
  "keyName"
);
@@clientName(NotificationHubDescriptionModelAuthorizationRulesItem.PrimaryKey,
  "primaryKey"
);
@@clientName(NotificationHubDescriptionModelAuthorizationRulesItem.SecondaryKey,
  "secondaryKey"
);

@@clientName(RegistrationEntryModel.`xmlns:m`, "xmlnsM");
@@clientName(RegistrationEntryModel.`m:etag`, "mEtag");

@@clientName(RegistrationContentModel.AppleRegistrationDescription,
  "appleRegistrationDescription"
);
@@clientName(RegistrationContentModel.AppleTemplateRegistrationDescription,
  "appleTemplateRegistrationDescription"
);
@@clientName(RegistrationContentModel.BaiduRegistrationDescription,
  "baiduRegistrationDescription"
);
@@clientName(RegistrationContentModel.BaiduTemplateRegistrationDescription,
  "baiduTemplateRegistrationDescription"
);
@@clientName(RegistrationContentModel.GcmRegistrationDescription,
  "gcmRegistrationDescription"
);
@@clientName(RegistrationContentModel.GcmTemplateRegistrationDescription,
  "gcmTemplateRegistrationDescription"
);
@@clientName(RegistrationContentModel.WindowsRegistrationDescription,
  "windowsRegistrationDescription"
);
@@clientName(RegistrationContentModel.WindowsTemplateRegistrationDescription,
  "windowsTemplateRegistrationDescription"
);

@@clientName(AppleRegistrationContentModel.`xmlns:i`, "xmlnsI");
@@clientName(AppleRegistrationContentModel.Tags, "tags");
@@clientName(AppleRegistrationContentModel.DeviceToken, "deviceToken");

@@clientName(AppleTemplateRegistrationContentModel.`xmlns:i`, "xmlnsI");
@@clientName(AppleTemplateRegistrationContentModel.Tags, "tags");
@@clientName(AppleTemplateRegistrationContentModel.DeviceToken, "deviceToken");
@@clientName(AppleTemplateRegistrationContentModel.BodyTemplate,
  "bodyTemplate"
);
@@clientName(AppleTemplateRegistrationContentModel.Expiry, "expiry");

@@clientName(BaiduRegistrationContentModel.`xmlns:i`, "xmlnsI");
@@clientName(BaiduRegistrationContentModel.Tags, "tags");
@@clientName(BaiduRegistrationContentModel.BaiduUserId, "baiduUserId");
@@clientName(BaiduRegistrationContentModel.BaiduChannelId, "baiduChannelId");

@@clientName(BaiduTemplateRegistrationContentModel.`xmlns:i`, "xmlnsI");
@@clientName(BaiduTemplateRegistrationContentModel.Tags, "tags");
@@clientName(BaiduTemplateRegistrationContentModel.BaiduUserId, "baiduUserId");
@@clientName(BaiduTemplateRegistrationContentModel.BaiduChannelId,
  "baiduChannelId"
);
@@clientName(BaiduTemplateRegistrationContentModel.BodyTemplate,
  "bodyTemplate"
);

@@clientName(GcmRegistrationContentModel.`xmlns:i`, "xmlnsI");
@@clientName(GcmRegistrationContentModel.Tags, "tags");
@@clientName(GcmRegistrationContentModel.GcmRegistrationId,
  "gcmRegistrationId"
);

@@clientName(GcmTemplateRegistrationContentModel.`xmlns:i`, "xmlnsI");
@@clientName(GcmTemplateRegistrationContentModel.Tags, "tags");
@@clientName(GcmTemplateRegistrationContentModel.GcmRegistrationId,
  "gcmRegistrationId"
);
@@clientName(GcmTemplateRegistrationContentModel.BodyTemplate, "bodyTemplate");

@@clientName(WindowsRegistrationContentModel.`xmlns:i`, "xmlnsI");
@@clientName(WindowsRegistrationContentModel.Tags, "tags");
@@clientName(WindowsRegistrationContentModel.ChannelUri, "channelUri");

@@clientName(WindowsTemplateRegistrationContentModel.`xmlns:i`, "xmlnsI");
@@clientName(WindowsTemplateRegistrationContentModel.Tags, "tags");
@@clientName(WindowsTemplateRegistrationContentModel.ChannelUri, "channelUri");
@@clientName(WindowsTemplateRegistrationContentModel.BodyTemplate,
  "bodyTemplate"
);
@@clientName(WindowsTemplateRegistrationContentModel.WnsHeaders, "wnsHeaders");

@@clientName(WindowsTemplateRegistrationContentModelWnsHeadersItem.Header,
  "header"
);
@@clientName(WindowsTemplateRegistrationContentModelWnsHeadersItem.Value,
  "value"
);

@@clientName(deleteNotificationHub, "DeleteNotificationHub");
@@clientName(getNotificationHub, "GetNotificationHub");
@@clientName(createOrUpdateNotificationHub, "CreateOrUpdateNotificationHub");
@@clientName(getRegistrationsByTag, "GetRegistrationsByTag");
@@clientName(createRegistrationId, "CreateRegistrationId");
@@clientName(getRegistrations, "GetRegistrations");
@@clientName(createRegistration, "CreateRegistration");
@@clientName(deleteRegistration, "DeleteRegistration");
@@clientName(getRegistration, "GetRegistration");
@@clientName(createOrUpdateRegistration, "CreateOrUpdateRegistration");
@@clientName(deleteInstallation, "DeleteInstallation");
@@clientName(getInstallation, "GetInstallation");
@@clientName(patchInstallation, "PatchInstallation");
@@clientName(createOrUpdateInstallation, "CreateOrUpdateInstallation");
@@clientName(sendMessage, "SendMessage");
@@clientName(sendMessage, "SendMessage");
