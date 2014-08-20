#!/bin/bash

# script to pull images from http://reddit.com/r/EarthPorn+CityPorn+SpacePorn+WaterPorn and store them locally
# to be used for random desktop and screensaver images.
# Lots to do but it works-ish - YMMV. 
# uses stuff you should have on os x if you have developer tools I think. tidy, grep, egrep, cut, curl, sips, bc

# Put this in a directory somewhere and setup crontab to run once a day
# chmod +x rEarthPornBackgroundr.sh
# To run it at 6 am every day, and send no output emails
# 0 6 * * * /path/to/rEarthPornBackgrounder.sh > /dev/null 2>&1 

# Path to desktop image directory as specified in Desktop & Screensaver system preferences
desktopImgDirectory="/path/to/desktop/images/folder"

# lots of hard coded stuff here; gets a list of image URLS in a not so configurable way
# Get's latest 100 hot posts from r/EarthPorn, r/CityPorn, r/SpacePorn, and r/WaterPorn
# passes output from curl to tidy, looks for hrefs, then looks for image hosting service provider
# url's, i.imgur.com, 500px.org, nasa.gov, cuts some fields, then some more, then finally any GET
# parameters at the end of the filename.

# TODO make this more configurable, including an array of image service providers
# TODO Add file name matching instead of field cutting to identify image URLs
# TODO supress curl output in the script

imageUrls=`curl -S -s "http://www.reddit.com/r/EarthPorn+CityPorn+SpacePorn+WaterPorn/hot.xml?limit=100" 2>/dev/null | tidy -xml -q -raw | grep href | egrep 'i.imgur.com|ppcdn.500px.org|www.nasa.gov' | cut -f 2 -d ';' | cut -f 1 -d '&' | cut -f 1 -d '?'`


# CD to download directory and store it for later
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Iterate through the image URLs and process them, determine which ones to keep and which ones to delete
for fileURL in $imageUrls; 
do 
    # create MD5 hash of fileURL for fileName; some services use the same filename but different path. Like 500px
    fileName=`md5 -q -s $fileURL`".jpg"

    # download file
    echo "Downloading: " $fileURL
    curl $fileURL -o $fileName
    
    # grab image dimensions and calculate aspect ratio
    imageHeight=`sips -g pixelHeight $fileName | tail -1 | cut -f 4 -d ' '`
    imageWidth=`sips -g pixelWidth $fileName | tail -1 | cut -f 4 -d ' '`
    aspectRatio=`echo "scale=2; $imageWidth / $imageHeight" | bc`
    echo $fileName" ar: "$aspectRatio" width: "$imageWidth" height: "$imageHeight
    
    # delete image if it's below our standards...hard coded
    # if the width of the image is less than or equal to 1900px delete it
    if [ $imageWidth -le 1900 ]
    then
        echo $fileName "is junk....deletion immiment. Too small."
        rm "${fileName}"
    
    # If the aspect ratio is less than 1.3 (1.78 is 16:9), delete it    
    elif (( $(bc <<< "$aspectRatio < 1.3") == 1 ))
    then 
        echo $fileName "is junk...deletion immiment. Bad Aspect Ratio."
        rm "${fileName}"

    # Looks good, copy it to the desktop image directory and delete the downloaded file
    else
        echo $fileName "looks great!"
        
        # TODO need to check if the directory exists before trying to copy
        # copy file to desktop pictures directory
        cp ./"${fileName}" "${desktopImgDirectory}"

        # delete file
        rm "${fileName}"
    fi
done

# kill the dock so it reloads the images into it's internal array; otherwise the new images won't be used until logoff/restart
# TODO there is probably a nicer way to do this...

killall -KILL Dock
