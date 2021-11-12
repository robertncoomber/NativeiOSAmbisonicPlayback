# Native iOS Ambisonic Playback
This is a xCode project is an example of the quickest way to get ambisonic decoding working natively iOS audio. I was not able to find any examples like this when working with iOS and ambisonic playback so I am releasing this to hopefully help anyone else looking to play ambisonic files. 

## Project Overview 

### AmbisonicPlayback.swift
This is where the audio engine, environment, player node, bussing, and head rotation is being set up and controlled. 

### Scene.swift 
This is not necessary to get ambisonic playback working but I included it as it is a helpful tool to visualize the rotation of the binaural rendering orientation. 

### Prerequisite

This was made with Xcode 13.1, Swift 5.5.1.
I don't know if these are required but becuase ambisonic playback is somewhat recent, I would recommend using up to date tools.

## Building
After updating your signing and capabilities settings, you can build this to the simulator or an actual iOS device. The UI should scale properly but we aware that it might not scale properly for every device. 

## Known Issues
You will notice that the ambisonic node volume is being set to 1 as it’s being played, and set to 0 as its being paused. This is due to a bug that is causing an unexpected sound. This sound appears to be a single buffer loop that is being played over and over again depending on the last buffer. Kinda sounds like a square / saw wave depending on when it was stopped. Uncomment the lines with ambisonicNode.volume if you would like to hear for yourself. Please let me know if you know how to fix this. 
