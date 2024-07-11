# The DMV

This is the starter repo for the BE Mod1 DMV project.

Describe the steps you took to dig in to this code base. What was your process? If you don’t feel you had a process, define one that you might like to try next time.
- We had some tests to work with in this instance, so I started with running all the tests together and started from the first error that popped up. That took me to a specific class and class_spec to work with, and then briefly worked through what the tests were testing and that the class was accurately creating/arranging that data.
Not only did this give me a flow to work through all the files, but it verifies that the current condition is in a working state (after debugging it) and gives the data that the tests ask for.

What was hard about working with code you did not write?
- Following where the data goes and where it comes from. There was an interaction with facility and dmv that I didn't get right away (because I didn't reread my errors) that had me temporarily start creating multiple new methods that would potentially get the data only for my first test of those classed not changing the initial error message any. 

What was easier than you expected about jumping in to an unfamiliar codebase? What made it easy? If nothing felt easy, what would’ve helped you feel more comfortable more quickly?
- Having the tests and the classes set up in a standard way helped a great deal. With each class being organized and arranged in similar ways, it was a process of finding the common traits (attr_readers, initialize, def method?, etc.) to get the general concept before diving into the unique methods and data its working with.