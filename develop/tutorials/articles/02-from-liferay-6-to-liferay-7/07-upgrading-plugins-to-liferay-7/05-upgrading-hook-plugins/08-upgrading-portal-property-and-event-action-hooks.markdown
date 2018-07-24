# Upgrading Portal Property and Event Action Hooks [](id=upgrading-portal-property-and-event-action-hooks)

All portal properties in Liferay Portal 6.2 that are also used in @product-ver@
can be overridden. Portal property and portal event action hooks that use these
properties can be upgraded by following these steps:

1.  Adapt your code to @product-ver@'s API using
    [Liferay @ide@'s Code Upgrade Tool](/develop/tutorials/-/knowledge_base/7-1/adapting-to-liferay-7s-api-with-the-code-upgrade-tool). 

2.  Deploy your hook plugin. 

@product@'s Plugin Compatibility Layer converts the plugin WAR to a Web
Application Bundle (WAB) and installs it to Liferay's OSGi Runtime. 

Your custom property values and actions are live.

## Related Topics [](id=related-topics)

[Liferay @ide@](/develop/tutorials/-/knowledge_base/7-1/liferay-ide)

[Resolving a Plugin's Dependencies](/develop/tutorials/-/knowledge_base/7-1/resolving-a-plugins-dependencies)

[Configuring Dependencies](/develop/tutorials/-/knowledge_base/7-1/configuring-dependencies)

[Upgrading the Liferay Maven Build](/develop/tutorials/-/knowledge_base/7-1/upgrading-the-liferay-maven-build)
