/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core;

import static org.junit.Assert.assertEquals;

import com.microsoft.rest.LazyHashMap;
import org.junit.Test;

public class LazyHashMapTests {
    @Test
    public void lazyByDefaultTests() throws Exception {
        // Arrange
        LazyHashMap<String, String> lazyHashMap = new LazyHashMap<String, String>();

        // Act
        boolean initialized = lazyHashMap.isInitialized();

        // Assert
        assertEquals(false, initialized);
    }

    @Test
    public void lazyAddTests() throws Exception {
        // Arrange
        LazyHashMap<String, String> lazyHashMap = new LazyHashMap<String, String>();

        // Act
        lazyHashMap.put("Key", "Value");
        boolean initialized = lazyHashMap.isInitialized();

        // Assert
        assertEquals(true, initialized);
    }
}
