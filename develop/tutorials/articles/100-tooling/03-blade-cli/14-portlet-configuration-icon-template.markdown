# Portlet Configuration Icon [](id=portlet-configuration-icon)

In this tutorial, you'll learn how to create a Liferay portlet configuration
icon as a Liferay module. To create a portlet configuration icon as a module,
use a command with the following parameters: 

    blade create -t portlet-configuration-icon [-p packageName] [-c className] projectName

The template for this kind of project is `portlet-configuration-icon`. Suppose
you want to create a portlet configuration icon project called
`my-portlet-config-icon` with a package name of
`com.liferay.docs.portlet.configuration.icon` and a class name of
`SamplePortletConfigurationIcon`. You could run the following command to
accomplish this:

    blade create -t portlet-configuration-icon -p com.liferay.docs -c Sample my-portlet-config-icon

After running the command above, your project's directory structure would look
like this

- `my-portlet-config-icon`
    - `gradle`
        - `wrapper`
            - `gradle-wrapper.jar`
            - `gradle-wrapper.properties`
    - `src`
        - `main`
            - `java`
                - `com/liferay/docs/portlet/configuration/icon`
                    - `SamplePortletConfigurationIcon.java`
            - `resources`
                - `content`
                    - `Language.properties`
    - `bnd.bnd`
    - `build.gradle`
    - `gradlew`

The generated module is functional and is deployable to a Liferay instance. The
generated module, by default, creates a sample link in the Hello World portlet's
Options menu. To build upon the generated app, modify the project by adding
logic and additional files to the folders outlined above. You can visit the
[blade.portlet.configuration.icon](https://github.com/liferay/liferay-blade-samples/tree/master/liferay-gradle/blade.portlet.configuration.icon)
sample project for a more expanded sample of a portlet configuration icon.
