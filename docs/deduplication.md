# Model Deduplication and Path Deduplication

## Models

### **Property's 'description' modified**

### Conflict:

From Compute 2018-04-01 -> 2018-06-01

```json
"ManagedDiskParameters": {
      "properties": {
        "storageAccountType": {
          "$ref": "#/definitions/StorageAccountType",
 +->      "description": "Specifies ... NOTE: UltraSSD_LRS can only be used with data disks...",
 -->      "description": "Specifies ... Possible values are: Standard_LRS, ..."
        }
      },
      "allOf": [
        {
          "$ref": "#/definitions/SubResource"
        }
      ],
      "description": "The parameters of a managed disk."
    }
```

### Resolution:

Description is generally used for documentation purposes. Discard the old model and keep the latest:

```json
"ManagedDiskParameters": {
      "properties": {
        "storageAccountType": {
          "$ref": "#/definitions/StorageAccountType",
          "description": "Specifies ... NOTE: UltraSSD_LRS can only be used with data disks...",
        }
      },
      "allOf": [
        {
          "$ref": "#/definitions/SubResource"
        }
      ],
      "description": "The parameters of a managed disk."
    }
```

### **Properties added from old -> new -> ... -> newest**

### Conflict:

From Compute 2015-06-15 -> 2016-03-30 -> 2017-03-30

```json
"VirtualMachine": {
      "properties": {
        "plan": {
          "$ref": "#/definitions/Plan",
          "description": "Specifies information about the marketplace image used to create the virtual machine..."
        },
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/VirtualMachineProperties"
        },
        "resources": {
          "readOnly": true,
          "type": "array",
          "items": {
            "$ref": "#/definitions/VirtualMachineExtension"
          },
          "description": "The virtual machine child extension resources."
        }
      },
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ],
      "description": "Describes a Virtual Machine."
    }


"VirtualMachine": {
      "properties": {
        "plan": {
          "$ref": "#/definitions/Plan",
          "description": "Specifies information about the marketplace image used to create the virtual machine..."
        },
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/VirtualMachineProperties"
        },
        "resources": {
          "readOnly": true,
          "type": "array",
          "items": {
            "$ref": "#/definitions/VirtualMachineExtension"
          },
          "description": "The virtual machine child extension resources."
        },
+->     "identity": {
+->       "$ref": "#/definitions/VirtualMachineIdentity",
+->       "description": "The identity of the virtual machine, if configured."
+->     }
      },
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ],
      "description": "Describes a Virtual Machine."
    }

"VirtualMachine": {
      "properties": {
        "plan": {
          "$ref": "#/definitions/Plan",
          "description": "Specifies information about the marketplace image used to create the virtual machine..."
        },
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/VirtualMachineProperties"
        },
        "resources": {
          "readOnly": true,
          "type": "array",
          "items": {
            "$ref": "#/definitions/VirtualMachineExtension"
          },
          "description": "The virtual machine child extension resources."
        },
+->       "identity": {
+->       "$ref": "#/definitions/VirtualMachineIdentity",
+->       "description": "The identity of the virtual machine, if configured."
+->     },
++->    "zones": {
++->       "type": "array",
++->       "items": {
++->       "type": "string"
++->      },
          "description": "The virtual machine zones."
        }
      },
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ],
      "description": "Describes a Virtual Machine."
    }
```

### Resolution:

Use composition. Make the oldest be the base-model and make the new models extend from there in a chain of extended models.

Naming: TBD

```json
"VirtualMachine": {
      "properties": {
        "plan": {
          "$ref": "#/definitions/Plan",
          "description": "Specifies information about the marketplace image used to create the virtual machine..."
        },
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/VirtualMachineProperties"
        },
        "resources": {
          "readOnly": true,
          "type": "array",
          "items": {
            "$ref": "#/definitions/VirtualMachineExtension"
          },
          "description": "The virtual machine child extension resources."
        }
      },
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ],
      "description": "Describes a Virtual Machine."
    }

"VirtualMachine1": {
    "properties": {
        "identity": {
          "$ref": "#/definitions/VirtualMachineIdentity",
          "description": "The identity of the virtual machine, if configured."
        }
      },
      "allOf": [
        {
          "$ref": "#/definitions/VirtualMachine"
        }
      ]
    }

"VirtualMachine2": {
    "properties": {
        "zones": {
            "type": "array",
            "items": {
            "type": "string"
            }
        },
    },
      "allOf": [
        {
          "$ref": "#/definitions/ExtendedVirtualMachine1"
        }
      ]
    }

```

### **'required' field added**

### Conflict:

From Compute 2015-06-15 -> 2016-03-30

```json
"ListUsagesResult": {
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/Usage"
          },
          "description": "The list of compute resource usages."
        },
        "nextLink": {
          "type": "string",
          "description": "The URI to fetch the next page of compute resource usage information. Call ListNext() with this to fetch the next page of compute resource usage information."
        }
      },
+->  "required": [
+->     "value"
+->   ],
      "description": "The List Usages operation response."
    }
```

### Resolution:

Keep latest.

```json

"ListUsagesResult": {
      "properties": {
        "value": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/Usage"
          },
          "description": "The list of compute resource usages."
        },
        "nextLink": {
          "type": "string",
          "description": "The URI to fetch the next page of compute resource usage information. Call ListNext() with this to fetch the next page of compute resource usage information."
        }
      },
     "required": [
        "value"
      ],
      "description": "The List Usages operation response."
    }

```

### **'required' field removed**

From Compute 2015-06-15 -> 2016-03-30

```json
"DiskEncryptionSettings": {
      "properties": {
        "diskEncryptionKey": {
          "$ref": "#/definitions/KeyVaultSecretReference",
          "description": "Specifies the location of the disk encryption key, which is a Key Vault Secret."
        },
        "keyEncryptionKey": {
          "$ref": "#/definitions/KeyVaultKeyReference",
          "description": "Specifies the location of the key encryption key in Key Vault."
        },
        "enabled": {
          "type": "boolean",
          "description": "Specifies whether disk encryption should be enabled on the virtual machine."
        }
      },
-->   "required": [
-->      "diskEncryptionKey"
-->   ],
      "description": "Describes a Encryption Settings for a Disk"
    }
```

### Resolution:

Keep latest.

```json
"DiskEncryptionSettings": {
      "properties": {
        "diskEncryptionKey": {
          "$ref": "#/definitions/KeyVaultSecretReference",
          "description": "Specifies the location of the disk encryption key, which is a Key Vault Secret."
        },
        "keyEncryptionKey": {
          "$ref": "#/definitions/KeyVaultKeyReference",
          "description": "Specifies the location of the key encryption key in Key Vault."
        },
        "enabled": {
          "type": "boolean",
          "description": "Specifies whether disk encryption should be enabled on the virtual machine."
        }
      },
      "description": "Describes a Encryption Settings for a Disk"
    }
```

### **Property's 'readOnly' field added**

### Conflict:

```json
"VirtualMachineScaleSetProperties": {
      "properties": {
        "upgradePolicy": {
          "$ref": "#/definitions/UpgradePolicy",
          "description": "The upgrade policy."
        },
        "virtualMachineProfile": {
          "$ref": "#/definitions/VirtualMachineScaleSetVMProfile",
          "description": "The virtual machine profile."
        },
        "provisioningState": {
+->       "readOnly": true,
          "type": "string",
          "description": "The provisioning state, which only appears in the response."
        },
        "overProvision": {
          "type": "boolean",
          "description": "Specifies whether the Virtual Machine Scale Set should be overprovisioned."
        }
      },
      "description": "Describes the properties of a Virtual Machine Scale Set."
    }
```

### Resolution:

Keep latest.

```json
"VirtualMachineScaleSetProperties": {
      "properties": {
        "upgradePolicy": {
          "$ref": "#/definitions/UpgradePolicy",
          "description": "The upgrade policy."
        },
        "virtualMachineProfile": {
          "$ref": "#/definitions/VirtualMachineScaleSetVMProfile",
          "description": "The virtual machine profile."
        },
        "provisioningState": {
          "readOnly": true,
          "type": "string",
          "description": "The provisioning state, which only appears in the response."
        },
        "overProvision": {
          "type": "boolean",
          "description": "Specifies whether the Virtual Machine Scale Set should be overprovisioned."
        }
      },
      "description": "Describes the properties of a Virtual Machine Scale Set."
    }
```

### **'allOf' field added**

From Compute 2016-03-30 -> 2017-03-03

```json
"ImageReference": {
      "properties": {
        "publisher": {
          "type": "string",
          "description": "The image publisher."
        },
        "offer": {
          "type": "string",
          "description": "Specifies the offer of the platform image or marketplace image used to create the virtual machine."
        },
        "sku": {
          "type": "string",
          "description": "The image SKU."
        },
        "version": {
          "type": "string",
          "description": "Specifies the version of the platform image or marketplace image used to create the virtual machine. The allowed formats are Major.Minor.Build or 'latest'. Major, Minor, and Build are decimal numbers. Specify 'latest' to use the latest version of an image available at deploy time. Even if you use 'latest', the VM image will not automatically update after deploy time even if a new version becomes available."
        }
      },
+->   "allOf": [
+->     {
+->       "$ref": "#/definitions/SubResource"
+->     }
+->   ],
      "description": "Specifies information about the image to use. You can specify information about platform images, marketplace images, or virtual machine images. This element is required when you want to use a platform image, marketplace image, or virtual machine image, but is not used in other creation operations."
    },

+->   "SubResource": {
+->      "properties": {
+->        "id": {
+->         "type": "string",
+->          "description": "Resource Id"
+->        }
+->      },
+->      "x-ms-azure-resource": true
+->    }
```

Resolution:

The model after allOf is resolved is equivalent to a model with additional properties and one extra field. So we can use composition:

```json
"ImageReference": {
      "properties": {
        "publisher": {
          "type": "string",
          "description": "The image publisher."
        },
        "offer": {
          "type": "string",
          "description": "Specifies the offer of the platform image or marketplace image used to create the virtual machine."
        },
        "sku": {
          "type": "string",
          "description": "The image SKU."
        },
        "version": {
          "type": "string",
          "description": "Specifies the version of the platform image or marketplace image used to create the virtual machine. The allowed formats are Major.Minor.Build or 'latest'. Major, Minor, and Build are decimal numbers. Specify 'latest' to use the latest version of an image available at deploy time. Even if you use 'latest', the VM image will not automatically update after deploy time even if a new version becomes available."
        }
      },
      "description": "Specifies information about the image to use. You can specify information about platform images, marketplace images, or virtual machine images. This element is required when you want to use a platform image, marketplace image, or virtual machine image, but is not used in other creation operations."
    },
"ExtendedImageReference": {
    "allOf": [
     {
       "$ref": "#/definitions/SubResource",
       "$ref": "#/definitions/ImageReference"
     }
   ]
}

```

### **'required' values removed**

From Compute 2016-03-30 -> 2017-03-30

```json
"OSDisk": {
      "properties": {
        "osType": {
          "type": "string",
          "description": "This property allows you to specify the type of the OS that is included in the disk if creating a VM from user-image or a specialized VHD. <br><br> Possible values are: <br><br> **Windows** <br><br> **Linux**",
          "enum": [
            "Windows",
            "Linux"
          ],
          "x-ms-enum": {
            "name": "OperatingSystemTypes",
            "modelAsString": false
          }
        },
        ...
        "diskSizeGB": {
          "type": "integer",
          "format": "int32",
          "description": "Specifies the size of an empty data disk in gigabytes. This element can be used to overwrite the size of the disk in a virtual machine image. <br><br> This value cannot be larger than 1023 GB"
        }
        ...
      },
      "required": [
-->     "name",
-->     "vhd",
        "createOption"
      ],
      "description": "Specifies information about the operating system disk used by the virtual machine. <br><br> For more information about disks, see [About disks and VHDs for Azure virtual machines](https://docs.microsoft.com/azure/virtual-machines/virtual-machines-windows-about-disks-vhds?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json)."
    }
```

### Resolution:

Keep latest.

```json
"OSDisk": {
      "properties": {
        "osType": {
          "type": "string",
          "description": "This property allows you to specify the type of the OS that is included in the disk if creating a VM from user-image or a specialized VHD. <br><br> Possible values are: <br><br> **Windows** <br><br> **Linux**",
          "enum": [
            "Windows",
            "Linux"
          ],
          "x-ms-enum": {
            "name": "OperatingSystemTypes",
            "modelAsString": false
          }
        },
        ...
        "diskSizeGB": {
          "type": "integer",
          "format": "int32",
          "description": "Specifies the size of an empty data disk in gigabytes. This element can be used to overwrite the size of the disk in a virtual machine image. <br><br> This value cannot be larger than 1023 GB"
        }
        ...
      },
      "required": [
        "createOption"
      ],
      "description": "Specifies information about the operating system disk used by the virtual machine. <br><br> For more information about disks, see [About disks and VHDs for Azure virtual machines](https://docs.microsoft.com/azure/virtual-machines/virtual-machines-windows-about-disks-vhds?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json)."
    }
```

### **Property's 'enum' values added**

From Compute 2016-03-30 -> 2017-03-30

```json

"HardwareProfile": {
      "properties": {
        "vmSize": {
          "type": "string",
          "description": "Specifies the size of the virtual ...",
          "enum": [
            "Basic_A0",
            "Basic_A1",
            "Basic_A2",
            "Basic_A3",
            "Basic_A4",
            ...
            "Standard_D14_v2",
+->         "Standard_D15_v2",
            "Standard_DS1",
            ...
            "Standard_DS14",
+->         "Standard_DS1_v2",
+->         "Standard_DS2_v2",
+->         "Standard_DS3_v2",
+->         "Standard_DS4_v2",
+->         "Standard_DS5_v2",
+->         "Standard_DS11_v2",
+->         "Standard_DS12_v2",
+->         "Standard_DS13_v2",
+->         "Standard_DS14_v2",
+->         "Standard_DS15_v2",
            "Standard_G1",
            ...
            "Standard_GS5"
          ],
          "x-ms-enum": {
            "name": "VirtualMachineSizeTypes",
            "modelAsString": true
          }
        }
      },
      "description": "Specifies the hardware settings for the virtual machine."
    }
```

### Resolution:

Keep the latest.

```json

"HardwareProfile": {
      "properties": {
        "vmSize": {
          "type": "string",
          "description": "Specifies the size of the virtual ...",
          "enum": [
            "Basic_A0",
            "Basic_A1",
            "Basic_A2",
            "Basic_A3",
            "Basic_A4",
            ...
            "Standard_D14_v2",
            "Standard_D15_v2",
            "Standard_DS1",
            ...
            "Standard_DS14",
            "Standard_DS1_v2",
            "Standard_DS2_v2",
            "Standard_DS3_v2",
            "Standard_DS4_v2",
            "Standard_DS5_v2",
            "Standard_DS11_v2",
            "Standard_DS12_v2",
            "Standard_DS13_v2",
            "Standard_DS14_v2",
            "Standard_DS15_v2",
            "Standard_G1",
            ...
            "Standard_GS5"
          ],
          "x-ms-enum": {
            "name": "VirtualMachineSizeTypes",
            "modelAsString": true
          }
        }
      },
      "description": "Specifies the hardware settings for the virtual machine."
    }
```

### **'allOf' reference modified**

From Compute 2016-03-30 -> 2017-03-30

```json
"VirtualMachineScaleSetExtension": {
      "properties": {
        "name": {
          "type": "string",
          "description": "The name of the extension."
        },
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/VirtualMachineScaleSetExtensionProperties"
        }
      },
      "allOf": [
        {
+->          "$ref": "#/definitions/SubResourceReadOnly",
-->          "$ref": "#/definitions/SubResource"
        }
      ],
      "description": "Describes a Virtual Machine Scale Set Extension."
    },
```

### Resolution:

If after resolution they refer to similar models, then just take the latest, and if they refer to non-similar models, keep both:

```json
"VirtualMachineScaleSetExtension___OLD___": {
      "properties": {
        "name": {
          "type": "string",
          "description": "The name of the extension."
        },
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/VirtualMachineScaleSetExtensionProperties"
        }
      },
      "allOf": [
        {
             "$ref": "#/definitions/SubResource"
        }
      ],
      "description": "Describes a Virtual Machine Scale Set Extension."
    },

"VirtualMachineScaleSetExtension___NEW___": {
      "properties": {
        "name": {
          "type": "string",
          "description": "The name of the extension."
        },
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/VirtualMachineScaleSetExtensionProperties"
        }
      },
      "allOf": [
        {
             "$ref": "#/definitions/SubResourceReadOnly",
        }
      ],
      "description": "Describes a Virtual Machine Scale Set Extension."
    },

```

### **'allOf' reference removed**

From /2017-12-01/Compute.json -> /2018-04-01/Compute.json

### Conflict:

```json
"LogAnalyticsOperationResult": {
      "properties": {
        "properties": {
          "readOnly": true,
          "$ref": "#/definitions/LogAnalyticsOutput",
          "description": "LogAnalyticsOutput"
        }
      },
-->     "allOf": [
-->     {
-->        "$ref": "#/definitions/OperationStatusResponse"
-->     }
-->   ],
      "description": "LogAnalytics operation status response"
    }
```

### Resolution:

Keep both.

### **'modelAsString' changed**

### Conflict:

From Compute 2017-03-30 -> 2017-12-01

```json
"StorageAccountType": {
      "type": "string",
      "description": "Specifies the storage account type for the managed disk. Possible values are: Standard_LRS or Premium_LRS.",
      "enum": [
        "Standard_LRS",
        "Premium_LRS"
      ],
      "x-ms-enum": {
        "name": "StorageAccountTypes",
+->     "modelAsString": true,
-->     "modelAsString": false,
      }
    }
```

### Resolution:

Keep the latest.

### \*\*'properties' of 'properties' of model changed

### Conflict:

From Compute/disk.json 2018-04-01 -> 2018-06-01

```json
"Snapshot": {
      "properties": {
        "managedBy": {
          "readOnly": true,
          "type": "string",
          "description": "Unused. Always Null."
        },
        "sku": {
          "$ref": "#/definitions/SnapshotSku"
        },
        "properties": {
          "x-ms-client-flatten": true,
+->       "$ref": "#/definitions/SnapshotProperties",
-->       "$ref": "#/definitions/DiskProperties"
        }
      },
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ],
      "description": "Snapshot resource."
    }
```

### Resolution

If the references refer to a similar schemas after the reference is resolved, then they are duplicates, and the latest is kept. Otherwise, keep both.

```json
"Snapshot___OLD___": {
      "properties": {
        "managedBy": {
          "readOnly": true,
          "type": "string",
          "description": "Unused. Always Null."
        },
        "sku": {
          "$ref": "#/definitions/SnapshotSku"
        },
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/DiskProperties"
        }
      },
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ],
      "description": "Snapshot resource."
    }


"Snapshot___NEW___": {
      "properties": {
        "managedBy": {
          "readOnly": true,
          "type": "string",
          "description": "Unused. Always Null."
        },
        "sku": {
          "$ref": "#/definitions/SnapshotSku"
        },
        "properties": {
          "x-ms-client-flatten": true,
          "$ref": "#/definitions/SnapshotProperties"
        }
      },
      "allOf": [
        {
          "$ref": "#/definitions/Resource"
        }
      ],
      "description": "Snapshot resource."
    }

```

### **property of 'properties' of 'properties' removed**

From Web/AppServiceEnviroments.json 2016-09-01 to 2018-02-01

### Conflict:

```json
"MetricDefinition": {
      "description": "Metadata for a metric.",
      "type": "object",
      "allOf": [
        {
          "$ref": "./CommonDefinitions.json#/definitions/ProxyOnlyResource"
        }
      ],
      "properties": {
        "properties": {
          "description": "MetricDefinition resource specific properties",
          "properties": {
-->         "name": {
-->           "description": "Name of the metric.",
-->           "type": "string",
-->           "readOnly": true
-->         },
            "unit": {
              "description": "Unit of the metric.",
              "type": "string",
              "readOnly": true
            },
            "primaryAggregationType": {
              "description": "Primary aggregation type.",
              "type": "string",
              "readOnly": true
            },
            "metricAvailabilities": {
              "description": "List of time grains supported for the metric together with retention period.",
              "type": "array",
              "items": {
                "$ref": "#/definitions/MetricAvailabilily"
              },
              "readOnly": true
            },
            "displayName": {
              "description": "Friendly name shown in the UI.",
              "type": "string",
              "readOnly": true
            }
          },
          "x-ms-client-flatten": true
        }
      }
    }
```

### Resolution:

Keep Both.

### **changed property from 'renderingType' to 'type'**

From network/Diagnotics.json 2016-09-01 to 2018-02-01

```json
"Rendering": {
      "description": "Instructions for rendering the data",
      "type": "object",
      "properties": {
+->       "type": {
-->       "renderingType":{
          "description": "Rendering Type",
          "enum": [
            "NoGraph",
            "Table",
            "TimeSeries",
            "TimeSeriesPerInstance"
          ],
          "type": "string",
          "x-ms-enum": {
            "name": "RenderingType",
            "modelAsString": false
          }
        },
        "title": {
          "description": "Title of data",
          "type": "string"
        },
        "description": {
          "description": "Description of the data that will help it be interpreted",
          "type": "string"
        }
      }
    }
```

### Resolution:

Keep Both.

### **x-ms-\* extension added to 'properties' of 'properties' of a model**

From DNS 2015-05-4-preview -> 2018-03-01-preview

### Conflict:

```json
"Zone": {
      "properties": {
        "etag": {
          "type": "string",
          "description": "The etag of the zone."
        },
        "properties": {
+->       "x-ms-client-flatten": true,
          "$ref": "#/definitions/ZoneProperties",
          "description": "The properties of the zone."
        }
      },
      "allOf": [
        {
          "$ref": "../../../../../common-types/resource-management/v1/types.json#/definitions/TrackedResource"
        }
      ],
      "description": "Describes a DNS zone."
    }
```

### Resolution:

Keep both.

```json
"Zone": {
      "properties": {
        "etag": {
          "type": "string",
          "description": "The etag of the zone."
        },
        "properties": {
        "x-ms-client-flatten": true,
          "$ref": "#/definitions/ZoneProperties",
          "description": "The properties of the zone."
        }
      },
      "allOf": [
        {
          "$ref": "../../../../../common-types/resource-management/v1/types.json#/definitions/TrackedResource"
        }
      ],
      "description": "Describes a DNS zone."
    }
```

### \*\*x-ms extension added to properties of model

### Conflict:

```json
"RecordSetProperties": {
      "properties": {
        ...
        "NSRecords": {
          "type": "array",
+->       "x-ms-client-name": "NsRecords",
          "items": {
            "$ref": "#/definitions/NsRecord"
          },
          "description": "The list of NS records in the record set."
        },
        "PTRRecords": {
          "type": "array",
+->       "x-ms-client-name": "PtrRecords",
          "items": {
            "$ref": "#/definitions/PtrRecord"
          },
          "description": "The list of PTR records in the record set."
        },
        "SRVRecords": {
          "type": "array",
+->       "x-ms-client-name": "SrvRecords",
          "items": {
            "$ref": "#/definitions/SrvRecord"
          },
          "description": "The list of SRV records in the record set."
        }
        ...
      },
      "description": "Represents the properties of the records in the record set."
    }
```

### Resolution:

Keep both.

```json
"RecordSetProperties": {
      "properties": {
        ...
        "NSRecords": {
          "type": "array",
          "x-ms-client-name": "NsRecords",
          "items": {
            "$ref": "#/definitions/NsRecord"
          },
          "description": "The list of NS records in the record set."
        },
        "PTRRecords": {
          "type": "array",
          "x-ms-client-name": "PtrRecords",
          "items": {
            "$ref": "#/definitions/PtrRecord"
          },
          "description": "The list of PTR records in the record set."
        },
        "SRVRecords": {
          "type": "array",
          "x-ms-client-name": "SrvRecords",
          "items": {
            "$ref": "#/definitions/SrvRecord"
          },
          "description": "The list of SRV records in the record set."
        }
        ...
      },
      "description": "Represents the properties of the records in the record set."
    }
```

### **change in capitalization of property names**

From iothub 2017-07-01 to 2018-01-22

### Conflict:

```json
"OperationInputs": {
      "description": "Input values.",
      "type": "object",
      "properties": {
-->     "Name": {
+->     "name": {
          "description": "The name of the IoT hub to check.",
          "type": "string"
        }
      },
      "required": [
        "name"
      ]
    }
```

### Resolution:

Keep both.

```json
"OperationInputs": {
      "description": "Input values.",
      "type": "object",
      "properties": {
        "name": {
          "description": "The name of the IoT hub to check.",
          "type": "string"
        }
      },
      "required": [
        "name"
      ]
    }
```

## Paths

### **x-ms-examples added**

### Conflict:

Compute 2016-03-30 -> 2017-03-30

```json
"/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}": {
      "put": {
        "tags": [
          "AvailabilitySets"
        ],
        "operationId": "AvailabilitySets_CreateOrUpdate",
        "description": "Create or update an availability set.",
        "parameters": [
          ...
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/AvailabilitySet"
            }
          }
        },
+->     "x-ms-examples": {
+->       "Create an availability set.": {
+->         "$ref": "./examples/CreateAnAvailabilitySet.json"
          }
        }
      }
      ...
    }
```

### Resolution:

Keep the latest.

```json
"/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}": {
      "put": {
        "tags": [
          "AvailabilitySets"
        ],
        "operationId": "AvailabilitySets_CreateOrUpdate",
        "description": "Create or update an availability set.",
        "parameters": [
          ...
        ],
        "responses": {
          "200": {
            "description": "OK",
            "schema": {
              "$ref": "#/definitions/AvailabilitySet"
            }
          }
        },
        "x-ms-examples": {
          "Create an availability set.": {
            "$ref": "./examples/CreateAnAvailabilitySet.json"
          }
        }
      }
      ...
    }
```
