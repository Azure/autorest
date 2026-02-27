// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.Authorization;

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface ClassicAdministratorsOperationGroup {
  /** Gets service administrator, account administrator, and co-administrators for the subscription. */
  @autoRoute
  @get
  @action("classicAdministrators")
  list is ArmProviderActionSync<
    Response = ResourceListResult<ClassicAdministrator>,
    Scope = SubscriptionActionScope
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface GlobalAdministratorOperationGroup {
  /** Elevates access for a Global Administrator. */
  @autoRoute
  elevateAccess is ArmProviderActionSync<Response = void>;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface AzurePermissionsForResourceGroupOperationGroup {
  /** Gets all permissions the caller has for a resource group. */
  @autoRoute
  @get
  @action("permissions")
  list is ArmProviderActionSync<
    Response = PermissionGetResult,
    Scope = Extension.ResourceGroup
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface AzurePermissionsForResourceOperationGroup {
  /** Gets all permissions the caller has for a resource. */
  @autoRoute
  @get
  @action("permissions")
  list is ArmProviderActionSync<
    Response = PermissionGetResult,
    Scope = Extension.ResourceGroup,
    Parameters = {
      /** The namespace of the resource provider. */
      @path
      @segment("providers")
      resourceProviderNamespace: string;

      /** The parent resource identity. */
      @path
      @segment("{resourceProviderNamespace}")
      parentResourcePath: string;

      /** The resource type of the resource. */
      @path
      @segment("{parentResourcePath}")
      resourceType: string;

      /** The name of the resource to get the permissions for. */
      @path
      @segment("{resourceType}")
      resourceName: string;
    }
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface EligibleChildResourcesOperationGroup {
  /** Get the child resources of a resource on which user has eligible access */
  @autoRoute
  @get
  @action("eligibleChildResources")
  get is ArmProviderActionSync<
    Response = ResourceListResult<EligibleChildResource>,
    Scope = ExtensionActionScope,
    Parameters = {
      /** The filter to apply on the operation. Use $filter=resourceType+eq+'Subscription' to filter on only resource of type = 'Subscription'. Use $filter=resourceType+eq+'subscription'+or+resourceType+eq+'resourcegroup' to filter on resource of type = 'Subscription' or 'ResourceGroup' */
      @query("$filter")
      $filter?: string;
    }
  >;
}
