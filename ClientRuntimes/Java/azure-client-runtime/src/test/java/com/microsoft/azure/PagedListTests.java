/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class PagedListTests {
    private PagedList<Integer> list;

    @Before
    public void setupList() {
        list = new PagedList<Integer>(new TestPage(0, 20)) {
            @Override
            public Page<Integer> loadPage(String nextPageLink) throws CloudException, IOException {
                int pageNum = Integer.parseInt(nextPageLink);
                return new TestPage(pageNum, 20);
            }
        };
    }

    @Test
    public void sizeTest() {
        Assert.assertEquals(20, list.size());
    }

    @Test
    public void getTest() {
        Assert.assertEquals(15, (int) list.get(15));
    }

    @Test
    public void iterateTest() {
        int j = 0;
        for (int i : list) {
            Assert.assertEquals(i, j++);
        }
    }

    @Test
    public void removeTest() {
        Integer i = list.get(10);
        list.remove(10);
        Assert.assertEquals(19, list.size());
        Assert.assertEquals(19, (int) list.get(18));
    }

    @Test
    public void addTest() {
        Integer i = list.get(10);
        list.add(100);
        Assert.assertEquals(21, list.size());
        Assert.assertEquals(100, (int) list.get(11));
        Assert.assertEquals(19, (int) list.get(20));
    }

    public static class TestPage implements Page<Integer> {
        private int page;
        private int max;

        public TestPage(int page, int max) {
            this.page = page;
            this.max = max;
        }

        @Override
        public String getNextPageLink() {
            if (page + 1 == max) {
                return null;
            }
            return Integer.toString(page + 1);
        }

        @Override
        public List<Integer> getItems() {
            List<Integer> items = new ArrayList<>();
            items.add(page);
            return items;
        }
    }
}
