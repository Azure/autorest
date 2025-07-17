import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.ServiceNetworking;

@@clientLocation(TrafficControllers.get, "TrafficControllerInterface");
@@clientLocation(TrafficControllers.createOrUpdate,
  "TrafficControllerInterface"
);
@@clientName(TrafficControllers.createOrUpdate, "CreateOrUpdate");
@@clientLocation(TrafficControllers.update, "TrafficControllerInterface");
@@clientLocation(TrafficControllers.delete, "TrafficControllerInterface");
@@clientLocation(TrafficControllers.listByResourceGroup,
  "TrafficControllerInterface"
);
@@clientName(TrafficControllers.listByResourceGroup, "ListByResourceGroup");
@@clientLocation(TrafficControllers.listBySubscription,
  "TrafficControllerInterface"
);
@@clientName(TrafficControllers.listBySubscription, "ListBySubscription");

@@clientLocation(Associations.get, "AssociationsInterface");
@@clientLocation(Associations.createOrUpdate, "AssociationsInterface");
@@clientName(Associations.createOrUpdate, "CreateOrUpdate");
@@clientLocation(Associations.update, "AssociationsInterface");
@@clientLocation(Associations.delete, "AssociationsInterface");
@@clientLocation(Associations.listByTrafficController, "AssociationsInterface");
@@clientName(Associations.listByTrafficController, "ListByTrafficController");

@@clientLocation(Frontends.get, "FrontendsInterface");
@@clientLocation(Frontends.createOrUpdate, "FrontendsInterface");
@@clientName(Frontends.createOrUpdate, "CreateOrUpdate");
@@clientLocation(Frontends.update, "FrontendsInterface");
@@clientLocation(Frontends.delete, "FrontendsInterface");
@@clientLocation(Frontends.listByTrafficController, "FrontendsInterface");
@@clientName(Frontends.listByTrafficController, "ListByTrafficController");
