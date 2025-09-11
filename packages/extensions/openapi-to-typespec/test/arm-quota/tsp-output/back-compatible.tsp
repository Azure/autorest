import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Quota;

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GroupQuotaDetails.name);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GroupQuotaRequestBase.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GroupQuotaRequestBaseProperties.name);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SubscriptionQuotaDetails.name);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(QuotaAllocationRequestBase.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(QuotaAllocationRequestBaseProperties.name);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GroupQuotaUsagesBase.name);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(QuotaRequestOneResourceSubmitResponse.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(QuotaRequestSubmitResponse202.properties);

@@clientLocation(GroupQuotasEntities.get, "GroupQuotas");
@@clientLocation(GroupQuotasEntities.createOrUpdate, "GroupQuotas");
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
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(QuotaAllocationRequestStatus.properties);

@@clientLocation(CurrentUsagesBases.get, "Usages");
@@clientLocation(CurrentUsagesBases.list, "Usages");

@@clientLocation(CurrentQuotaLimitBases.get, "Quota");
@@clientLocation(CurrentQuotaLimitBases.createOrUpdate, "Quota");
@@clientName(CurrentQuotaLimitBases.createOrUpdate::parameters.resource,
  "createQuotaRequest"
);
@@clientLocation(CurrentQuotaLimitBases.update, "Quota");
@@clientName(CurrentQuotaLimitBases.update::parameters.properties,
  "createQuotaRequest"
);
@@clientLocation(CurrentQuotaLimitBases.list, "Quota");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(QuotaRequestDetails.properties);
