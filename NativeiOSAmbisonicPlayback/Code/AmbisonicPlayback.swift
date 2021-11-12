//
//  AmbisonicPlayback.swift
//  NativeiOSAmbisonicPlayback
//
//  Created by Robert Coomber on 11/11/21.
//

import Foundation
import AVFAudio

class AmbisonicPlayback
{
    let engine: AVAudioEngine
    let environment: AVAudioEnvironmentNode
    let ambisonicNode: AVAudioPlayerNode
    
    init(){
        ambisonicNode = AVAudioPlayerNode()
        engine = AVAudioEngine()
        environment = AVAudioEnvironmentNode()
        
        // sets the UpdateRotation function to listen to when the Scene rotation changes
        Events.updateRotationValue.addHandler(handler:{a in self.updateRotation(rot: a)})
    }
    
    public func StartEngine(){
        do {
            // get url
            guard let ambisonicFileURL = Bundle.main.url(forResource: "AmbixMetronome", withExtension: "caf")
            else{
                print("Issue Locating File")
                return
            }
            
            
            // Set channel layout objects
            let AmbisonicLayout = AVAudioChannelLayout(layoutTag:kAudioChannelLayoutTag_Ambisonic_B_Format)
            let StereoLayout = AVAudioChannelLayout(layoutTag: kAudioChannelLayoutTag_Stereo)
            
            
            // Sets data for how to process the audio files
            let format3D = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 41100, interleaved: false, channelLayout: (AmbisonicLayout)!)
            let format2D = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 41100, interleaved: false, channelLayout: (StereoLayout)!)
            
            
            // Set up the engine / environment
            engine.attach(environment)
            engine.connect(environment, to: engine.outputNode, format: format2D)
            engine.attach(ambisonicNode)
            engine.connect(ambisonicNode, to: environment, format: format3D)
            environment.renderingAlgorithm = .auto
            try engine.start()

            
            // Load file to File object
            let file : AVAudioFile = try! AVAudioFile(forReading: ambisonicFileURL)
            
            
            // Create the buffer
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format3D, frameCapacity: UInt32(file.length)) else { print("issue with buffer")
                return }
            try! file.read(into: buffer)
            
            
            // Scheudule the node to teh buffer.
            ambisonicNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
            
            
            // Set up the Ambisonic Node
            ambisonicNode.renderingAlgorithm = .auto
            ambisonicNode.sourceMode = .ambienceBed
            ambisonicNode.position.y = 1 // IMPORTANT needs to be Y axis
        }
        catch{
            print("Error")
        }
    }
    
    func TogglePlay(){
        if !ambisonicNode.isPlaying {
            // Play the Ambsinic Node
            
            ambisonicNode.volume = 1 // workaround for pause issue
            ambisonicNode.play()
            Events.updatePlayingStatus.raise(data: true)
        }
        else{
            // Pause Ambisonic Node
            
            ambisonicNode.volume = 0 // workaround for pause issue
            ambisonicNode.pause()
            Events.updatePlayingStatus.raise(data: false)
            return
        }
    }
    
    
    // Helper function to set rotation
    func updateRotation(rot: Float){
        environment.listenerAngularOrientation.yaw = rad2deg(rot)
    }
    
    
    // Helper Function to set rotation
    func rad2deg(_ number: Float) -> Float {
        return (number * 180 / .pi)
    }
}
