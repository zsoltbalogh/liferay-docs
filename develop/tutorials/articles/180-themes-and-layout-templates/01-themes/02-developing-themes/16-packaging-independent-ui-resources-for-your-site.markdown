# Packaging Independent UI Resources for Your Site [](id=packaging-independent-ui-resources-for-your-site)

If you want to package UI resources independent of a specific theme and
include them on a @product@ page, Theme Contributors are your best option. If,
instead, you'd like to include separate UI resources on a @product@ page that
are attached to a theme, you should look into
[themelets](/develop/tutorials/-/knowledge_base/7-1/creating-reusable-pieces-of-code-for-your-themes).

A Theme Contributor is a
[module](https://dev.liferay.com/participate/liferaypedia/-/wiki/Main/Module)
that contains UI resources to use in @product@. Once a Theme Contributor is
deployed to @product@, it's scanned for all valid CSS and JS files, and then its
resources are included on the page. You can, therefore, style these UI
components as you like, and the styles are applied for the current theme.

This tutorial demonstrates how to

- Identify a Theme Contributor module.
- Create a Theme Contributor module.

Next, you'll learn how to create a Theme Contributor.

## Creating Theme Contributors [](id=creating-theme-contributors)

The standard UI for User menus and navigation are packaged as Theme Contributors.
For example, the Control Menu, Product Menu, and Simulation Panel are packaged
as Theme Contributor modules in @product@, separating them from the theme. This
means that these UI components must be handled outside the theme.

![Figure 1: The Control Menu, Product Menu, and Simulation Panel are packaged as Theme Contributor modules.](../../../../images/theme-contributor-menus-diagram.png)

If you want to edit or style these standard UI components, you'll need to create
your own Theme Contributor and add your modifications on top. You can also add
new UI components to @product@ by creating a Theme Contributor.

To create a Theme Contributor module, follow these steps:

1.  Create a generic OSGi module using your favorite third party tool, or use
    [Blade CLI](/develop/tutorials/-/knowledge_base/7-1/blade-cli). You can also
    use the 
    [Blade Template](/develop/reference/-/knowledge_base/7-1/theme-contributor-template)
    to create your module, in which case you can skip step 2.

2.  To identify your module as a Theme Contributor, add the
    `Liferay-Theme-Contributor-Type` and `Web-ContextPath` headers to your
    module's `bnd.bnd` file. For example, see the
    [Control Menu module's](@app-ref@/web-experience/latest/javadocs/com/liferay/product/navigation/control/menu/theme/contributor/internal/package-frame.html)
    `bnd.bnd`:

        Bundle-Name: Liferay Product Navigation Control Menu Theme Contributor
        Bundle-SymbolicName: com.liferay.product.navigation.control.menu.theme.contributor
        Bundle-Version: 2.0.12
        Liferay-Releng-Module-Group-Description:
        Liferay-Releng-Module-Group-Title: Product Navigation
        Liferay-Theme-Contributor-Type: product-navigation-control-menu
        Web-ContextPath: /product-navigation-control-menu-theme-contributor

    The Theme Contributor type helps @product@ better identify your module. For
    example, if you're creating a Theme Contributor to override an existing
    Theme Contributor, you should try to use the same type to maximize
    compatibility with future developments. The `Web-ContextPath` header sets
    the context from which the Theme Contributor's resources are hosted.

3.  Because you'll often be overriding CSS of another Theme Contributor, you
    should load your CSS after theirs. You can do this by setting a weight for
    your Theme Contributor. In your `bnd.bnd` file, add the following header:

        Liferay-Theme-Contributor-Weight: [value]

    The higher the value, the higher the priority. If your Theme Contributor has
    a weight of 100, it will be loaded after one with a weight of 99, allowing
    your CSS to override theirs.

4.  Create a `src/main/resources/META-INF/resources` folder in your module
    and place your resources (CSS and JS) in that folder.

5.  Build and deploy your module to see your modifications applied to @product@
    pages and themes.

That's all you need to do to create a Theme Contributor for your site. Remember,
with great power comes great responsibility, so use Theme Contributors wisely.
The UI contributions affect every page and aren't affected by theme deployments.

## Related Topics [](id=related-topics)

[Creating Themes](/develop/tutorials/-/knowledge_base/7-1/creating-themes)

[Themelets](/develop/tutorials/-/knowledge_base/7-1/creating-reusable-pieces-of-code-for-your-themes)

[Importing Resources with Your Themes](/develop/tutorials/-/knowledge_base/7-1/importing-resources-with-a-theme)

[Theme Contributor Template](/develop/reference/-/knowledge_base/7-1/theme-contributor-template)
