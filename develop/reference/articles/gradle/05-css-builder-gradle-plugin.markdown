# CSS Builder Gradle Plugin [](id=css-builder-gradle-plugin)

The CSS Builder Gradle plugin lets you run the [Liferay CSS Builder](https://github.com/liferay/liferay-portal/tree/master/modules/util/css-builder)
tool to compile [Sass](http://sass-lang.com/) files in your project.

The plugin has been successfully tested with Gradle 2.5 up to 3.3.

## Usage [](id=usage)

To use the plugin, include it in your build script:

```gradle
buildscript {
    dependencies {
        classpath group: "com.liferay", name: "com.liferay.gradle.plugins.css.builder", version: "2.2.0"
    }

    repositories {
        maven {
            url "https://repository-cdn.liferay.com/nexus/content/groups/public"
        }
    }
}

apply plugin: "com.liferay.css.builder"
```

Since the plugin automatically resolves the Liferay CSS Builder library as a
dependency, you have to configure a repository that hosts the library and its
transitive dependencies. The Liferay CDN repository hosts them all:

```gradle
repositories {
    maven {
        url "https://repository-cdn.liferay.com/nexus/content/groups/public"
	}
}
```

## Tasks [](id=tasks)

The plugin adds one task to your project:

Name | Depends On | Type | Description
---- | ---------- | ---- | -----------
`buildCSS` | \- | [`BuildCSSTask`](#buildcsstask) | Compiles the Sass files in this project.

The plugin also adds the following dependencies to tasks defined by the [`java`](https://docs.gradle.org/current/userguide/java_plugin.html)
plugin:

Name | Depends On
---- | ----------
`processResources` | `buildCSS`

The `buildCSS` task is automatically configured with sensible defaults,
depending on whether the [`java`](https://docs.gradle.org/current/userguide/java_plugin.html)
or the [`war`](https://docs.gradle.org/current/userguide/war_plugin.html)
plugins are applied:

Property Name | Default Value
------------- | -------------
[`baseDir`](#basedir) | <p>**If the `java` plugin is applied:** The first `resources` directory of the `main` source set (by default: `src/main/resources`).</p><p>**If the `war` plugin is applied:** `project.webAppDir`.</p><p>**Otherwise:** `null`</p>

### BuildCSSTask [](id=buildcsstask)

Tasks of type `BuildCSSTask` extend [`JavaExec`](https://docs.gradle.org/current/dsl/org.gradle.api.tasks.JavaExec.html),
so all its properties and methods, such as [`args`](https://docs.gradle.org/current/dsl/org.gradle.api.tasks.JavaExec.html#org.gradle.api.tasks.JavaExec:args\(java.css.Iterable\))
and [`maxHeapSize`](https://docs.gradle.org/current/dsl/org.gradle.api.tasks.JavaExec.html#org.gradle.api.tasks.JavaExec:maxHeapSize),
are available. They also have the following properties set by default:

Property Name | Default Value
------------- | -------------
[`args`](https://docs.gradle.org/current/dsl/org.gradle.api.tasks.JavaExec.html#org.gradle.api.tasks.JavaExec:args) | CSS Builder command line arguments
[`classpath`](https://docs.gradle.org/current/dsl/org.gradle.api.tasks.JavaExec.html#org.gradle.api.tasks.JavaExec:classpath) | [`project.configurations.cssBuilder`](#liferay-css-builder-dependency)
[`defaultCharacterEncoding`](https://docs.gradle.org/current/javadoc/org/gradle/api/tasks/JavaExec.html#setDefaultCharacterEncoding\(java.lang.String\)) | `"UTF-8"`
[`main`](https://docs.gradle.org/current/dsl/org.gradle.api.tasks.JavaExec.html#org.gradle.api.tasks.JavaExec:main) | `"com.liferay.css.builder.CSSBuilder"`
[`systemProperties`](https://docs.gradle.org/current/dsl/org.gradle.api.tasks.JavaExec.html#org.gradle.api.tasks.JavaExec:systemProperties) | `["sass.compiler.jni.clean.temp.dir", true]`

#### Task Properties [](id=task-properties)

Property Name | Type | Default Value | Description
------------- | ---- | ------------- | -----------
`appendCssImportTimestamps` | `boolean` | `true` | Whether to append the current timestamp to the URLs in the `@import` CSS at-rules. It sets the `sass.append.css.import.timestamps` argument.
<a name="basedir"></a>`baseDir` | `File` | `null` | The base directory that contains the SCSS files to compile. It sets the `sass.docroot.dir` argument.
`cssFiles` | `FileCollection` | \- | The SCSS files to compile. *(Read-only)*
`dirNames` | `List<String>` | `["/"]` | The name of the directories, relative to [`baseDir`](#basedir), which contain the SCSS files to compile. All sub-directories are searched for SCSS files as well. It sets the `sass.dir` argument.
`generateSourceMap` | `boolean` | `false` | Whether to generate [source maps](https://developers.google.com/web/tools/chrome-devtools/debug/readability/source-maps) for easier debugging. It sets the `sass.generate.source.map` argument.
<a name="importdir"></a>`importDir` | `File` | `null` | The `META-INF/resources` directory of the [Liferay Frontend Common CSS](https://github.com/liferay/liferay-portal/tree/master/modules/apps/frontend-css/frontend-css-common) artifact. This is required in order to make [Bourbon](http://bourbon.io) and other CSS libraries available to the compilation.
`importFile` | `File` | [`configurations.portalCommonCSS.singleFile`](#liferay-frontend-common-css-dependency) | The Liferay Frontend Common CSS JAR file. If [`importDir`](#importdir) is set, this property has no effect.
`importPath` | `File` | \- | The value of the `importDir` property if set; otherwise `importFile`. It sets the `sass.portal.common.path` argument. *(Read-only)*
`outputDirName` | `String` | `".sass-cache/"` | The name of the sub-directories where the SCSS files are compiled to. For each directory that contains SCSS files, a sub-directory with this name is created. It sets the `sass.output.dir` argument.
`outputDirs` | `FileCollection` | \- | The directories where the SCSS files are compiled to. Usually, these directories are ignored by the Version Control System. *(Read-only)*
`precision` | `int` | `5` | The numeric precision of numbers in Sass. It sets the `sass.precision` argument.
`rtlExcludedPathRegexps` | `List<String>` | `[]` | The SCSS file patterns to exclude when converting for right-to-left (RTL) support. It sets the `sass.rtl.excluded.path.regexps` argument.
`sassCompilerClassName` | `String` | `null` | The type of Sass compiler to use. Supported values are `"jni"` and `"ruby"`. If not set, defaults to `"jni"`. It sets the `sass.compiler.class.name` argument.

+$$$

**Note:** Liferay's CSS Builder is supported for Oracle's JDK and uses a native
compiler for increased speed. If you're using an IBM JDK, you may experience
issues when building your Sass files (e.g., when building a theme). It's
recommended to switch to using the Oracle JDK, but if you prefer using the IBM
JDK, you must use the fallback Ruby compiler. You can do this two ways:

- If you're working in a
  [Liferay Workspace](/develop/tutorials/-/knowledge_base/7-1/liferay-workspace)
  or using the
  [Liferay Gradle Plugins](https://github.com/liferay/liferay-portal/tree/master/modules/sdk/gradle-plugins)
  plugin, set `sass.compiler.class.name=ruby` in your `gradle.properties` file.
- Otherwise, set `buildCSS.sassCompilerClassName='ruby'` in the project's
  `build.gradle` file.

The `sass.compiler.class.name=ruby` Gradle property only works for modules, so
if you're using the Ruby compiler in a WAR project (e.g., theme), you must use
the second option.

Be aware that the Ruby-based compiler doesn't perform as well as the native
compiler, so expect longer compile times.

$$$

The properties of type `File` support any type that can be resolved by [`project.file`](https://docs.gradle.org/current/dsl/org.gradle.api.Project.html#org.gradle.api.Project:file\(java.css.Object\)).
Moreover, it is possible to use Closures and Callables as values for the `int`
and `String` properties, to defer evaluation until task execution.

#### Task Methods [](id=task-methods)

Method | Description
------ | -----------
`BuildCSSTask dirNames(Iterable<Object> dirNames)` | Adds sub-directory names, relative to [`baseDir`](#basedir), which contain the SCSS files to compile.
`BuildCSSTask dirNames(Object... dirNames)` | Adds sub-directory names, relative to [`baseDir`](#basedir), which contain the SCSS files to compile.
`BuildCSSTask rtlExcludedPathRegexps(Iterable<Object> rtlExcludedPathRegexps)` | Adds SCSS file patterns to exclude when converting for right-to-left (RTL) support.
`BuildCSSTask rtlExcludedPathRegexps(Object... rtlExcludedPathRegexps)` | Adds SCSS file patterns to exclude when converting for right-to-left (RTL) support.

## Additional Configuration [](id=additional-configuration)

There are additional configurations that can help you use the CSS Builder.

### Liferay CSS Builder Dependency [](id=liferay-css-builder-dependency)

By default, the plugin creates a configuration called `cssBuilder` and adds a
dependency to the latest released version of the Liferay CSS Builder. It is
possible to override this setting and use a specific version of the tool by
manually adding a dependency to the `cssBuilder` configuration:

```gradle
dependencies {
    cssBuilder group: "com.liferay", name: "com.liferay.css.builder", version: "2.1.0"
}
```

### Liferay Frontend Common CSS Dependency [](id=liferay-frontend-common-css-dependency)

By default, the plugin creates a configuration called `portalCommonCSS` and adds
a dependency to the latest released version of the Liferay Frontend Common CSS
artifact. It is possible to override this setting and use a specific version of
the artifact by manually adding a dependency to the `portalCommonCSS`
configuration:

```gradle
dependencies {
    portalCommonCSS group: "com.liferay", name: "com.liferay.frontend.css.common", version: "2.0.1"
}
```
