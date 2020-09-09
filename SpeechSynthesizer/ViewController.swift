// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import Cocoa
import AudioKit

class ViewController: NSViewController {
    let engine = AKEngine()

    var speechSynthesizer = AKSpeechSynthesizer()

    @IBOutlet weak var textField: NSTextField!

    @IBOutlet weak var pitchSlider: NSSlider!
    @IBOutlet weak var rateSlider: NSSlider!
    @IBOutlet weak var modulationSlider: NSSlider!

    @IBOutlet weak var rateTextField: NSTextField!
    @IBOutlet weak var pitchTextField: NSTextField!
    @IBOutlet weak var modulationTextField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        let delay = AKDelay(speechSynthesizer)
        delay.time = 0.1
        delay.feedback = 70
        delay.dryWetMix = 30

        let reverb = AKReverb(delay)
        reverb.loadFactoryPreset(.cathedral)

        engine.output = reverb
        do {
            try engine.start()
        } catch {
            AKLog("AudioKit did not start!")
        }

        rateSlider.minValue = Double(speechSynthesizer.rate) / 2.0
        pitchSlider.minValue = Double(speechSynthesizer.frequency) / 2.0
        modulationSlider.minValue = 0

        rateSlider.maxValue = Double(speechSynthesizer.rate) * 2.0
        pitchSlider.maxValue = Double(speechSynthesizer.frequency) * 2.0
        modulationSlider.maxValue = Double(speechSynthesizer.modulation) * 2.0

        rateSlider.integerValue = speechSynthesizer.rate
        pitchSlider.integerValue = speechSynthesizer.frequency
        modulationSlider.integerValue = speechSynthesizer.modulation
        updateLabels()
    }

    @IBAction func slid(_ sender: NSSlider) {
        speechSynthesizer.rate = rateSlider.integerValue
        speechSynthesizer.frequency = pitchSlider.integerValue
        speechSynthesizer.modulation = modulationSlider.integerValue
        updateLabels()
    }

    func updateLabels() {
        rateTextField.stringValue = "Words Per Minute: \(speechSynthesizer.rate)"
        pitchTextField.stringValue = "Base Frequency \(speechSynthesizer.frequency)"
        modulationTextField.stringValue = "Modulation: \(speechSynthesizer.modulation)"
    }

    @IBAction func speak(_ sender: NSButton) {
        speechSynthesizer.say(text: textField.stringValue)
    }

    @IBAction func stop(_ sender: NSButton) {
        speechSynthesizer.stop()
    }

}
