rEarthPornBackgroundr
=====================

Mac OS X script to download hi-res images from various subreddits and store them in a folder for use in random Desktop &amp; Screensaver system preference backgrounds

Overview
-----------

1. Downloads hi-res* files from a set of sub-reddits. Uses several built in command line tools from Mac OS X Developer tools including: curl, tidy, sips, cut, egrep, cp

2. There is a lot that can be done to clean this up and make it a little more robust and configurable but it should do the job.


Contributing
------------
Feel free to fork and send pull requests. I just hacked this together out of frustration as I could find no tool to do the exact job.


Use
---------
1. Open the Terminal.app
2. Change to a directory where you'll store the script. `cd /path/to/project` if it doesn't exist you can `mkdir -p /path/to/project`
3. Clone the repo with `git clone https://github.com/dwstevens/rEarthPornBackgroundr.git`. This will create a directory called rEarthPornBackgroundr in the path you created/changed to in step 2.
4. Open the rEarthPornBackgroundr.sh script (e.g., `nano rEarthPornBackgroundr.sh` and modify the `desktopImgDirectory` variable. This should be the directory you specify in the Desktop & Screensaver system preference panel. Save the file, if using nano, control-x will do the job.
5. After saving the file, you may have to modify the exec flag on the file so that it can be run via a simple `/path/to/project/rEarthPornBackgroundr.sh` otherwise you have to run it with a bash prefix `/bin/bash /path/to/project/rEarthPornBackgroundr.sh` which ain't so bad? 
6. Run the file via `./rEarthPornBackgroundr.sh`, which assumes you are still in the directory with that file in it. Otherwise you either need to `cd /path/to/project/rEarthPornBackgroundr` or `/path/to/project/rEarthPornBackgroundr/rEarthPornBackgroundr.sh`
7. You will see a bunch of output, and if everything went ok, you'll have a bunch of new images in your designated desktop images folder. 




