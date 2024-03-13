//
//  EvaluationView.swift
//  test4
//
//  Created by Judith on 11.09.23.
//

import SwiftUI

// View after clicking "Receive results" button in UploadCompleteView
struct EvaluationView:View{
    
    let passedImage: Image?
    //let uiimage: UIImage?
    let passedOverlap: Double
    let passedDistance: Double
    let resultImage: UIImage?
    let inputImage: UIImage?

 
    
    var body: some View{
        ZStack{
            VStack{
                Spacer()
                Spacer()
                HStack{
                    Text("Your Results:").font(.custom("Montserrat", size: 35)).bold().padding()
                    Spacer()
                }.padding()
                    
                Spacer()
                    HStack{
                        VStack{
                            Spacer()
                            Text("original").font(.custom("Montserrat", size: 20))
                                .padding(10)
                                .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black.opacity(0.6), lineWidth: 3)
                                )
                            passedImage?
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .border(Color.black.opacity(0.6), width: 2)
                                .padding()
                        }.padding(28)
                        //Spacer()
                        VStack{
                            Spacer()
                            Text("matched").font(.custom("Montserrat", size: 20)).padding(10)
                                .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.green.opacity(0.6), lineWidth: 3)
                                )
                            Image(uiImage: resultImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .border(Color.green.opacity(0.6), width: 2)
                                .padding()
                        }.padding(28)
                    }
                //Spacer()
                VStack{
                    VStack{
                        HStack{
                            Spacer()
                            VStack{
                                Text("Replication")
                                    .font(.custom("Montserrat", size: 20))
                                    .padding(.leading)
                                Text("Accuracy")
                                    .font(.custom("Montserrat", size: 20))
                                    .padding(.leading)
                            }.padding(27)
                            Spacer()
                            Text(formatDecimal(passedOverlap)+" %")
                                .font(.custom("Montserrat", size: 20))
                                .padding(45)
                                .bold()
                            Spacer()
                        }
                        Spacer()
                        HStack{
                            Spacer()
                            VStack{
                                Text("Distance")
                                    .font(.custom("Montserrat", size: 20))
                                    .padding(.leading)
                                Text("Consistency")
                                    .font(.custom("Montserrat", size: 20))
                                    .padding(.leading)
                            }.padding(27)
                            Spacer()
                            Text(formatDecimal(passedDistance)+" mm")
                                .font(.custom("Montserrat", size: 20))
                                .padding(45)
                                .bold()
                            Spacer()
                        }
                        Spacer()
                    } //.border(Color.black, width: 2)
                }
                Spacer()
                HStack{
                    NavigationLink(destination: StartView()){
                        HStack{
                            Text("Redo task").font(.custom("Avenir Light", size: 20)).bold()
                            Image(systemName: "arrow.uturn.left.circle.fill").imageScale(.large)
                        }.padding(18)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                    }
                    NavigationLink(destination: ExplanationView()){
                        HStack{
                            Text("See explanation").font(.custom("Avenir Light", size: 18)).bold()
                            Image(systemName: "arrow.right.circle.fill").imageScale(.large)
                        }.padding(18)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                        
                    }
                    
                }
            }
        }
        .background(Color(red: 253/255, green: 212/255, blue: 143/255)
        .edgesIgnoringSafeArea(.all))

    }
    
    func formatDecimal(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
}

