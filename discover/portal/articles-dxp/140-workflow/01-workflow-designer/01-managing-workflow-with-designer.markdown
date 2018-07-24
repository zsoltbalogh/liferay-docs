# Managing Workflows with Kaleo Designer [](id=managing-workflows-with-kaleo-designer)

The Kaleo Designer gives you an intuitive interface for creating workflow
definitions, from the simplest approval processes to the most complex business
processes you can imagine. It features a drag and drop interface, workflow
definition versioning, and a graphical representation of definitions and their
nodes. Without Kaleo Designer, you'd have to hand-craft your entire workflow
definition in XML. With Kaleo Designer, you might never need to look at a single
line of XML. Of course, the Kaleo Designer can also directly manipulate the XML
(using the *Source* tab) if you find it convenient.

## Adding New Workflow Definitions with Kaleo Designer [](id=adding-new-workflow-definitions-with-workflow-designer)

Access Kaleo Designer by going to the Control Panel, then clicking
Configuration &rarr; Workflow. Click the Add icon
(![Add](../../../images-dxp/icon-add.png)).

Give the workflow definition a title and you're ready to start designing your
workflow.

![Figure 1: The Kaleo Designer's graphical interface makes designing workflows intuitive.](../../../images-dxp/workflow-designer-canvas.png)

## Saving and Publishing Workflow Definitions [](id=saving-and-publishing-workflow-definitions)

First, look below the canvas to see the buttons that let you *Save* or
*Publish*. Saving the definition as a draft lets you save your work so it's not
lost (due to a timeout, for example). It won't be published (and assignable to
assets), and it won't be considered a version until the Publish button is
clicked. Each time you save the workflow as a draft, a new revision is added to
the Revision history. To see the Revision history and manage workflow versions,
open the Info sidebar (![Information](../../../images/icon-information.png)) and
click *Revision History*.

![Figure 2: View a list of the current workflows that can be edited in the Kaleo Designer.](../../../images-dxp/workflow-designer-definitions.png)

## Adding Nodes [](id=adding-nodes)

A new workflow is already populated with a start node, an end node, and a
transition between them. To make the workflow the way you want it, add nodes to
the workflow. 

1. *Drag* a node from the *Nodes* palette on the right of the designer and
   *drop* it on the canvas.

2. You'll see it's not connected to other nodes by a transition, so right now it
   can't be used in the workflow. Delete the existing transition and then you
   can make new transitions to direct the *flow* of your workflow (see more
   about transitions below if you're not sure what they're for or how to use
   them in Kaleo Designer).

Alternatively, start by deleting the default transition, then click the edge of
the start node, drag a new transition from the start node to a blank spot on the
canvas, and release it. You're prompted to create a node at that spot, because
you can't have a transition without a starting point and an ending point on
a node.

![Figure 3: You can add a node by creating a transition that ends at a blank spot on your Designer canvas.](../../../images-dxp/workflow-designer-add-node.png)

That's it. Of course, if you drag, say, a *Task* node onto the canvas, it must
be configured.

## Node Settings [](id=node-settings)

Now you know how to add nodes to the workflow definition. By default you have
three things added to your canvas: a start node, a transition, and an end node.
Think of the *EndNode* as the point in the workflow where an asset reaches the
*Approved* status. The *StartNode* is where the asset goes from the *Draft*
status to *Pending*. You might decide to name your nodes to reflect what's
happening in each one. To name a node, double click it, and its *Settings*
appear. Then double click the value of the *Name* property and you can edit the
name. Click *Save* when you're done. 

![Figure 4: You can edit a node's settings.](../../../images-dxp/workflow-designer-node-settings.png)

Of course, there's more you can do besides changing node names. Actions,
Notifications, and Assignments can be used to make your workflow definition
useful and interactive. Keep reading to learn about these features.

<!-- ## Related Topics [](id=related-topics)

[Workflow Forms](/discover/portal/-/knowledge_base/7-0/workflow-forms)

[Using Workflow](/discover/portal/-/knowledge_base/7-0/enabling-workflow)

[Liferay's Workflow Framework](/develop/tutorials/-/knowledge_base/7-0/liferays-workflow-framework)

[Creating Simple Applications](/discover/portal/-/knowledge_base/7-0/creating-simple-applications) -->
