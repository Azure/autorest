import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.ServiceNetworking;

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(AssociationUpdate.properties);

@@clientLocation(TrafficControllers.get, "TrafficControllerInterface");
@@clientLocation(TrafficControllers.createOrUpdate,
  "TrafficControllerInterface"
);
@@clientLocation(TrafficControllers.update, "TrafficControllerInterface");
@@clientLocation(TrafficControllers.delete, "TrafficControllerInterface");
@@clientLocation(TrafficControllers.listByResourceGroup,
  "TrafficControllerInterface"
);
@@clientLocation(TrafficControllers.listBySubscription,
  "TrafficControllerInterface"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(TrafficController.properties);

@@clientLocation(Associations.get, "AssociationsInterface");
@@clientLocation(Associations.createOrUpdate, "AssociationsInterface");
@@clientLocation(Associations.update, "AssociationsInterface");
@@clientLocation(Associations.delete, "AssociationsInterface");
@@clientLocation(Associations.listByTrafficController, "AssociationsInterface");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(Association.properties);

@@clientLocation(Frontends.get, "FrontendsInterface");
@@clientLocation(Frontends.createOrUpdate, "FrontendsInterface");
@@clientLocation(Frontends.update, "FrontendsInterface");
@@clientLocation(Frontends.delete, "FrontendsInterface");
@@clientLocation(Frontends.listByTrafficController, "FrontendsInterface");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(Frontend.properties);
