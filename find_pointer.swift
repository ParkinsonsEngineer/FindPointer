import Foundation

// Import the private SkyLight framework methods via C bindings
@_silgen_name("CGSMainConnectionID")
func CGSMainConnectionID() -> Int32

@_silgen_name("CGSGetCursorScale")
func CGSGetCursorScale(_ cid: Int32, _ scale: UnsafeMutablePointer<Float>) -> Int32

@_silgen_name("CGSSetCursorScale")
func CGSSetCursorScale(_ cid: Int32, _ scale: Float) -> Int32

func runPointerPulse() {
    let cid = CGSMainConnectionID()
    
    // 1. Fetch current cursor scale (default is 1.0, max is 4.0)
    var initialScale: Float = 1.0
    CGSGetCursorScale(cid, &initialScale)
    
    // 2. Define our animation constraints
    let minScale: Float = 1.0
    let maxScale: Float = 4.0
    
    // Calculate the amplitude and offset so it starts precisely at your current scale,
    // peaks at maximum size, dips to the minimum, and returns cleanly.
    let amplitude = (maxScale - minScale) / 2.0
    let midPoint = minScale + amplitude
    
    // Find where the current scale sits on our negative cosine curve to establish a phase shift
    let initialRatio = (initialScale - midPoint) / amplitude
    let clampedRatio = max(-1.0, min(1.0, initialRatio))
    let phaseShift = acos(-clampedRatio)
    
    let duration: Double = 10.0       // 5 cycles * 2 seconds = 10 seconds total
    let frequency = 4.0 * Double.pi / 2.0 // 2.0 seconds per cycle
    let fps = 60.0                   // Smooth 60 frames per second updates
    let timeStep = 1.0 / fps
    var elapsedTime = 0.0
    
    print("Pulsing mouse pointer... Press Ctrl+C to abort.")
    
    // 3. Animation loop using a high-precision timer
    let timer = Timer.scheduledTimer(withTimeInterval: timeStep, repeats: true) { timer in
        if elapsedTime >= duration {
            // Restore original setting precisely at 6.0 seconds
            _ = CGSSetCursorScale(cid, initialScale)
            timer.invalidate()
            print("Finished! Pointer restored to \(initialScale).")
            exit(0)
        }
        
        // Calculate current target scale using a phase-shifted negative cosine wave
        let angle = (frequency * elapsedTime) + Double(phaseShift)
        let currentTarget = midPoint - (amplitude * Float(cos(angle)))
        
        // Push the scale change to the system graphics server instantly
        _ = CGSSetCursorScale(cid, currentTarget)
        
        elapsedTime += timeStep
    }
    
    RunLoop.current.run()
}

runPointerPulse()
