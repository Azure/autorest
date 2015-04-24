/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest;

/**
 * Represents an object Collection that supports on-demand initialization.
 */
public interface LazyCollection {
    /**
     * If the current instance is initialized.
     *
     * @return <code>true</code> if collection has been initialized
     */
    boolean isInitialized();
}
