//
//  UploadCompleteView.swift
//  test4
//
//  Created by Judith on 11.09.23.
//

import SwiftUI

// View after image is chosen, continue button clicked
struct UploadCompleteView:View {
    let passedImage: Image?
    let inputImage: UIImage?

    @State private var showingPrcossedImage = false
    @State var result: MainResult?
    @State var resultImage: UIImage?
    @State var replicationAccuracy: Double?
    @State var distanceCon: Double?
    

    var body: some View {
        VStack {
            VStack{
                Spacer()
                HStack{
                    Text("Upload").font(.custom("Montserrat", size: 35)
                        .bold())
                    Spacer()
                }.padding([.top])
                HStack{
                    Text("completed").font(.custom("Montserrat", size: 35)
                        .bold())
                    Image(systemName:"checkmark.circle.fill").imageScale(.large)
                    Spacer()
                }.padding([.trailing])
                Spacer()
                
                if (resultImage != nil){
                    Image(uiImage: resultImage!)
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(Angle(degrees: 90))
                    // .border(Color.black, width: 3)
                        .padding(13)
                }

                Spacer()
                Spacer()
            }
            Spacer()
            .onAppear(){
                self.result = Wrapper.main(self.inputImage!)
                self.resultImage = self.result!.outputImage
                self.replicationAccuracy = self.result!.replicationAccuracy
                self.distanceCon = self.result!.distanceConsistency
            }
            Spacer()
            HStack{
                Spacer()
                if (replicationAccuracy != nil && distanceCon != nil){
                    NavigationLink(destination: EvaluationView(passedImage: passedImage, passedOverlap: self.replicationAccuracy!, passedDistance: self.distanceCon!, resultImage: self.resultImage, inputImage: inputImage)){
                        HStack{
                            Text("Receive results").font(.custom("Avenir Light", size: 22)).bold()
                            Image(systemName: "arrow.right.circle.fill").imageScale(.large)
                        }.padding(18)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                    }
                }
            }
        }
        .padding()
        .background(Color(red: 253/255, green: 212/255, blue: 143/255).edgesIgnoringSafeArea(.all))
    }


}
