#How to install @product@ in a clustered environment
## Description
Many enterprise environments utilize clustering for both scalability and availability. This page provides specific instructions for installing a basic configuration of @product@ in a pre-existing clustered environment.

A common misconception is that by configuring Liferay, a high-availability / clustered environment is created automatically. However, by definition, a clustered environment includes load balancers, clustered application servers, and databases. Once the clustered environment is set up, Liferay can then be installed into that environment.

Users can also determine whether the cluster uses multicast or unicast settings. By default, @product@ uses multicast clustering. In the portal-ext.properties, users can change the multicast port numbers so that they do not conflict with other instances running. If the user decides to use unicast cluster, users have several options available that are supported by Liferay: TCP, Amazon S3, File Ping, and JDBC Ping.

To set up a fully clustered environment:

* Cluster Activation Keys need to be deployed on each node.
* All nodes are pointing to the same Liferay database or database cluster.
* Documents and Media repositories is accessible to all nodes of the cluster.
* Search indexes are configured to use a separate search server (Elasticsearch / Solr).
* The cache is distributed.
* Hot deploy folders are configured for each node if not using server farms.

## Cluster Activation Keys

Each node in the cluster needs to have a cluster activation key deployed in order for @product@ to run properly.

Additionally, Cluster Link must be enabled for cluster activation keys to work. To do this, set the following in portal-ext.properties:

`cluster.link.enabled=true`

### Database

Make sure all nodes are pointed to the same database. Configure the JDBC from portal-ext.properties or directly on the application server.

+$$$

**Checkpoint**: please verify the steps above by following these steps:
* Start both application servers / containers (Nodes 1 and 2) **sequentially**. The reason is so that the Quartz Scheduler can elect a master node!
* Log in and add a portlet (e.g. Hello Velocity) to Node 1.
* On Node 2, refresh the page.

The portlet should show up on Node 2. Repeat with the nodes reversed to test the other node.

$$$

### Document and Media Library Sharing

Please note that the following properties are specifically for use with AdvancedFileSystemStore.

 
Set the following in portal-ext.properties:
    
    dl.store.file.system.root.dir=
    dl.store.impl=com.liferay.portal.store.file.system.AdvancedFileSystemStore

The nodes in the cluster should reflect the same properties between one another when referencing the Document Library. Otherwise, data corruption and indexing issues may occur if each node is referencing separate Document Library repositories. The folders should point to the same physical folder.

+$$$

**Checkpoint**: please verify the steps above by following these steps:

* On Node 1, upload a document to the Document Library.
* On Node 2, download the document.

If successful, the document should download. Repeat with the nodes reversed.

$$$

Note 1: Advanced File System Store is an available option for high availability environments. Besides Advanced File System Store, there are other options of sharing the Document and Media Library. Keep in mind that the different types of file stores cannot communicate with each other, so changing from one to the other will cause the portal to be unable to read previously uploaded files. If the user needs to change the type of store and preserve previously uploaded files, execute a File Store migration.

 
Note 2: If storing your documents in file system is not an option then DBStore storage method is available by using the following portal property:

`dl.store.impl=com.liferay.portal.store.db.DBStore`

 
Note 3: JCRStore on a database is another option. Because Jackrabbit does not create indexes on its own tables, over time this may be a performance penalty. Users must change manually the index for the primary key columns for all the Jackrabbit tables. Other configuration to take note of is the limit of the amount of connections to your database.

 
Note 4: The number of connections to the database is another factor. Consider increasing the number of database connections to the application server.

 
Note 5: For an in-depth description of each type of file store, see the admin guide for Liferay [https://www.liferay.com/documentation/liferay-portal/6.2/user-guide/-/ai/liferay-clustering-liferay-portal-6-2-user-guide-20-en](https://www.liferay.com/documentation/liferay-portal/6.2/user-guide/-/ai/liferay-clustering-liferay-portal-6-2-user-guide-20-en) or Guide for Document and Media Library article: [https://www.liferay.com/group/customer/kbase/-/knowledge_base/article/14370777](https://www.liferay.com/group/customer/kbase/-/knowledge_base/article/14370777)
//TODO: fix links to point to DXP
 
### Search and Index Sharing

Starting from @product@ the search engine needs to be separated from the main Liferay server for scalability reasons. For it there are two ways to achieve it: [Elasticsearch](https://customer.liferay.com/documentation/knowledge-base/-/kb/170088) or [Solr](https://customer.liferay.com/documentation/knowledge-base/-/kb/151456).
//TODO: fix links to point to the deployment guide
 
+$$$

**Checkpoint**: please verify the steps above by following these steps:

On Node 1, go to Control Panel -> Users and create a new user

On Node 2, go to Control Panel -> Users. Verify that the new user has been created.

If successful, the new user will display in the other node without needing to re-index. Do the same test with the nodes reversed.

$$$
 
Note : Storing indexes locally is not an option anymore: `lucene.replicate.write=true` is deprecated.

 
### Distributed Caching (Multicast or Unicast?)

Distributed caching allows a Liferay cluster to share cache content among multiple cluster nodes via Ehcache. Liferay has a specific article on [managing a distributed cache](https://www.liferay.com/group/customer/knowledge/kb/-/knowledge_base/article/37840259).

Note 1: Ehcache has a lot of different modifications that can be done to cache certain objects. Users can tune these settings for their needs. Please see more about the caching settings in the Distributed Caching section of the User Guide. For advanced optimization and configuration, please refer to the Ehcache documentation: [http://www.ehcache.org/documentation/configuration](http://www.ehcache.org/documentation/configuration)

 
Note 2: To learn more about Ehcache's default cache replication techniques or to learn how to deploy the tuning cache to the portal, please see the [Advanced Ehcache Configuration](https://www.liferay.com/group/customer/kbase/-/knowledge_base/article/14624847) knowledge base article.

 
### Hot Deploy Folders

Keep in mind that by default all deployable plugins must be deployed separately to all nodes.

 
However, every application server has a way of configuring "server farms" so that deploying to one location causes deployment to all nodes. Please see each application server's documentation for instructions.

 
### Other Issues to Check

* On some operating systems, IPv4 and IPv6 addresses are mixed so clustering will not work. To solve this, add the following JVM startup parameter:
   `-Djava.net.preferIPv4Stack=true`
* If you run your cluster node on the same machine you need to configure:
    * Application Server ports
    * OSGI console ports via portal-ext.properties:
    `module.framework.properties.osgi.console=localhost:11311`

 
## Additional Information
The links contained in this article will be updated as we create new content. Thank you for your understanding and patience. 

Related Links:
//TODO: fix links
[Liferay Clustering](https://customer.liferay.com/documentation/6.2/deploy/-/official_documentation/deployment/liferay-clustering)

[Managing Liferay's Distributed Cache](https://customer.liferay.com/documentation/knowledge-base/-/kb/122013)

[How to Cluster with TCP Unicast](https://customer.liferay.com/documentation/knowledge-base/-/kb/53747)

[Liferay's DXP whitepapers](https://customer.liferay.com/documentation/knowledge-base/-/kb/298611), including the [deployment checklist](https://www.liferay.com/documents/10182/1645493/Liferay+DXP+Deployment+Checklist/bf452028-62f2-49bd-b024-94ce04a0c941) and ["Upgrading to @product@"](https://www.liferay.com/documents/10182/1645493/How+to+Upgrade+to+Liferay+DXP/6d28e96b-7de3-44c7-9692-3631c7d226fc)