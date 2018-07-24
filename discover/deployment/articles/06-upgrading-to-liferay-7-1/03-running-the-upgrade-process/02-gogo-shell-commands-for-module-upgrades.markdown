# Gogo Shell Commands for Module Upgrades [](id=gogo-shell-commands-for-module-upgrades)

Liferay's Gogo shell commands let you upgrade and verify individual modules.
It's a fine grained approach to upgrading the core and non-core modules. Here's
what you can do with the commands: 

- [Get command usage](#command-usage)
- [List modules to upgrade](#listing-module-upgrade-processes)
- [Upgrade modules](#executing-module-upgrades) 
- [Check upgrade status](#checking-the-upgrade-status) 
- [Verify upgrades](#executing-verify-processes) 

+$$$

**Note**: [Configuring the core upgrade](/discover/deployment/-/knowledge_base/7-1/running-the-upgrade#configuring-the-core-upgrade)
is required before using Gogo shell commands to upgrade the core. 

$$$

First explore the command usage. 

## Command Usage [](id=command-usage)

If you ran the upgrade tool and it opened Gogo shell, you're already connected.
Otherwise, you can execute commands using the
[Gogo Shell portlet](/develop/reference/-/knowledge_base/7-1/using-the-felix-gogo-shell).

Here are the commands available in the `upgrade` namespace:

**exit** or **quit:** exits the Gogo shell

**upgrade:help:** displays upgrade commands

**upgrade:check:** list upgrades pending to execute because they failed in 
the past or the module hasn't reached its final version

**upgrade:execute {module_name}:** executes upgrades for that module

**upgrade:executeAll:** executes all pending module upgrade processes

**upgrade:list:** lists all registered upgrades

**upgrade:list {module_name}:** lists the module's required upgrade steps

**upgrade:list | grep Registered:** lists registered upgrades and their versions

**verify:help:** displays verify commands

**verify:check {module_name}:** lists the latest execution result for the
module's verify process

**verify:checkAll:** lists the latest execution results for all verify processes

**verify:execute {module_name}:** executes the module's verifier

**verify:executeAll:** executes all verifiers

**verify:list:** lists all registered verifiers

There are many useful
[Liferay commands and standard commands available in Gogo shell](/develop/reference/-/knowledge_base/7-1/using-the-felix-gogo-shell).
The following sections describe Liferay upgrade commands. 

## Listing module upgrade processes [](id=listing-module-upgrade-processes)

Before upgrading modules, you should find which have unresolved dependencies,
which are resolved and available to upgrade, and examine the module upgrade
processes. 

Executing `upgrade:list` in the Gogo shell lists the modules whose upgrade
dependencies are satisfied. These modules can be upgraded. 

If a module is active but not listed, its dependencies need to be upgraded. The
Gogo shell command `scr:info [upgrade_step_class_qualified_name]` shows the
upgrade step class's unsatisfied dependencies. Here's an example `scr:info`
command:

    scr:info com.liferay.journal.upgrade.JournalServiceUpgrade

Invoking `upgrade:list [module_name]` lists the module's upgrade processes, in
no particular order.  For example, executing `upgrade:list
com.liferay.bookmarks.service` (for the Bookmarks Service module), lists this:

    Registered upgrade processes for com.liferay.bookmarks.service 1.0.0
            {fromSchemaVersionString=0.0.0, toSchemaVersionString=1.0.0, upgradeStep=com.liferay.portal.spring.extender.internal.context.ModuleApplicationContextExtender$ModuleApplicationContextExtension$1@6e9691da}
            {fromSchemaVersionString=0.0.1, toSchemaVersionString=1.0.0-step-3, upgradeStep=com.liferay.bookmarks.upgrade.v1_0_0.UpgradePortletId@5f41b7ee}
            {fromSchemaVersionString=1.0.0-step-1, toSchemaVersionString=1.0.0, upgradeStep=com.liferay.bookmarks.upgrade.v1_0_0.UpgradePortletSettings@53929b1d}
            {fromSchemaVersionString=1.0.0-step-2, toSchemaVersionString=1.0.0-step-1, upgradeStep=com.liferay.bookmarks.upgrade.v1_0_0.UpgradeLastPublishDate@3e05b7c8}
            {fromSchemaVersionString=1.0.0-step-3, toSchemaVersionString=1.0.0-step-2, upgradeStep=com.liferay.bookmarks.upgrade.v1_0_0.UpgradeClassNames@6964cb47}

An application's upgrade step class names typically reveal their intention. For
example, the example's `com.liferay.bookmarks.upgrade.v1_0_0.UpgradePortletId`
upgrade step class updates the app's portlet ID. The other example upgrade step
classes update class names, the `LastPublishDate`, and `PortletSettings`.  The
example's step from `0.0.0` to `1.0.0` upgrades the module from an empty
database.

To examine a module's upgrade process better, you can sort the listed upgrade
steps mentally or in a text editor. Here's the upgrade step order for a
Bookmarks Service module to be upgraded from Liferay Portal 6.2 (the module's
database exists) to schema version `1.0.0`: 

- `0.0.1` to `1.0.0-step-3`
- `0.0.1-step-3` to `1.0.0-step-2`
- `0.0.1-step-2` to `1.0.0-step-1`
- `0.0.1-step-1` to `1.0.0`

The overall module upgrade process starts at version `0.0.1` and finishes at version
`1.0.0`. The first step starts on the initial version (`0.0.1`) and finishes on
the target version's highest step (`step-3`). The last step starts on the target
version's lowest step (`step-1`) and finishes on the target version (`1.0.0`). 

Once you understand the module's upgrade process, you can execute it with
confidence. 

## Executing module upgrades [](id=executing-module-upgrades)

Executing `upgrade:execute [module_name]` upgrades the module. You might run
into upgrade errors that you must resolve. Executing the command again starts
the upgrade from the last successful step. 

You can check upgrade status by executing `upgrade:list [module_name]`. For
example, entering `upgrade:list com.liferay.iframe.web` outputs this:

    Registered upgrade processes for com.liferay.iframe.web 0.0.1
	   {fromSchemaVersionString=0.0.1, toSchemaVersionString=1.0.0, upgradeStep=com.liferay.iframe.web.upgrade.IFrameWebUpgrade$1@1537752d}

The first line lists the module's name and current version. The example module's
current version is `0.0.1`. The `toSchemaVersionString` value is the target
version. 

Executing `upgrade:list [module_name]` on the module after successfully
upgrading it shows the module's name followed by the version you targeted. 

For example, if you successfully upgraded `com.liferay.iframe.web` to version
`1.0.0`, executing `upgrade:list com.liferay.iframe.web` shows the module's
version is `1.0.0`:

    Registered upgrade processes for com.liferay.iframe.web 1.0.0
	   {fromSchemaVersionString=0.0.1, toSchemaVersionString=1.0.0, upgradeStep=com.liferay.iframe.web.upgrade.IFrameWebUpgrade$1@1537752d}

For module upgrades that don't complete, you can check their status and resolve
their issues. 

## Checking upgrade status [](id=checking-the-upgrade-status)

It's good to know things still need upgrading and why. You might have forgotten
to upgrade a module or its upgrade failed. In any case, it's important to know
where your upgrade stands. 

The command `upgrade:check` lists modules that have impending upgrades. 

For example, if module  `com.liferay.dynamic.data.mapping.service` failed in a
step labeled `1.0.0-step-2`. Executing `upgrade:check` shows this: 

    Would upgrade com.liferay.dynamic.data.mapping.service from 1.0.0-step-2 to
    1.0.0 and its dependent modules

Modules often depend on other modules to complete upgrading. Executing `scr:info
[upgrade_step_class_qualified_name]` shows the upgrade step class's
dependencies. You must upgrade dependency modules to successfully upgrade
dependent modules. 

To resolve and activate a module, its upgrade must complete. The
[Apache Felix Dependency Manager](http://felix.apache.org/documentation/subprojects/apache-felix-dependency-manager/tutorials/leveraging-the-shell.html)
Gogo shell command `dm wtf` reveals unresolved dependencies. If your module
requires a certain data schema version (e.g., its `bnd.bnd` specifies
`Liferay-Require-SchemaVersion: 1.0.2`) but the module hasn't completed upgrade
to that version, `dm wtf` shows that the schema version is not registered. 

    1 missing dependencies found.
    -------------------------------------
    The following service(s) are missing:
     * com.liferay.portal.kernel.model.Release (&(release.bundle.symbolic.name=com.liferay.journal.service)(release.schema.version=1.0.2)) is not found in the service registry

The `dm wtf` command can also help detect errors in portlet definitions and
custom portlet `schemaVersion` fields. 

Browsing the @product@ database `Release_` table can help you determine a
module's upgrade status too. The core's `servletContextName` field value is
`portal`. If the core's `schemaVersion` field matches your new @product@ version
(e.g., `7.1.1` for Liferay Portal CE GA2) and the `verified` field is `1`
(true), the core upgrade completed successfully. 

Each module has one `Release_` table record, and the value for its
`schemaVersion` field must be `1.0.0` or greater (`1.0.0` is the initial version
for @product-ver@ modules, except for those that were previously traditional
plugins intended for Liferay Portal version 6.2 or earlier). 

## Executing verify processes [](id=executing-verify-processes)

Verify processes make sure the upgrade executed successfully. Verify processes
in the core are automatically executed after upgrading @product@. You can also
execute them by configuring the
[`verify.*` portal properties](@platform-ref@/7.1-latest/propertiesdoc/portal.properties.html#Verify)
and restarting your server.

Also, some modules have verify processes. To check for available verify
processes, enter the Gogo shell command `verify:list`. To run a verify process,
enter `verify:execute [verify_qualified_name]`. 
