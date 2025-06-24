gst-launch-1.0 filesrc location=./akiyo_cif.y4m ! \
  y4mdec ! videoconvert ! \
  video/x-raw,width=352,height=288,format=I420 ! \
  identity silent=false ! fakesink sync=true
