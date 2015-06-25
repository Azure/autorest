/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core;

import static org.junit.Assert.assertEquals;

import com.microsoft.rest.LazyArrayList;
import org.junit.Test;

public class LazyArrayListTests {
    @Test
    public void lazyByDefaultTests() throws Exception {
        // Arrange
        LazyArrayList<String> lazyArrayList = new LazyArrayList<String>();

        // Act
        boolean initialized = lazyArrayList.isInitialized();

        // Assert
        assertEquals(false, initialized);
    }

    @Test
    public void lazyAddTests() throws Exception {
        // Arrange
        LazyArrayList<String> lazyArrayList = new LazyArrayList<String>();

        // Act
        lazyArrayList.add("item");
        boolean initialized = lazyArrayList.isInitialized();

        // Assert
        assertEquals(true, initialized);
    }
}
