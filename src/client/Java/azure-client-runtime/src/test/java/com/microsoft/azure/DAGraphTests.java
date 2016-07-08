/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.azure;

import org.junit.Assert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

public class DAGraphTests {
    @Test
    public void testDAGraphGetNext() {
        /**
         *   |-------->[D]------>[B]-----------[A]
         *   |                   ^              ^
         *   |                   |              |
         *  [F]------->[E]-------|              |
         *   |          |                       |
         *   |          |------->[G]----->[C]----
         *   |
         *   |-------->[H]-------------------->[I]
         */
        List<String> expectedOrder = new ArrayList<>();
        expectedOrder.add("A"); expectedOrder.add("I");
        expectedOrder.add("B"); expectedOrder.add("C"); expectedOrder.add("H");
        expectedOrder.add("D"); expectedOrder.add("G");
        expectedOrder.add("E");
        expectedOrder.add("F");

        DAGNode<String> nodeA = new DAGNode<>("A", "dataA");
        DAGNode<String> nodeI = new DAGNode<>("I", "dataI");

        DAGNode<String> nodeB = new DAGNode<>("B", "dataB");
        nodeB.addDependency(nodeA.key());

        DAGNode<String> nodeC = new DAGNode<>("C", "dataC");
        nodeC.addDependency(nodeA.key());

        DAGNode<String> nodeH = new DAGNode<>("H", "dataH");
        nodeH.addDependency(nodeI.key());

        DAGNode<String> nodeG = new DAGNode<>("G", "dataG");
        nodeG.addDependency(nodeC.key());

        DAGNode<String> nodeE = new DAGNode<>("E", "dataE");
        nodeE.addDependency(nodeB.key());
        nodeE.addDependency(nodeG.key());

        DAGNode<String> nodeD = new DAGNode<>("D", "dataD");
        nodeD.addDependency(nodeB.key());


        DAGNode<String> nodeF = new DAGNode<>("F", "dataF");
        nodeF.addDependency(nodeD.key());
        nodeF.addDependency(nodeE.key());
        nodeF.addDependency(nodeH.key());

        DAGraph<String, DAGNode<String>> dag = new DAGraph<>(nodeF);
        dag.addNode(nodeA);
        dag.addNode(nodeB);
        dag.addNode(nodeC);
        dag.addNode(nodeD);
        dag.addNode(nodeE);
        dag.addNode(nodeG);
        dag.addNode(nodeH);
        dag.addNode(nodeI);

        dag.prepare();
        DAGNode<String> nextNode = dag.getNext();
        int i = 0;
        while (nextNode != null) {
            Assert.assertEquals(nextNode.key(), expectedOrder.get(i));
            dag.reportedCompleted(nextNode);
            nextNode = dag.getNext();
            i++;
        }

        System.out.println("done");
    }

    @Test
    public void testGraphMerge() {
        /**
         *   |-------->[D]------>[B]-----------[A]
         *   |                   ^              ^
         *   |                   |              |
         *  [F]------->[E]-------|              |
         *   |          |                       |
         *   |          |------->[G]----->[C]----
         *   |
         *   |-------->[H]-------------------->[I]
         */
        List<String> expectedOrder = new ArrayList<>();
        expectedOrder.add("A"); expectedOrder.add("I");
        expectedOrder.add("B"); expectedOrder.add("C"); expectedOrder.add("H");
        expectedOrder.add("D"); expectedOrder.add("G");
        expectedOrder.add("E");
        expectedOrder.add("F");

        DAGraph<String, DAGNode<String>> graphA = createGraph("A");
        DAGraph<String, DAGNode<String>> graphI = createGraph("I");

        DAGraph<String, DAGNode<String>> graphB = createGraph("B");
        graphA.merge(graphB);

        DAGraph<String, DAGNode<String>> graphC = createGraph("C");
        graphA.merge(graphC);

        DAGraph<String, DAGNode<String>> graphH = createGraph("H");
        graphI.merge(graphH);

        DAGraph<String, DAGNode<String>> graphG = createGraph("G");
        graphC.merge(graphG);

        DAGraph<String, DAGNode<String>> graphE = createGraph("E");
        graphB.merge(graphE);
        graphG.merge(graphE);

        DAGraph<String, DAGNode<String>> graphD = createGraph("D");
        graphB.merge(graphD);

        DAGraph<String, DAGNode<String>> graphF = createGraph("F");
        graphD.merge(graphF);
        graphE.merge(graphF);
        graphH.merge(graphF);

        DAGraph<String, DAGNode<String>> dag = graphF;
        dag.prepare();

        DAGNode<String> nextNode = dag.getNext();
        int i = 0;
        while (nextNode != null) {
            Assert.assertEquals(expectedOrder.get(i), nextNode.key());
            // Process the node
            dag.reportedCompleted(nextNode);
            nextNode = dag.getNext();
            i++;
        }
    }

    private DAGraph<String, DAGNode<String>> createGraph(String resourceName) {
        DAGNode<String> node = new DAGNode<>(resourceName, "data" + resourceName);
        DAGraph<String, DAGNode<String>> graph = new DAGraph<>(node);
        return graph;
    }
}
