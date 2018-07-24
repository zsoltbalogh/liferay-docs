# Adding Portlet Decorators to a Theme [](id=adding-portlet-decorators-to-a-theme)

Portlet Decorators are associated with a particular theme. If your theme
does not define any portlet decorators, none are available. It is recommended
that you provide a few decorators for your portlets to cover the basic use
cases.

For example, the Liferay Portal CE 7.1 
[Classic theme](https://github.com/liferay/liferay-portal/tree/7.1.x/modules/apps/frontend-theme/frontend-theme-classic)
includes three Portlet Decorators:

-   Decorate: this is the default Application Decorator when using the Classic 
    theme. It wraps the application in a white box with a border, and displays
    the title at the top. theme.

    ![Figure 1: The Classic theme's Decorate Application Decorator wraps the portlet in a white box.](../../../../images/application-decorator-decorate.png)

-   Borderless: this decorator shows the title at the top, but does not display
    a wrapping box.

    ![Figure 2: The Classic theme's Borderless Application Decorator displays the application's custom title.](../../../../images/application-decorator-borderless.png)

-   Barebone: this decorator displays the bare application content, showing 
    neither the wrapping box nor the custom application title. 

    ![Figure 3: The Classic theme's Barebone Application Decorator displays only the application's content.](../../../../images/application-decorator-barebone.png)

+$$$

**Note:** Upgrading to @product@ assigns the *borderless* decorator 
automatically to those portlets that had the *Show Borders* option set to false
in previous versions of Liferay.

$$$

This tutorial demonstrates how to

- Add Portlet Decorators to your theme

- Affect theme markup with Portlet Decorators

## Adding Portlet Decorators to a Theme [](id=adding-application-decorators-to-a-theme)

Adding Portlet Decorators to your theme is similar to adding Color Schemes. Follow these steps:

1.  Configure your theme's `liferay-look-and-feel.xml`
2.  Define the Application Decorator CSS styles
3.  Optional: Add conditions to your theme's markup

### Configuring liferay-look-and-feel.xml [](id=configuring-liferay-look-and-feel-xml)

The first thing you must do is declare the Portlet Decorators in your theme's
`liferay-look-and-feel.xml`.

The 
[Document Type Definition for the liferay-look-and-feel.xml](@platform-ref@/7.1-latest/definitions/liferay-look-and-feel_7_0_0.dtd.html#portlet-decorator)
contains the information and rules to add Portlet Decorators
(in the code referred as portlet-decorators) to your theme.

Here is how the classic theme defines Portlet Decorators in its
`liferay-look-and-feel.xml`:

    <?xml version="1.0"?>
    <!DOCTYPE look-and-feel PUBLIC "-//Liferay//DTD Look and Feel 7.0.0//EN" "http://www.liferay.com/dtd/liferay-look-and-feel_7_0_0.dtd">

    <look-and-feel>
	    <compatibility>
		    <version>7.1.0+</version>
	    </compatibility>
	    ...
            <theme id="classic" name="Classic">
		    ...
		    <portlet-decorator id="barebone" name="Barebone">
			    <portlet-decorator-css-class>portlet-barebone</portlet-decorator-css-class>
		    </portlet-decorator>
		    <portlet-decorator id="borderless" name="Borderless">
			    <portlet-decorator-css-class>portlet-borderless</portlet-decorator-css-class>
		    </portlet-decorator>
		    <portlet-decorator id="decorate" name="Decorate">
			    <default-portlet-decorator>true</default-portlet-decorator>
			    <portlet-decorator-css-class>portlet-decorate</portlet-decorator-css-class>
		    </portlet-decorator>
            </theme>
    </look-and-feel>

The `portlet-decorator` element contains all the information about the
Application Decorator:

-   `id`: this required attribute contains a unique string that identifies this
    specific Application Decorator. This is the value that is stored when
    applying an Application Decorator, and it can be used to refer to this
    decorator in your theme templates.
-   `name`: this required attribute is a user friendly identifier for the
    Application Decorator to be displayed in the Look and Feel UI.
-   `portlet-decorator-css-class`: this required element contains the name of 
    the CSS class that is added to the application wrapping layer when this
    Application Decorator is applied.
-   `default-portlet-decorator`: use this optional element to identify the 
    default Application Decorator for your theme.

You can define as many Portlet Decorators as you want, but it's recommended
to include at least one for the *decorate*, *borderless* and *barebone* use
cases.

### Define the Styles for Your Application Decorator CSS Class [](id=define-the-styles-for-your-application-decorator-css-class)

Once you've declared your Portlet Decorators, it's time to define their effect 
in the application look and feel. While the previous step was straightforward, 
this one asks for some creativity.

As an example, look at the `_portlet_decorator.scss` of the Classic theme:

    .portlet-decorate .portlet-content {
	    background: #FFF;
	    border: 1px solid #DEEEEE;
    }

    .portlet-barebone .portlet-content {
	    padding: 0;
    }

Once your CSS styles are written, import the CSS file into your `_custom.scss`:

    @import "portlet_decorator"

That's all that's required to add Portlet Decorators to your theme. If you
want to modify your application's markup with your Portlet Decorators, read
the next section.

### Changing Your Application Markup with Portlet Decorators [](id=changing-your-application-markup-with-application-decorators)

So far you've seen how to use Portlet Decorators to change the look and feel
of an application with styles.

It's possible to go a step further and alter the markup of your application
based on the Application Decorator applied. For this, you must edit the
`portlet.ftl` template for your theme, retrieve the `portletDecoratorId` of the
current Application Decorator from the `portletDisplay` object, and make some
decisions based on it.

For example, this is how the Classic theme shows the application title when the
*barebone* Application Decorator is not applied:

    <#if !stringUtil.equals(portlet_display.getPortletDecoratorId(), "barebone")>
        <h2 class="portlet-title-text">${portlet_title}</h2>
    </#if>

Now you know how to add Portlet Decorators to your theme. Let your creativity
be your guide.

## Related Topics [](id=related-topics)

[Themelets](/develop/tutorials/-/knowledge_base/7-1/creating-reusable-pieces-of-code-for-your-themes)

[Making Your Applications Configurable](/develop/tutorials/-/knowledge_base/7-1/making-your-applications-configurable)
