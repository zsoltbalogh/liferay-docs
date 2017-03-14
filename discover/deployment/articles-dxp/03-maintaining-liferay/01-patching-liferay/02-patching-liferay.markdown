# Using the Patching Tool [](id=patching-tool)

If you're using a @product@ bundle, the Patching Tool is already installed. When
an update is necessary to install a patch, the Patching Tool automatically
asks for an update.

You follow the same procedure whether you're installing or upgrading the
Patching Tool. Once you've obtained it from the Customer Portal, unzip it
anywhere in the file system. Generally it's a good idea to keep it together with
the @product@ installation.

Upgrading is easy: override the previous Patching Tool with newest one by
unzipping it on top of the old version. 

## Executables [](id=executables)

The Patching Tool is a Java based application. The distribution contains shell/
.bat scripts to make it easier to use. On Unix systems you can run

    ./patching-tool.sh parameters

On Windows, run

    patching-tool parameters

The latter method appears in the examples below. On Unix, replace the name of
the executable before running the scripts.

## Installing Patches [](id=installing-patches)

The first thing you must do when installing patches is to shut down your server.
On Windows operating systems, files that are in use are locked by the OS, and
can't be patched. On Unix-style systems, you can usually replace files that are
running, but that still leaves the old ones loaded in memory. So your best bet
is to shut down the application server that's running @product@ before you install
a patch. 

Liferay distributes patches as `.zip` files, whether they are hotfixes or fix
packs. When you receive one, either via a LESA ticket (hotfix) or through
downloading a fix pack from the [Customer Portal](https://web.liferay.com/group/customer), 
place it in the `patches` folder that's inside the Patching Tool's home
folder. Once you've done that, it's a simple matter to install it. First,
execute

    patching-tool info
 
This displays a list of patches you've already installed, along with a list of
patches that *can* be installed from what's in the `patches` folder. 

To install the available patches, use the following steps. First, 
issue the following command: 

    patching-tool install

+$$$

**Note:** After a successful patch installation you must delete the *osgi/state*
folder if it exists in your Liferay Home directory.

$$$

If there are new database indexes created by the patch, the Patching Tool tells
you to update them. To get the list, run this command:

    patching-tool index-info

Since there's no database connection at patching time, the indexes must be
created at portal startup. To have the indexes created automatically, add the
following line to the `portal-ext.properties` file if the server has permissions
to modify the indexes on the database:

    database.indexes.update.on.startup=true

Otherwise, you must create the indexes manually. Check the output of the
`patching-tool index-info` command for more details.

Once your patches have been installed, you can verify them by using the
`patching-tool info` command, which now shows your patches in the list of
installed patches. 

+$$$

**Note:** If there are any issues with the installed fixes, verify that there aren't
any remaining files from the previous patch installation of a fix pack or
hotfix within the application server cache.

$$$

During the installation, `patching-backup-deps.zip` and `patching-backup.zip`
files are created and stored in the `ROOT/WEB-INF` folder. These files are
necessary to restore the @product@'s original state; removing them would disable
further patching.

The `patching-backup.zip` file is necessary for installing future patches,
because the Patching Tool reverts the installed fix pack before installing a new
one. To revert the installed fix pack, it examines the contents of the
`patching-backup.zip` to determine the changes that it needs to revert. 

### Handling Hotfixes and Patches [](id=handling-hot-fixes-and-patches)

As stated above, hotfixes are short term fixes provided as quickly as possible,
and fix packs are larger bundles of hotfixes provided to all customers at
regular intervals. If you already have a hotfix installed and the fix pack
that contains that hotfix is released, the Patching Tool can manage this for
you. Fix packs always supersede hotfixes, so when you install your fix pack,
the hotfix that it contains is uninstalled, and the fix pack version is
installed in its place. 

Sometimes there can be a fix to a fix pack. This is also handled automatically.
If a new version of a fix pack is released, you can use the Patching Tool to
install it. The Patching Tool uninstalls the old fix pack and installs the new
version in its place. 

### Including '*support-info*' in LESA Tickets [](id=including-support-info-in-lesa-tickets)

To enable Liferay to reproduce subscriber issues, it is critical that the patch
level in a given environment be made available to Liferay. 

To generate the patch level for your environment, use the following command: 

    patching-tool support-info
 
A text file called `patching-tool-support-info-actual-timestamp.txt` is created
in the patching-tool folder. Please upload this file to the LESA ticket.


### Fix Pack Dependencies [](id=fix-pack-dependencies)

Some hotfixes require a fix pack to be installed first. If you attempt to
install a hotfix that depends on a fix pack, the Patching Tool notifies
you. Go to the customer portal and obtain the hotfix dependency. Once all the
necessary patches are available in the `patches` folder, the Patching Tool 
installs them. 

The Patching Tool can also remove patches. 

## Removing or Reverting Patches [](id=removing-or-reverting-patches)

Have you noticed that the Patching Tool only seems to have an `install` command?
This is because patches are managed not by the command, but by what appears in
the `patches` folder. You manage the patches you have installed by adding or
removing patches from this folder. If you currently have a patch installed that
you don't want, remove it from the `patches` folder. When you run the
`patching-tool install` command, and the patch is removed. 

If you want to remove all patches you've installed, use the `./patching-tool.sh
revert` command. This removes all patches from your installation.

The OSGi state folder may contain obsolete bundles in its cache that must be
removed. If it exists, delete the *osgi/state* folder in Liferay Home.

## Cleaning Up [](id=cleaning-up)

After you've performed your patching procedure (whether you've installed or
removed patches), it's important to clean up @product@'s cache of deployed code.
This ensures that when you start the server, you're using the revision you've
just installed the patches for. This is really easy to do. 

In the Liferay Home folder is a folder called `work`. Remove the contents of
this folder to clear out the cached code. Now you're ready to start your server. 

## Comparing Patch Levels [](id=comparing-patch-levels)

If you're a developer, the Patching Tool can show you what changed between
different versions. These commands show you information about the different
patch levels:

`patching-tool diff`: Prints the differences between two patch levels. At least
one stored patch level must be available. This command accepts options for
filtering the output: 

- `source`: Shows the source differences between the two patch levels.
- `files`: Shows a list of the modified files.
- `fixed-issues`: Shows a list of LPS/LPE issues from our issue tracking system.

For detailed usage information, run `patching-tool help diff`.

`patching-tool store`: Manages patching level information for diff command. Your
patches must contain source code to store the patch level and to prepare usable information for
the "diff" command. This command has four options: 

- `info`: Prints the list of patches which make up the stored patch level.
- `add`: Stores the patch level that can be found in the patches directory.
- `update`: Adds or updates patch level information.
- `rm`: Removes previously stored patch level information.

For detailed usage information, run `patching-tool help store`.

## Separate the patches from the @product@.

There is a new feature available as of Patching Tool 2.0.6 in a favor of
reducing the size of the patched @product@ bundles. It's possible to decrease
the bundle's size if it's already been patched.

To show you what's the reason behind, here are the numbers:
1. Digital Enterprise 7.0 bundled with Tomcat ~ 430 MB
2. Digital Enterprise 7.0 SP1 bundled with Tomcat ~ 856 MB
     - _Fix pack: de-7 included in SP1 ~ 213 MB_
     - _The restore file for Patching Tool ~ 219 MB_
          - The patching files are about 432 MB.

We cannot simply remove the Patching related files from the bundle because the
upcoming patching processes would fail. Thus we added an option to the Patching
Tool to separate the patching files from the @product@ bundle in a way to be
able to restore them safely when it comes to installing a new patch.

`patching-tool separate <separation_name>`: This command produces a
new file in the Patching Tool's `patches` folder, named as
`liferay-patching-files-<separation-name>.zip`. 

This new file contains the necessary files for patching along with the
necessary metadata for verification and validation. The listed patching
related files are now only available in this file. It results that the @product@
bundle's size will be much slimmer and can be kept separately from its patching
artifacts.

+$$$

**Note:** If the product is separated from its patches, you cannot run most of
the Patching Tool commands until it's not restored.

$$$
 
After the separation process only the following commands can be used:
- auto-discovery
- info
- setup

Any other command will return an info message:
"This installation does not include data for patching. Please copy the
`liferay-patching-files-<separation-name>.zip` file into the 'patches' directory
and run patching-tool setup." 
 
 ### Restoring the separated patching files
 
In order to be able to patch the @product@ again, first you need to restore the
separated patching artifact. To do this you only need to place the 
`liferay-patching-files-<separation-name>.zip` back to the
Patching Tool's `patches` folder and run `patching-tool setup` command.

If the setup command finds the necessary patching artifact for the @product@
it restores the patching files to the bundle. Once it's done you can use the
Patching Tool's functions on the @product@ again.