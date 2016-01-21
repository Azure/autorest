/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import java.util.List;

/**
 * Defines a page interface in Azure responses.
 *
 * @param <E> the element type.
 */
public interface Page<E> {
    /**
     * Gets the link to the next page.
     *
     * @return the link.
     */
    String getNextPageLink();

    /**
     * Gets the list of items.
     *
     * @return the list of items.
     */
    List<E> getItems();
}
