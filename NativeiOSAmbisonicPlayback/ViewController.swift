//
//  ViewController.swift
//  NativeiOSAmbisonicPlayback
//
//  Created by Robert Coomber on 11/11/21.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    
    @IBOutlet var playButton: UIButton!
    let scene = Scene()
    @IBOutlet var SKView: SCNView!
    let ambisonicPlayback = AmbisonicPlayback()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializes the Audio Playback and 3D Renderer
        ambisonicPlayback.StartEngine()
        
        // Attatch 3D Scene
        scene.loadScene(sceneView: SKView)
        
        
        // Button event to change text if playing or paused
        Events.updatePlayingStatus.addHandler(handler:{a in self.playButton.setTitle(a ? "Stop Ambisonic File" : "Play Ambisonic File", for: .normal)})
    }
    
    // Toggles playing the ambisonic file
    @IBAction func toggleButtonPressed(_ sender: Any) {
        ambisonicPlayback.TogglePlay()
    }
}
