rm -rf /tmp/
GST_DEBUG=xeveenc:5,xevddec:5 gst-launch-1.0 filesrc location=./akiyo_cif.y4m ! y4mdec ! videoconvert ! video/x-raw,width=352,height=288,format=I420 ! identity silent=false ! xeveenc ! capsfilter caps="video/x-lvc1" ! xevddec ! fakesink sync=true

