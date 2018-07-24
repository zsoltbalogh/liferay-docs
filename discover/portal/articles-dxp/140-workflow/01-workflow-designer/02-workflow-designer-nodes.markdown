# Workflow Definition Nodes [](id=workflow-definition-nodes)

Once you know the basics of [creating workflow definitions](/discover/portal/-/knowledge_base/7-1/managing-workflow-definitions-with-workflow-designer)
with the workflow Designer, you can get into the details. In this tutorial
you'll learn about Actions and Notifications, two important features your
workflow nodes can use. You'll also learn how to affect the processing of the
workflow using Transitions, Forks, Joins, and Conditions.

There are several node types you can use in workflow definitions:

- Task nodes
- Fork and Join nodes
- Condition nodes
- Start nodes
- End nodes
- State nodes

Because they're the most complex node, and often the meat of your workflow
definitions, Task nodes are covered [separately](/discover/portal/-/knowledge_base/7-1/creating-tasks-in-workflow-designer).

Fork, Join, and Condition nodes are discussed, along with Transitions, in a
tutorial on [workflow processing](/discover/portal/-/knowledge_base/7-1/affecting-the-processing-of-workflow-definitions),
since they're used for affecting the processing of the workflow.

This tutorial discusses State nodes, Start nodes, and End nodes, along with
Actions and Notifications.

## Node Actions and Notifications [](id=node-actions-and-notifications)

Any node can have Actions and Notifications.

### Actions [](id=actions)

Actions do additional processing before entering the node, after exiting
a node, or once a task node is assigned. They're configured by accessing
a node's Properties tab, then double clicking *Actions*.

![Figure 1: You can add an Action to a Task node.](../../../images-dxp/workflow-designer-action.png)

The Single Approver workflow contains an Update task with an action written in
Groovy that sets the status of the asset as *denied*, then sets it to *pending*. 

    import com.liferay.portal.kernel.workflow.WorkflowStatusManagerUtil;
    import com.liferay.portal.kernel.workflow.WorkflowConstants;

    WorkflowStatusManagerUtil.updateStatus(WorkflowConstants.getLabelStatus("denied"), workflowContext);
    WorkflowStatusManagerUtil.updateStatus(WorkflowConstants.getLabelStatus("pending"), workflowContext);

Why would the action script first set the status to one thing and then to
another like that? Because for some assets, the *denied* status sends the asset
creator an email notification that the item has been denied.

The end node in your workflow definition has an action configured on it by
default, on entry to the end node:

    import com.liferay.portal.kernel.workflow.WorkflowStatusManagerUtil;
    import com.liferay.portal.kernel.workflow.WorkflowConstants;

    WorkflowStatusManagerUtil.updateStatus(WorkflowConstants.getLabelStatus("approved"), workflowContext);

This is a Groovy script that updates the status to *approved*, since that's
usually the goal of a workflow process.

You can do something simple like the actions above, or you can be as creative as
you'd like.

<!-- Let's add an example of something creative. -Rich -->

It's good to assign a task to a user, and it's even more useful if the user can
get notified of a workflow task.

### Notifications [](id=notifications)

Notifications are sent to tell task assignees that the workflow needs attention
or to update asset creators on the status of the process. They can be sent for
tasks or any other type of node in the workflow. To set up notifications,
double click on *Notifications* in a node's Properties tab and create
a notification.

![Figure 2: You can send a Notification from a Task node.](../../../images-dxp/workflow-designer-notification.png)

You must specify the Notification Type, and you can choose User
Notification, Email, Instant Messenger, or Private Message. You can use
Freemarker or Velocity if you need a template, or you can choose to write a
plain text message.

Here's a basic Freemarker template that reports the name of the asset creator and
the type of asset in the notification:

    ${userName} sent you a ${entryType} for review in the workflow.

You can also choose to link the sending of the notification to entry into the
node (On Entry), when a task is assigned (On Assignment), or when the workflow
processing is leaving a node (On Exit). You can configure multiple notifications
on a node.

Commonly, the assignment and notification settings are teamed up so a user
receives a notification when assigned a task in the workflow. To do this,
choose *Task Assignees* under Recipient Type when configuring the notification.

+$$$

**Note:** The _from name_ and _from address_ of an email notification are
configurable via portal properties. Place these settings into a
`portal-ext.properties` file, in your Liferay Home folder. Then
restart the server:

    workflow.email.from.name=
    workflow.email.from.address=

These can also be set programmatically into the `WorkflowContext`, and the
programmatic setting always takes precedence over the system scoped portal
property.

$$$

## Start and End Nodes [](id=start-and-end-nodes)

Start and end nodes kick off the workflow processing and bring the asset to its
final, approved state. Often you can use the default start and end nodes without
modification. If you want to do some more processing (in the case of a start
node), add an action to the node using the Properties tab as described in the
section on Actions above.

End nodes have a default action that sets the workflow status to Approved using
the Groovy scripting language:

    import com.liferay.portal.kernel.workflow.WorkflowStatusManagerUtil;
    import com.liferay.portal.kernel.workflow.WorkflowConstants;

    WorkflowStatusManagerUtil.updateStatus(WorkflowConstants.getLabelStatus("approved"), workflowContext);

Feel free to add more to the action script if you need to do additional
processing.

By default, there's a transition connecting the start node and end node, but
you'll probably want to delete it, since most workflows don't proceed straight
from the initial state to approved.

## State Nodes [](id=state-nodes)

State nodes can have Notifications and Actions. The default end node added by
workflow Designer is a pre-configured state node that sets the workflow status to
Approved. Perhaps you want to create a node that sets the status to *Expired*.
You could create a state node for it by dragging one onto your workflow Designer
canvas, then configuring an action in it that sets the status to Expired. Here's
what it would look like in Groovy:

    import com.liferay.portal.kernel.workflow.WorkflowStatusManagerUtil;
    import com.liferay.portal.kernel.workflow.WorkflowConstants;

    WorkflowStatusManagerUtil.updateStatus(WorkflowConstants.getLabelStatus("expired"), workflowContext);

Next, you'll learn to do parallel processing using fork and join nodes.

<!-- ## Related Topics [](id=related-topics)

[Workflow Forms](/discover/portal/-/knowledge_base/7-1/workflow-forms)

[Using Workflow](/discover/portal/-/knowledge_base/7-1/enabling-workflow)

[Liferay's Workflow Framework](/develop/tutorials/-/knowledge_base/7-1/liferays-workflow-framework)

[Creating Simple Applications](/discover/portal/-/knowledge_base/7-1/creating-simple-applications) -->
