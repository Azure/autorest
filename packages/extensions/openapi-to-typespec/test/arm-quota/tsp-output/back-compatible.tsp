import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Quota;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GroupQuotaDetails.name);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GroupQuotaRequestBase.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GroupQuotaRequestBaseProperties.name);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SubscriptionQuotaDetails.name);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QuotaAllocationRequestBase.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QuotaAllocationRequestBaseProperties.name);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GroupQuotaUsagesBase.name);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QuotaRequestOneResourceSubmitResponse.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QuotaRequestSubmitResponse202.properties);

@@clientLocation(GroupQuotasEntities.get, "GroupQuotas");
@@clientLocation(GroupQuotasEntities.createOrUpdate, "GroupQuotas");
@@clientName(GroupQuotasEntities.createOrUpdate, "CreateOrUpdate");
@@clientName(GroupQuotasEntities.createOrUpdate::parameters.resource,
  "GroupQuotaPutRequestBody"
);
@@clientLocation(GroupQuotasEntities.update, "GroupQuotas");
@@clientName(GroupQuotasEntities.update::parameters.properties,
  " GroupQuotasPatchRequestBody"
);
@@clientLocation(GroupQuotasEntities.delete, "GroupQuotas");
@@clientLocation(GroupQuotasEntities.list, "GroupQuotas");
@@clientLocation(GroupQuotasEntities.groupQuotaLimitsRequestList,
  "GroupQuotaLimitsRequest"
);
@@clientName(GroupQuotasEntities.groupQuotaLimitsRequestList, "List");

@@clientLocation(GroupQuotaSubscriptionIds.get, "GroupQuotaSubscriptions");
@@clientLocation(GroupQuotaSubscriptionIds.createOrUpdate,
  "GroupQuotaSubscriptions"
);
@@clientName(GroupQuotaSubscriptionIds.createOrUpdate, "CreateOrUpdate");
@@clientLocation(GroupQuotaSubscriptionIds.update, "GroupQuotaSubscriptions");
@@clientLocation(GroupQuotaSubscriptionIds.delete, "GroupQuotaSubscriptions");
@@clientLocation(GroupQuotaSubscriptionIds.list, "GroupQuotaSubscriptions");

@@clientLocation(GroupQuotaSubscriptionRequestStatuses.get,
  "GroupQuotaSubscriptionRequests"
);
@@clientLocation(GroupQuotaSubscriptionRequestStatuses.list,
  "GroupQuotaSubscriptionRequests"
);

@@clientLocation(GroupQuotaLimitLists.list, "GroupQuotaLimits");
@@clientLocation(GroupQuotaLimitLists.update, "GroupQuotaLimitsRequest");
@@clientName(GroupQuotaLimitLists.update::parameters.properties,
  "groupQuotaRequest"
);

@@clientLocation(SubmittedResourceRequestStatuses.get,
  "GroupQuotaLimitsRequest"
);

@@clientLocation(SubscriptionQuotaAllocationsLists.list,
  "GroupQuotaSubscriptionAllocation"
);
@@clientLocation(SubscriptionQuotaAllocationsLists.update,
  "GroupQuotaSubscriptionAllocationRequest"
);
@@clientName(SubscriptionQuotaAllocationsLists.update::parameters.properties,
  "allocateQuotaRequest"
);

@@clientLocation(QuotaAllocationRequestStatuses.get,
  "GroupQuotaSubscriptionAllocationRequest"
);
@@clientLocation(QuotaAllocationRequestStatuses.list,
  "GroupQuotaSubscriptionAllocationRequest"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QuotaAllocationRequestStatus.properties);

@@clientLocation(CurrentUsagesBases.get, "Usages");
@@clientLocation(CurrentUsagesBases.list, "Usages");

@@clientLocation(CurrentQuotaLimitBases.get, "Quota");
@@clientLocation(CurrentQuotaLimitBases.createOrUpdate, "Quota");
@@clientName(CurrentQuotaLimitBases.createOrUpdate, "CreateOrUpdate");
@@clientName(CurrentQuotaLimitBases.createOrUpdate::parameters.resource,
  "createQuotaRequest"
);
@@clientLocation(CurrentQuotaLimitBases.update, "Quota");
@@clientName(CurrentQuotaLimitBases.update::parameters.properties,
  "createQuotaRequest"
);
@@clientLocation(CurrentQuotaLimitBases.list, "Quota");

@@clientLocation(QuotaRequestStatus.get, "QuotaRequestStatus");
@@clientLocation(QuotaRequestStatus.list, "QuotaRequestStatus");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QuotaRequestDetails.properties);
