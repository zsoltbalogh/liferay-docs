# Installing Liferay Maven Artifacts [](id=installing-liferay-maven-artifacts)

To create Liferay modules using Maven, you'll need the archives required by
Liferay (e.g., JAR and WAR files). This isn't a problem--Liferay provides
them as Maven artifacts. 

You can get the Liferay artifacts in two ways: 

- Install them from a remote repository. 
- Download a Liferay-provided utility for putting artifacts in local
  repositories. 

First, you'll consider the installation process using remote repositories.

## Installing Artifacts from a Remote Repository [](id=installing-artifacts-from-a-remote-repository)

There are two repositories that contain Liferay artifacts: Central Repository
and Liferay Repository. The Central Repository is the default repository used to
download artifacts if you don't have a remote repository configured. The Central
Repository *usually* offers the latest Liferay Maven artifacts, but using the
the Liferay Repository *guarantees* the latest artifacts released by Liferay.
Other than a slight delay between artifact releases between the two
repositories, they're identical. You'll learn how to reference both of them
next.

Using the Central Repository to install Liferay Maven artifacts only requires
that you specify your module's dependencies in its `pom.xml` file. For example,
the snippet below sets a dependency on Liferay's `com.liferay.portal.kernel`
artifact:

    <dependencies>
        <dependency>
            <groupId>com.liferay.portal</groupId>
            <artifactId>com.liferay.portal.kernel</artifactId>
            <version>2.61.2</version>
            <scope>provided</scope>
        </dependency>
        ...
    </dependencies>

When packaging your module, the automatic Maven artifact installation process
only downloads the artifacts necessary for that module from the Central
Repository. 

You can view the published Liferay Maven artifacts on the Central Repository by
searching for *liferay maven* in the repo's Search bar. For convenience, you can
reference the available artifacts at
[http://search.maven.org/#search|ga|1|liferay maven](http://search.maven.org/#search|ga|1|liferay%20maven).
Use the Latest Version column as a guide to see what's available for
the intended version of @product@ for which you're developing.

If you'd like to access Liferay's latest Maven artifacts, you can configure
Maven to use 
[Liferay's Nexus repository](https://repository.liferay.com) instead by
inserting the following snippet in your project's parent `pom.xml`:

    <repositories>
        <repository>
            <id>liferay-public-releases</id>
            <name>Liferay Public Releases</name>
            <url>https://repository.liferay.com/nexus/content/repositories/liferay-public-releases</url>
        </repository>
    </repositories>
	  
	<pluginRepositories>
        <pluginRepository>
            <id>liferay-public-releases</id>
            <url>https://repository.liferay.com/nexus/content/repositories/liferay-public-releases/</url>
        </pluginRepository>
    </pluginRepositories>

The above configuration retrieves artifacts from Liferay's release repository.

+$$$

**Note:** Liferay also provides a
[snapshot repository](https://repository.liferay.com/nexus/content/repositories/liferay-public-snapshots/)
that you can access by modifying the `<id>`, `<name>`, and `<url>` tags to
point to that repo. This repository should only be used in special cases. You'll
also need to enable accessing the snapshot artifacts:

    <snapshots>
        <enabled>true</enabled>
    </snapshots>

$$$

When the Liferay repository is configured in your `settings.xml` file,
archetypes are generated based on that repository's contents. See the
[Generating New Projects Using Archetypes](/develop/tutorials/-/knowledge_base/7-1/generating-new-projects-using-archetypes)
tutorial for details on using Maven archetypes for Liferay development.

If you've configured the Liferay Nexus repository to access Liferay
Maven artifacts and you've already been syncing from the Central Repository,
you may need to clear out parts of your local repository to force Maven to
re-download the newer artifacts. Also, do not leave the Liferay repository
configured when publishing artifacts to Maven Central. You must comment out the
Liferay Repository credentials when publishing your artifacts.

The Liferay Maven repository offers a good alternative for those who want the
most up-to-date Maven artifacts produced by Liferay. 

If you can't use either of these options, you can still install Liferay Maven
artifacts from a local repository.

## Installing Artifacts from a Local Repository [](id=installing-artifacts-from-a-local-repository)

Liferay offers a utility available from Liferay's Customer Portal that lets you
download all of Liferay's artifacts and install them to a Maven repository of
your choice.

1.  Navigate to the [Digital Enterprise](https://web.liferay.com/group/customer/dxp/downloads/7-1)
    download page in Liferay's Customer Portal and select *Maven* from the
    drop-down list to download the latest version of @product@ Maven.

    ![Figure 1: Select *Maven* from the drop-down list to download the @product@ Maven artifact Zip file.](../../../images-dxp/maven-select-download.png)

    <!--TODO: Update image above for 7.1, once available. -Cody -->

2.  Unzip the file and navigate to it in your command prompt. Then run the Ant
    command without a target.
    
        ant
    
    You can verify Liferay's artifacts are being installed by reading the output
    messages in your command prompt. The artifacts are downloaded from Liferay's
    Nexus repository.

    By default, all of Liferay's Maven artifacts are installed in your
    `[USER_HOME]/.m2` repository. You can change where the artifacts are
    installed by creating a `build.[USER_NAME}.properties` file in the Liferay
    Portal Maven folder and setting the `local.repository.path` property to the
    folder you want your artifacts to reside in.

Now you have all of Liferay's Maven artifacts locally and can delegate them to
any repository or folder you choose.

Congratulations! You've downloaded the Liferay artifacts and installed them to
your chosen repository.
