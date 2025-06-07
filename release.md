# MBS Limitations
`ScriptWorkspace.ScriptPaths` can be iterated but:
1. Contains directories, with no indication (Might be better to output `dir/dir/script` or `dir/dir/`, though script name may contain `/`)
2. `ScriptWorkspace.OpenScript` returns `OK` when failing after having been given a directory name

There are ways to work around these but they are complex and will not solve all issues:
- Duplicate script/directory names
- Empty directories (Can't check next line to see if current line is a directory)

These need to be addressed by MBS before development can continue
