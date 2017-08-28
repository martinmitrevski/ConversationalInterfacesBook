//
//  ViewController.swift
//  SpeechPlayground
//
//  Created by Martin Mitrevski on 02/03/17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate, UITableViewDataSource {
    
    @IBOutlet private var recordingButton: UIButton!
    @IBOutlet private var recognizedText: UITextView!
    @IBOutlet private var productsTableView: UITableView!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer! =
        SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var products: Set<String> = Set<String>()
    private var addedProducts: [String] = [String]()
    private var sessionProducts: [String] = [String]()
    private var deletedProducts: [String] = [String]()
    private var removalWords: Set<String> = Set<String>()
    private var stoppingWords: Set<String> = Set<String>()
    private var cancelCalled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProducts()
        setupRemovalWords()
        setupStoppingWords()
        checkPermissions()
        speechRecognizer.delegate = self
    }

    func checkPermissions() {
        var message: String? = nil
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .denied:
                message = "Please enable access to speech recognition."
            case .restricted:
                message = "Speech recognition not available on this device."
            case .notDetermined:
                message = "Speech recognition is still not authorized."
            default: break
            }
            
            OperationQueue.main.addOperation() {
                self.recordingButton.isEnabled = authStatus == .authorized
                if message != nil {
                    self.showAlert(title: "Permissions error", message: message!)
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: "Permissions error",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAudioError() {
        let errorTitle = "Audio Error"
        let errorMessage = "Recording is not possible at the moment."
        self.showAlert(title: errorTitle, message: errorMessage)
    }
    
    @IBAction func startRecording(sender: UIButton) {
        handleRecordingStateChange()
    }
    
    func handleRecordingStateChange() {
        if audioEngine.isRunning {
            self.recognizedText.text = ""
            updateProducts()
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordingButton.isEnabled = false
            recordingButton.setTitle("Start Recording", for: .normal)
        } else {
            cancelCalled = false
            checkExistingRecognitionTask()
            startAudioSession()
            createRecognitionRequest()
            startRecording()
            recordingButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    func updateProducts() {
        var tmp = addedProducts
        tmp.append(contentsOf: sessionProducts)
        addedProducts = [String]()
        for product in tmp {
            if !deletedProducts.contains(product) {
                addedProducts.append(product)
            }
        }
        self.productsTableView.reloadData()
    }
    
    func startRecording() {
        guard let inputNode = audioEngine.inputNode else {
            showAudioError()
            return
        }
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!,
                                                           resultHandler:{
                                                            [unowned self] (result, error) in
            
            var recognized: String?
            self.createProductsArraysForSession()
            if result != nil {
                var shouldDelete = false
                recognized = result?.bestTranscription.formattedString
                for segment in (result?.bestTranscription.segments)! {
                    let text = segment.substring.lowercased()
                    if self.removalWords.contains(text) {
                        shouldDelete = true
                    }
                    if self.checkStoppingWords(text: text) == true {
                        return
                    }
                    if self.products.contains(text) {
                        if (shouldDelete == false) {
                            self.sessionProducts.append(text)
                        } else {
                            self.deletedProducts.append(text)
                        }
                        shouldDelete = false
                    }
                }
                self.recognizedText.text = recognized
            }
            
            var finishedRecording = false
            if result != nil {
                finishedRecording = result!.isFinal
            }
            if error != nil || finishedRecording {
                inputNode.removeTap(onBus: 0)
                self.handleFinishedRecording()
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            [unowned self] (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        startAudioEngine()
    }
    
    func createProductsArraysForSession() {
        self.sessionProducts = [String]()
        self.deletedProducts = [String]()
    }
    
    func startAudioEngine() {
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            showAudioError()
        }
    }
    
    func handleFinishedRecording() {
        self.audioEngine.stop()
        
        self.recognitionRequest = nil
        self.recognitionTask = nil
        
        self.recordingButton.isEnabled = true
    }
    
    func checkStoppingWords(text: String) -> Bool {
        if self.stoppingWords.contains(text) {
            if self.cancelCalled == false {
                self.handleRecordingStateChange()
                self.cancelCalled = true
                return true
            }
        }
        
        return false
    }
    
    func checkExistingRecognitionTask() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
    }
    
    func startAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            showAudioError()
        }
    }
    
    func createRecognitionRequest() {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordingButton.isEnabled = true
        } else {
            recordingButton.isEnabled = false
        }
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ProductCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ProductCell")
        }
        
        cell?.textLabel?.text = addedProducts[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedProducts.count
    }
    
    // helpers
    func setupRemovalWords() {
        removalWords = SpeechHelper.removalWords()
    }
    
    func setupStoppingWords() {
        stoppingWords = SpeechHelper.stoppingWords()
    }
    
    func loadProducts() {
        products = SpeechHelper.loadProducts()
    }
    
}

