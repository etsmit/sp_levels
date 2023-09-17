# sp_levels
 Unpacked level scripts and map data for Titanfall 2's single player campaign


Level scripts are written in [Squirrel](https://noskill.gitbook.io/titanfall2/documentation/file-format/nut-and-gnut-squirrel) and take the file type ".nut", ".gnut".

# How to find what you're looking for

##### Looking for level scripts?

Go to the directory for the level you're interested in, then follow the path:  scripts/ -> vscripts/

This folder contains a bunch of general functions that apply to the game as whole. To get to the specific level scripts, continue on to the "sp/" directory. At the bottom of this directory, you should see a file "sp_[levelname].nut" - this is the main script file for the level. You may see another file with the name "sp_[levelname]_utility.nut" - this holds some more useful functions for the main script.

If you DON'T see these files, they will be in the next folder down in "hubs/" - usually because this is a map that gets revisited, like EnC1+EnC3.

The file "sh_sp_[levelname].nut" will list out all of the dialogue that plays in the level.

In each main script file, after listing out precaching resources and initializing flags, there will be a list of "StartPoints". These more or less define player progress through the level. The second argument in each of these function calls is the actual setup function to refer to for each sequence in the level, and serves as a start point (heh) for you to understand whats going on. Inside each of these startpoint setups, the scripts may call simultaneous threaded functions to run, wait for flags/triggers to be hit, or play dialogue, among many other things.


##### Looking for map data?

The blender files for each map are in the zipped folder in each level directory. Simply extract and you are good to go!

The ".ent" files in the "maps" directories list out every map geo and trigger object - "[levelname]_script.ent" may be particularly useful to double-check triggers called in your level script against what you see in blender.


##### Want to do this yourself?

I have instructions to extract the vpk's and import the maps into blender [here](https://docs.google.com/document/d/1UGnmYNVHER23qnDqRhvLxgJvm06f9pkj6BJIOyFRtCk/edit?usp=sharing).


Any questions? You may ping me in the TF2SR discord (SpectralSmitty)
