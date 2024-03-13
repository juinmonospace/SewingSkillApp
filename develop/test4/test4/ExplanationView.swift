//
//  ExplanationView.swift
//  test4
//
//  Created by Judith on 28.10.23.
//

import SwiftUI

struct ExplanationView: View {
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Replication Accuracy").font(.custom("Montserrat", size: 35)).bold().padding()
                    Spacer()
                }
                HStack{
                    VStack{
                        Text("The replication accuracy gives back the percentage of how well the matched seam overlaps with the guide line.").font(.custom("Montserrat", size: 20))
                        Text("A high percentage indicates a seam similar in shape and size with the guide line with accurate parallel sewing.").font(.custom("Montserrat", size: 20))
                    }.padding()
                }
                HStack{
                    Text("Distance Consistency").font(.custom("Montserrat", size: 35)).bold().padding()
                    Spacer()
                }
                HStack{
                    VStack{
                        Text("The distance consistency computes the standard deviation of the sewn distance in mm.").font(.custom("Montserrat", size: 20))
                        Text("A low number reflects a consistent distance kept to the guide line.").font(.custom("Montserrat", size: 20))
                    }.padding()
                }
            }
            
        }
        .background(Color(red: 253/255, green: 212/255, blue: 143/255)
        .edgesIgnoringSafeArea(.all))
    }
}

struct ExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationView()
    }
}
