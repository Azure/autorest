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

@@clientName(GroupQuotasEntities.createOrUpdate::parameters.resource,
  "GroupQuotaPutRequestBody"
);
@@clientName(GroupQuotasEntities.update::parameters.properties,
  " GroupQuotasPatchRequestBody"
);

@@clientName(GroupQuotaLimitLists.update::parameters.properties,
  "groupQuotaRequest"
);

@@clientName(SubscriptionQuotaAllocationsLists.update::parameters.properties,
  "allocateQuotaRequest"
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QuotaAllocationRequestStatus.properties);

@@clientName(CurrentQuotaLimitBases.createOrUpdate::parameters.resource,
  "createQuotaRequest"
);
@@clientName(CurrentQuotaLimitBases.update::parameters.properties,
  "createQuotaRequest"
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QuotaRequestDetails.properties);
