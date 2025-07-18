import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.GuestConfiguration;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Operation.properties);

@@clientName(GuestConfigurationAssignments.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(GuestConfigurationAssignments.guestConfigurationAssignmentReportsList,
  "GuestConfigurationAssignmentReports"
);
@@clientName(GuestConfigurationAssignments.guestConfigurationAssignmentReportsList,
  "List"
);
@@clientLocation(GuestConfigurationAssignments.guestConfigurationAssignmentReportsGet,
  "GuestConfigurationAssignmentReports"
);
@@clientName(GuestConfigurationAssignments.guestConfigurationAssignmentReportsGet,
  "Get"
);
@@clientName(GuestConfigurationHCRPAssignments.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(GuestConfigurationHCRPAssignments.guestConfigurationHCRPAssignmentReportsList,
  "GuestConfigurationHCRPAssignmentReports"
);
@@clientName(GuestConfigurationHCRPAssignments.guestConfigurationHCRPAssignmentReportsList,
  "List"
);
@@clientLocation(GuestConfigurationHCRPAssignments.guestConfigurationHCRPAssignmentReportsGet,
  "GuestConfigurationHCRPAssignmentReports"
);
@@clientName(GuestConfigurationHCRPAssignments.guestConfigurationHCRPAssignmentReportsGet,
  "Get"
);
@@clientName(GuestConfigurationAssignmentsVMSS.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(GuestConfigurationAssignmentsVMSS.guestConfigurationAssignmentReportsVMSSList,
  "GuestConfigurationAssignmentReportsVMSS"
);
@@clientName(GuestConfigurationAssignmentsVMSS.guestConfigurationAssignmentReportsVMSSList,
  "List"
);
@@clientLocation(GuestConfigurationAssignmentsVMSS.guestConfigurationAssignmentReportsVMSSGet,
  "GuestConfigurationAssignmentReportsVMSS"
);
@@clientName(GuestConfigurationAssignmentsVMSS.guestConfigurationAssignmentReportsVMSSGet,
  "Get"
);
@@clientName(GuestConfigurationConnectedVMwarevSphereAssignments.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(GuestConfigurationConnectedVMwarevSphereAssignments.guestConfigurationConnectedVMwarevSphereAssignmentsReportsList,
  "GuestConfigurationConnectedVMwarevSphereAssignmentsReports"
);
@@clientName(GuestConfigurationConnectedVMwarevSphereAssignments.guestConfigurationConnectedVMwarevSphereAssignmentsReportsList,
  "List"
);
@@clientLocation(GuestConfigurationConnectedVMwarevSphereAssignments.guestConfigurationConnectedVMwarevSphereAssignmentsReportsGet,
  "GuestConfigurationConnectedVMwarevSphereAssignmentsReports"
);
@@clientName(GuestConfigurationConnectedVMwarevSphereAssignments.guestConfigurationConnectedVMwarevSphereAssignmentsReportsGet,
  "Get"
);

@@clientLocation(GuestConfigurationAssignmentsOperationGroup.rGList,
  "GuestConfigurationAssignments"
);
