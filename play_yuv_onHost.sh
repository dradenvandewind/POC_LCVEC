gst-launch-1.0 filesrc location=$1 ! videoparse width=352 height=288 format=i420 framerate=30/1 ! autovideosink
