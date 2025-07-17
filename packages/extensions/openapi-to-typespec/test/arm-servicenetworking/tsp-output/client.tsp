import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.ServiceNetworking;

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

@@clientLocation(Associations.get, "AssociationsInterface");
@@clientLocation(Associations.createOrUpdate, "AssociationsInterface");
@@clientLocation(Associations.update, "AssociationsInterface");
@@clientLocation(Associations.delete, "AssociationsInterface");
@@clientLocation(Associations.listByTrafficController, "AssociationsInterface");

@@clientLocation(Frontends.get, "FrontendsInterface");
@@clientLocation(Frontends.createOrUpdate, "FrontendsInterface");
@@clientLocation(Frontends.update, "FrontendsInterface");
@@clientLocation(Frontends.delete, "FrontendsInterface");
@@clientLocation(Frontends.listByTrafficController, "FrontendsInterface");
