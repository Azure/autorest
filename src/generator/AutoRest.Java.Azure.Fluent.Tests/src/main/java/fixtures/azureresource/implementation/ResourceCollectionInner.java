/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.azureresource.implementation;

import java.util.List;
import java.util.Map;

/**
 * The ResourceCollectionInner model.
 */
public class ResourceCollectionInner {
    /**
     * The productresource property.
     */
    private FlattenedProductInner productresource;

    /**
     * The arrayofresources property.
     */
    private List<FlattenedProductInner> arrayofresources;

    /**
     * The dictionaryofresources property.
     */
    private Map<String, FlattenedProductInner> dictionaryofresources;

    /**
     * Get the productresource value.
     *
     * @return the productresource value
     */
    public FlattenedProductInner productresource() {
        return this.productresource;
    }

    /**
     * Set the productresource value.
     *
     * @param productresource the productresource value to set
     * @return the ResourceCollectionInner object itself.
     */
    public ResourceCollectionInner withProductresource(FlattenedProductInner productresource) {
        this.productresource = productresource;
        return this;
    }

    /**
     * Get the arrayofresources value.
     *
     * @return the arrayofresources value
     */
    public List<FlattenedProductInner> arrayofresources() {
        return this.arrayofresources;
    }

    /**
     * Set the arrayofresources value.
     *
     * @param arrayofresources the arrayofresources value to set
     * @return the ResourceCollectionInner object itself.
     */
    public ResourceCollectionInner withArrayofresources(List<FlattenedProductInner> arrayofresources) {
        this.arrayofresources = arrayofresources;
        return this;
    }

    /**
     * Get the dictionaryofresources value.
     *
     * @return the dictionaryofresources value
     */
    public Map<String, FlattenedProductInner> dictionaryofresources() {
        return this.dictionaryofresources;
    }

    /**
     * Set the dictionaryofresources value.
     *
     * @param dictionaryofresources the dictionaryofresources value to set
     * @return the ResourceCollectionInner object itself.
     */
    public ResourceCollectionInner withDictionaryofresources(Map<String, FlattenedProductInner> dictionaryofresources) {
        this.dictionaryofresources = dictionaryofresources;
        return this;
    }

}
