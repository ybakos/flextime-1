# FlexTime

TODO


# Development

## Updating JumpStart Pro

I wanted to preserve the commit original history of the flextime repo, so the
update instructions from JumpStart Pro don't quite work well for me. (Or do they? TODO: Try the technique from [the Upgrades documentation](https://jumpstartrails.com/docs/upgrading).)

To merge the latest changes to JumpStart Pro from upstream:

1) Notice the tag with the prefix *jumpstart-pro/*, and the following sha in the tag name. Copy the sha.
2) Switch to a local copy of [the fork](https://github.com/ybakos/jumpstart-pro.git) of the [jumpstart-pro repo](https://github.com/jumpstart-pro/jumpstart-pro.git), and execute `git log`. Confirm that the HEAD sha matches what you copied in **Step #1**.
3) In the local *jumpstart-pro* fork, do a `git pull upstream master`.
4) Execute `git format-patch SHA`, using the sha from **Step #1**.
7) Execute a `git log` and copy the new HEAD sha.
5) Move the generated patch files into your local _flex-time_ repo.
6) Now in the *flex-time* repo, check out the *jumpstart-pro* branch, and apply the patches via `git am *.patch`.
7) Create a new tag using the sha from **Step #7**, formatted like *jumpstart-pro/SHA*.
8) Delete the old *jumpstart-pro/OLDSHA* tag.
9) Check out the *develop* branch, and merge the new changes from the *jumpstart-pro* branch. In your merge commit message, please mention the sha from **Step #7**.




&copy; 2017, 2022 Yong Joseph Bakos. All rights reserved.
