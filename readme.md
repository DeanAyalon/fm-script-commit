# What is this?
This project was created as a way to assist version control in FileMaker<br>
Currently, it is meant to be used a reference for implementation within individual solutions. [When possible][#2], it will evolve to manage projects as an external tool

## FileMaker VERSION CONTROL??
Well yes, and no.<br>
FileMaker has very basic version control - It allows saving "clones", design-only data-less copies of solutions; and it allows migration from a live source file to a clone.<br>
Using Git LFS, some version control is possible; still, it leaves much to be desired.

Some FileMaker Version Control systems have worked on XML analysis of FileMaker DDRs, and are implementing diff-viewing, which is great, but it is still under development, and is a diamond-in-the-rough

In the meantime, I want to be able to simply commit the scripts as text into my Git project, to be able to efficiently analyze differences between commits, branches, etc.<br>
This project was created to assist with that - the vision is to be able to simply press a single button to have all scripts generated within the project's `scripts` directory automatically, along with the FileMaker solution's clone, maybe even automatically committed and pushed if provided with a message.

This project will version-control itself, and the rest of my FileMaker solutions, so I will be interacting with it almost daily

## Current Workflow
The `Save Clone` script (cmd-alt-C) is used for version control with use of FileMakerDataMigrationTool. 
> FileMaker clone files should be committed as Git-LFS objects

The current version also allows copying multiple scripts from the side menu and then running the `Commit Scripts` script (cmd-alt-S/X) to automatically commit script text and optionally XML into the designated scripts directory.<br>
Within the scripts directory, the solution searches for a file named after the script being committed, and replaces it with the updated version. If no file is found, `{scripts}/tmp/` is used.
> Requires [MBS Plugin](#optional-requirements)

## Limitations
- Scripts cannot share a name with other scripts or script directories
- Currently works on MacOS only
- When multiple FileMaker solutions are open, the wrong Script Workspace would open, avoid that for now. (See [#4][#4])
- Most functionality requires a license for the MBS plugin

## Optional Requirements
The `Commit Script` script uses the [MonkeyBreakSoftware][mbs] plugin, it is not usable without a license.<br>
The license allows lifetime access to all MBS versions up to 1 year after purchase, and can be extended for half price per additional year.

Minimum MBS version required: `v10.1`
> `v15.4` makes interactions with FileMaker XML objects much simpler, quite amazing to work with!

## Submodule?
This repository uses a [submodule][azure] to store its LFS files, this is unrelated to the project itself and is not required, I have simply chosen to design my project that way, as GitHub allows unlimited repository storage, while Azure allows unlimited LFS storage (or ≤250GB).
> Essentially, the only real file of interest to you would be `lfs/script-commit.fmp12`, you can find it in the [releases][releases] page as well. As the project version-controls itself, you can also find the [scripts](scripts) in text/xml format

# License
This project is licensed under the Apache License, Version 2.0<br>
You may use, modify, and distribute this file under the terms of that license.<br>
Please retain this notice and give appropriate credit.

# Contact
For any questions or assistance, please [open an issue][issues].<br>
For private communications, you can reach me at dev@deanayalon.com


<!-- Links -->
[#2]: https://github.com/deanayalon/fm-script-commit/issues/2
[#4]: https://github.com/deanayalon/fm-script-commit/issues/4
[mbs]: https://www.monkeybreadsoftware.com/filemaker
[azure]: https://deanayalon.visualstudio.com/_git/Filemaker%20Script%20Commit
[releases]: https://github.com/deanayalon/fm-script-commit/releases
[issues]: https://github.com/deanayalon/fm-script-commit/issues
