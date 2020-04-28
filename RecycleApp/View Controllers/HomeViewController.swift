import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var Logo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        saveButtonHideOrNot()
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
//
//    @IBAction func savePhoto(_ sender: UIButton) {
//
//        guard let imagePicked = imageView.image else { return }
//        let imageData = UIImageJPEGRepresentation(imagePicked, 0.6)
//
//        guard let unwrappedImageData = imageData else { return }
//        let compressedJPGImage = UIImage(data: unwrappedImageData)
//
//        guard let unwrappedCompressedJPGImage = compressedJPGImage else { return }
//        UIImageWriteToSavedPhotosAlbum(unwrappedCompressedJPGImage, nil, nil, nil)
//
//
//        let alert = UIAlertController(title: "Saved!", message: "Your photo has been saved to your phot albums.", preferredStyle: .alert)
//        let greatAction = UIAlertAction(title: "Great!", style: .cancel, handler: nil)
//        alert.addAction(greatAction)
//
//        present(alert, animated: true, completion: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        dismiss(animated: true, completion: nil)
        
        self.Logo.alpha = 0
        
        
        
        
        
//        saveButtonHideOrNot()
    }
    
//    func saveButtonHideOrNot() {
//        if imageView.image == nil {
//            saveButton.isHidden = true
//        } else {
//            saveButton.isHidden = false
//        }
//    }
    


}

