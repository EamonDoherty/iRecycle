import CoreML
import UIKit


class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var predictionText: UILabel!
    @IBOutlet weak var infoText: UITextField!
    @IBOutlet weak var predictionInfoText: UILabel!
    @IBOutlet weak var CameraBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    
    var model:recycleMaterial!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.predictionText.alpha = 0
        self.tryAgainBtn.alpha = 0
        self.shareBtn.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
          model = recycleMaterial()
    }
        
    @IBAction func camera(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func cameraRoll(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func socialShareBtn(_ sender: Any) {
        //screen shot
        UIGraphicsBeginImageContext(self.view.bounds.size)
        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let screenImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
//        let text = "Hey, check out this app iRecycle"
        
        
        //sharing
        var imagesToShare = [AnyObject]()
        
        imagesToShare.append(screenImage as AnyObject)

        let activityViewController = UIActivityViewController(activityItems: imagesToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        dismiss(animated: true, completion: nil)
        
        self.Logo.alpha = 0
        self.infoText.alpha = 0
        self.CameraBtn.alpha = 0
        self.photoBtn.alpha = 0
        self.predictionText.alpha = 1
        self.tryAgainBtn.alpha = 1
        self.shareBtn.alpha = 1
        
        //Resize image
        //convert the image size
        UIGraphicsBeginImageContextWithOptions (CGSize(width: 224, height: 224), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 224, height: 224))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Holds the image in the form of a pixel buffer
        let attrs = [kCVPixelBufferCGImageCompatibilityKey:kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height),kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        
        guard (status == kCVReturnSuccess) else {
         return
        }
        
        //convert to RGB COLOUR SPACE
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        //Store the data in pixel data
        let context = CGContext(data: pixelData, width:  Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        //Scale the images to iPhone requirements
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        //Update image buffer
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        
        //predict image label
        guard let prediction = try? model.prediction(image: pixelBuffer!) else {
              predictionText.text = "Can't Predict!"
              return
        }
                
        predictionText.text = "Recycle material:  \(prediction.label)"
        print("\(prediction.labelProbability)")
        
        if prediction.label == "plastic" {
            predictionInfoText.text = "Black bin"
            print("Black bin")
        }
        else if  prediction.label == "metal" {
            predictionInfoText.text = "Green bin"
            print("Green Bin")
        }
        
        else if  prediction.label == "paper" {
            predictionInfoText.text = "Green bin"
            print("Green Bin")
        }
        else if  prediction.label == "glass" {
            predictionInfoText.text = "This should be brought to the nearest bottle bank"
            print("Bottle bank")
        }
        else {
            print("Try again")
            predictionInfoText.text = "Try again"
        }
        
    }
    
    
    
}

