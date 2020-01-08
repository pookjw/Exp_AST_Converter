//
//  ContentView.swift
//  Exp_AST_Converter
//
//  Created by pook on 1/5/20.
//  Copyright © 2020 pookjw. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var exp: String = "( 5 * 8 ) + ( ( ( ( 7 + 6 ) * 6 + 8 ) * 2 + 1 ) + 2 )"
    @State var result: String = ""
    @State var showAlert = false
    
    var alert: Alert {
        Alert(title: Text("Success!"), message: Text("Copied to clipboard!"), dismissButton: .default(Text("Dismiss")))
    }
    
    var navBarButton: some View {
        Button(action: {
            self.result = showDigraph(self.exp)
        }
        ){
            Text("Run")
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Expression...", text: $exp)
                    .border(Color.gray)
                    .padding(.all, 5.0)
                HStack{
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(Color.orange)
                    Text("Supports +, -, *, /, (, ) operators.")
                    Spacer()
                }
                .padding(.horizontal, 5.0)
                HStack{
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(Color.orange)
                    Text("Double number is not supported. (eg. 5 / 4 = 1)")
                    Spacer()
                }
                .padding(.horizontal, 5.0)
                HStack{
                    Image(systemName: "smiley.fill")
                        .foregroundColor(Color.blue)
                    Text("example: ( 3 * 8 ) + ( ( 7 * 2 ) + 8 )")
                    Button(action: {self.exp = "( 3 * 8 ) + ( ( 7 * 2 ) + 8 )"}){
                        Text("Fill this!")
                    }
                    Spacer()
                }
                .padding(.horizontal, 5.0)
                
                if ( exp.components(separatedBy: " ").filter {$0 == "("}.count == exp.components(separatedBy: " ").filter {$0 == ")"}.count ){
                    HStack{
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.green)
                        Text("No Parentheses Error! Good! (Maybe...)")
                        Spacer()
                    }
                    .padding(.horizontal, 5.0)
                }else{
                    HStack{
                        Image(systemName: "xmark.octagon.fill")
                            .foregroundColor(Color.red)
                        Text("Parentheses Error!")
                        Spacer()
                    }
                    .padding(.horizontal, 5.0)
                }
                Spacer()
                ScrollView{
                    Spacer()
                        .frame(height: 5)
                    HStack{
                        Spacer()
                            .frame(width: 7)
                        Text(result)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                    //.scaledToFill()
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.purple, lineWidth: 6)
                )
                    .padding(.all, 10.0)
                Button(action: {
                    UIPasteboard.general.string = self.result
                    self.showAlert.toggle()
                }
                ){
                    HStack{
                        Image(systemName: "doc.on.clipboard")
                        Text("Copy to clipboard!")
                    }
                }
            }
            .navigationBarTitle(Text("EAC"))
            .navigationBarItems(trailing: navBarButton)
        }
        .alert(isPresented: $showAlert, content: { self.alert })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
