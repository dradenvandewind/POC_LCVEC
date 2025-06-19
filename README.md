# POC_LCVEC
build test for try it

gst-inspect-1.0 | grep lcevcdecoder 
lcevcdecoder:  lcevcdec: LCEVC Decoder
lcevcdecoder:  lcevch264decodebin: H264 Lcevc Decode Bin


 gst-inspect-1.0 lcevcdec    
Factory Details:
  Rank                     marginal (64)
  Long-name                LCEVC Decoder
  Klass                    Codec/Decoder/Video
  Description              Enhances video frames using attached LCEVC metadata
  Author                   Julian Bouzas <julian.bouzas@collabora.com>
  Documentation            https://gstreamer.freedesktop.org/documentation/lcevcdecoder/lcevcdec.html

Plugin Details:
  Name                     lcevcdecoder
  Description              LCEVC decoder
  Filename                 /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstlcevcdecoder.so
  Version                  1.26.2
  License                  LGPL
  Source module            gst-plugins-bad
  Documentation            https://gstreamer.freedesktop.org/documentation/lcevcdecoder/
  Source release date      2025-05-29
  Binary package           GStreamer Bad Plug-ins source release
  Origin URL               Unknown package origin

GObject
 +----GInitiallyUnowned
       +----GstObject
             +----GstElement
                   +----GstVideoDecoder
                         +----GstLcevcDec

Element Flags:

Pad Templates:
  SINK template: 'sink'
    Availability: Always
    Capabilities:
      video/x-raw
                 format: { (string)I420, (string)NV12 }
                  width: [ 1, 2147483647 ]
                 height: [ 1, 2147483647 ]
              framerate: [ 0/1, 2147483647/1 ]
  
  SRC template: 'src'
    Availability: Always
    Capabilities:
      video/x-raw
                 format: { (string)I420, (string)NV12 }
                  width: [ 1, 2147483647 ]
                 height: [ 1, 2147483647 ]
              framerate: [ 0/1, 2147483647/1 ]

Element has no clocking capabilities.
Element has no URI handling capabilities.

Pads:
  SINK: 'sink'
    Pad Template: 'sink'
  SRC: 'src'
    Pad Template: 'src'

Element Properties:

  automatic-request-sync-point-flags: Flags to use when automatically requesting sync points
                        flags: readable, writable
                        Flags "GstVideoDecoderRequestSyncPointFlags" Default: 0x00000003, "corrupt-output+discard-input"
                           (0x00000001): discard-input    - GST_VIDEO_DECODER_REQUEST_SYNC_POINT_DISCARD_INPUT
                           (0x00000002): corrupt-output   - GST_VIDEO_DECODER_REQUEST_SYNC_POINT_CORRUPT_OUTPUT
  
  automatic-request-sync-points: Automatically request sync points when it would be useful
                        flags: readable, writable
                        Boolean. Default: false
  
  discard-corrupted-frames: Discard frames marked as corrupted instead of outputting them
                        flags: readable, writable
                        Boolean. Default: false
  
  max-errors          : Max consecutive decoder errors before returning flow error
                        flags: readable, writable
                        Integer. Range: -1 - 2147483647 Default: -1 
  
  max-height          : The maximum height for the LCEVC decoder (0 = default)
                        flags: readable, writable
                        Integer. Range: 0 - 2147483647 Default: 2160 
  
  max-latency         : The maximum latency in frames for the LCEVC decoder (0 = default)
                        flags: readable, writable
                        Integer. Range: 0 - 2147483647 Default: 0 
  
  max-width           : The maximum width for the LCEVC decoder (0 = default)
                        flags: readable, writable
                        Integer. Range: 0 - 2147483647 Default: 3840 
  
  min-force-key-unit-interval: Minimum interval between force-keyunit requests in nanoseconds
                        flags: readable, writable
                        Unsigned Integer64. Range: 0 - 18446744073709551615 Default: 0 
  
  name                : The name of the object
                        flags: readable, writable
                        String. Default: "lcevcdec0"
  
  parent              : The parent of the object
                        flags: readable, writable
                        Object of type "GstObject"
  
  qos                 : Handle Quality-of-Service events from downstream
                        flags: readable, writable
                        Boolean. Default: true
  
  verbose             : Output status information of the LCEVC Decoder SDK
                        flags: readable, writable
                        Boolean. Default: false
  

