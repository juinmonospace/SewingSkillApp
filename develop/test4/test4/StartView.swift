//
//  ContentView.swift
//  test5
//
//  Created by Judith on 06.06.23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilter
import CoreImage.CIFilterBuiltins

struct StartView: View {
    @State private var inputImage: UIImage?
    @State public var image: Image?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @State private var showingCamera = false
    @State private var showingGallery = false
     
    @State var result: MainResult?
  
    var body: some View {
    
        
        NavigationStack{
            ZStack(alignment: .center){
                Color.pink.opacity(0.01)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    VStack{
                        HStack{
                            Text("Upload exercise").font(.custom("Montserrat", size:35))
                                .bold()
                            Spacer()
                        }
                        .padding([.top], 60)
                        HStack{
                            Text("results").font(.custom("Montserrat", size:35))
                                .bold()
                            Spacer()
                        }
                    }.padding([.leading], 30)
                    
                    if (self.result != nil){
                        Image(uiImage: self.result!.outputImage).resizable().scaledToFit()}
                    image?
                        .resizable()
                        .scaledToFit()
                        .border(Color.black, width: 3)
                        .padding()
                    
                    if image != nil
                    {
                        HStack{
                            Spacer()
                                NavigationLink(destination: UploadCompleteView(passedImage: image, inputImage: inputImage)) {
                                    HStack{
                                        Text("Confirm").font(.custom("Avenir Light", size:22)).bold()
                                        Image(systemName: "arrow.right.circle.fill").imageScale(.large)}
                                    .padding(18)
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(40)
                                }
                        }.padding()
                    }
                    else{
                        Spacer()
                        HStack{
                            Text("Open camera or choose photo from gallery to analyze your seams!").font(.custom("Montserrat", size: 24)).padding([.leading], 30)
                            Spacer()
                        }
                        Spacer()
                        Spacer()
                    }

                    Spacer()
                    HStack{
                        Spacer()
                        
                        // Open gallery
                        Button(action: {
                            self.showingGallery = true
                        }) {
                            Image(systemName: "photo.stack.fill")
                                .imageScale(.large)
                        }
                        .padding()
                        .tint(.black)
                    Spacer()
                        
                    // Open camera
                    Button(action: {
                        self.showingCamera = true
                    }){
                        Image(systemName: "camera.fill").imageScale(.large)
                            .padding().tint(.white)
                            .padding(6)
                            .background(Color.black.opacity(1))
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.black, lineWidth: 1.5)
                            )
                            .padding(3)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.black, lineWidth: 2))
                    }.padding(.bottom)
                    Spacer()
                    Spacer()
                    Spacer()

                }
                }.padding()
            }.background(Color(red: 253/255, green: 212/255, blue: 143/255).edgesIgnoringSafeArea(.all))
            }


        .sheet(isPresented: $showingCamera, onDismiss: loadImage) {
                ImagePicker(image: $inputImage, sourceType: .camera)
        }

        .sheet(isPresented: $showingGallery, onDismiss: loadImage) {
                ImagePicker(image: $inputImage, sourceType: .photoLibrary)
        }
        
        
    }

    
    //Call function on gallery/camera photo
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        processWithOpenCV(inputImage)
    }
    

   // Call desired Wrapper function to process selected image
    func processWithOpenCV(_ uiImage: UIImage){

        guard let outputImage =
                Wrapper.getImage(uiImage)
        else { return }

        self.image = Image(uiImage: outputImage)

    }
}

// Choose image to upload
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}



