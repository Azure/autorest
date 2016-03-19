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
import java.util.Arrays;
import java.util.List;

public class PagedListTests {
    private PagedList<Integer> list;

    @Before
    public void setupList() {
        list = new PagedList<Integer>(new TestPage(0, 20)) {
            @Override
            public Page<Integer> nextPage(String nextPageLink) throws CloudException, IOException {
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

    @Test
    public void containsTest() {
        Assert.assertTrue(list.contains(0));
        Assert.assertTrue(list.contains(3));
        Assert.assertTrue(list.contains(19));
        Assert.assertFalse(list.contains(20));
    }

    @Test
    public void containsAllTest() {
        List<Integer> subList = new ArrayList<>();
        subList.addAll(Arrays.asList(0, 3, 19));
        Assert.assertTrue(list.containsAll(subList));
        subList.add(20);
        Assert.assertFalse(list.containsAll(subList));
    }

    @Test
    public void subListTest() {
        List<Integer> subList = list.subList(5, 15);
        Assert.assertEquals(10, subList.size());
        Assert.assertTrue(list.containsAll(subList));
        Assert.assertEquals(7, (int) subList.get(2));
    }

    @Test
    public void testIndexOf() {
        Assert.assertEquals(15, list.indexOf(15));
    }

    @Test
    public void testLastIndexOf() {
        Assert.assertEquals(15, list.lastIndexOf(15));
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
