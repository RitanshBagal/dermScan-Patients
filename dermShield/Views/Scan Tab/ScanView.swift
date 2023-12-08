import SwiftUI
import CoreML
import Vision

// body
struct ScanView: View {
    
    @State private var selectedImage: UIImage?
    @State private var detectedObjects: [(String, Float)] = []
    @State private var isImagePickerPresented = false
    @State private var showingResult = false
    
    
    var body: some View {
        NavigationView{
            ZStack {
                Color("BgColor").edgesIgnoringSafeArea(.all)
                VStack {
                    
                    Text("Please choose the following option.")
                        .frame(maxWidth: 360, alignment: .leading)
                        .padding(.top)
                        .padding(.bottom, 5)
                        .navigationTitle("Scan")
                        .navigationBarItems(trailing:
                                                NavigationLink(destination: ProfileCompletedView(), label: {
                            Image(systemName: "person.crop.circle")
                                .font(.title3)
                                .foregroundColor(Color("PrimaryColor"))
                        }))
                    
                    VStack() {
                        Image("analysisOne")
                            .resizable()
                            .frame(width: 330, height: 160)
                            .cornerRadius(20.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20.0)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .padding(.top)
                            .padding(.trailing)
                            .padding(.leading)
                        
                        Text("Analysis")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(maxWidth: 330, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 6)
                        
                        Text("Select a clear image of the impacted area, receive instant diagnosis, and easily share your symptoms with your doctor for seamless consultation.")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .frame(maxWidth: 330, alignment: .leading)
                            .padding(.horizontal)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                isImagePickerPresented = true
                            }) {
                                Text("Start")
                                    .padding(.horizontal, 25)
                                    .padding(.vertical, 10)
                                    .background(Color("PrimaryColor"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            .sheet(isPresented: $isImagePickerPresented, onDismiss: {
                                // Handle the selected image
                                if selectedImage != nil {
                                    // Save the image or perform any necessary actions
                                    showingResult = true
                                    
                                    // image sent to the ML model to fetch the results
                                    detectObjectsInImage(selectedImage!)
                                    // end to ML model request sent
                                }
                            }) {
                                ImagePicker(selectedImage: self.$selectedImage)
                            }
                            .background(
                                NavigationLink(destination: ResultView(selectedImage: selectedImage ?? UIImage(), detectedObjects: detectedObjects).toolbar(.hidden, for: .tabBar), isActive: $showingResult) {
                                    EmptyView()
                                }
                            )
                        }
                        .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(20.0)
                    .padding([.leading, .trailing])
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                    Spacer()
                }
            }
        }
    }
    func detectObjectsInImage(_ image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            print("Unable to create CIImage from UIImage")
            return
        }
        
        do {
            let model = try VNCoreMLModel(for: dermTest().model)
            let request = VNCoreMLRequest(model: model) { request, error in
                guard let results = request.results as? [VNRecognizedObjectObservation] else {
                    print("Failed to perform object detection:", error ?? "Unknown error")
                    return
                }
                
                var uniqueObjects: [String: Float] = [:]
                
                for observation in results {
                    guard let objectLabel = observation.labels.first?.identifier else { continue }
                    let precision = observation.confidence
                    
                    if uniqueObjects[objectLabel] == nil {
                        uniqueObjects[objectLabel] = precision
                    }
                }
                
                let objects = uniqueObjects.sorted(by: { $0.key < $1.key })
                
                DispatchQueue.main.async {
                    self.detectedObjects = objects
                    self.showingResult = true // Navigate to ResultView
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            try handler.perform([request])
        } catch {
            print("Failed to load Core ML model:", error)
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


#Preview {
    ScanView()
}
