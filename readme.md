# What is this?
This project was created as a way to assist version control in FileMaker

## FileMaker VERSION CONTROL??
Well yes, and no.
FileMaker has very basic version control - It allows saving "clones", design-only data-less copies of solutions; and it allows migration from a live source file to a clone.
Using Git LFS, some version control is possible; still, it leaves much to be desired.

Some FileMaker Version Control systems have worked on XML analysis of FileMaker DDRs, and are implementing diff-viewing, which is great, but it is still under development, and is a diamond-in-the-rough

In the meantime, I want to be able to simply commit the scripts as text into my Git project, to be able to efficiently analyze changes between different commits, branches, etc.
This project was created to assist with that - the vision is to be able to simply press a single button to have all scripts generated within the project's `scripts` directory automatically, along with the FileMaker solution's clone

## Submodule?
This repository uses a [submodule](https://deanayalon.visualstudio.com/_git/Filemaker%20Script%20Commit) to store its LFS files, this is unrelated to the project itself and is not required, I have simply chosen to design my project that way, as GitHub allows unlimited repository storage, while Azure allows unlimited LFS storage (or ≤250GB).
> Essentially, the only real file of interest to you would be `lfs/script-commit.fmp12`, you can find it in the [releases](https://github.com/deanayalon/fm-script-commit/releases) page as well

# License
This project is licensed under the Apache License, Version 2.0
You may use, modify, and distribute this file under the terms of that license.
Please retain this notice and give appropriate credit.

# Contact
For any questions or assistance, please open an issue. 
For private communications, you can reach me at dev@deanayalon.com
