# Using the CMIS Store [](id=using-the-cmis-store)

Though you can mount as many different CMIS (Content Management Interoperability
Services) repositories as you like in the Documents and Media library, you can
also define the @product@ repository to point to a CMIS repository. 

To use the CMIS store, follow these steps:

1.  Configure `portal-ext.properties` with this property: 

        dl.store.impl=com.liferay.portal.store.cmis.CMISStore

2.  Restart @product@.

3.  In the Control Panel, navigate to *Configuration* &rarr;
    *System Settings* &rarr; *File Storage*. 

4.  In the *CMIS Store* screen, configure the store your way. 

5.  In the *CMIS Repository* screen, configure the repository your way. 

To use the CMIS store in a cluster, follow these steps:

1.  Copy the `portal-ext.properties` to each node's
    [`[Liferay Home]` folder](/discover/deployment/-/knowledge_base/7-1/installing-liferay#liferay-home). 

2.  Export the configuration from the *CMIS Store* screen to a 
    [`.config` file](/discover/portal/-/knowledge_base/7-1/understanding-system-configuration-files). 

3.  Export the configuration from the *CMIS Repository* screen to a 
    [`.config` file](/discover/portal/-/knowledge_base/7-1/understanding-system-configuration-files). 

4.  Copy the `.config` files to each node's `[Liferay Home]/osgi/configs` 
    folder. 

5.  Restart @product@ on the nodes. 

The @product@ repository is connected to CMIS via the CMIS store. As long as all
nodes are pointing to your CMIS repository, everything in your cluster should be
fine, as the CMIS protocol prevents multiple simultaneous file access from
causing data corruption. 
