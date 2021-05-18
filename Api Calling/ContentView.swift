//
//  ContentView.swift
//  Api Calling
//
//  Created by Student on 5/18/21.
//

import SwiftUI

struct ContentView: View {
    @State private var elements = [Element]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(elements) {element in
                NavigationLink(
                    destination: VStack {
                        Text(element.name)
                            .padding()
                        Text(element.symbol)
                            .padding()
                        Text(element.history)
                            .padding()
                        Text(element.facts)
                            .padding()
                    },
                    label: {
                        HStack {
                            Text(element.symbol)
                            Text(element.name)
                        }
                    })
            }
            .navigationTitle("Periodic Elements")
        }
        .onAppear(perform: {
            queryAPI()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("Ok")))
        })
    }
    
    func queryAPI() {
        let apiKey = "?rapidapi-key=0707fa5d6cmshc451d29c8c38c51p109c1fjsn18bb48cbef66"
        let query = "https://periodictable.p.rapidapi.com/\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                let contents = json.arrayValue
                for item in contents {
                    let name = item["name"].stringValue
                    let symbol = item["symbol"].stringValue
                    let facts = item["facts"].stringValue
                    let history = item["history"].stringValue
                    let element = Element(symbol: symbol, name: name, facts: facts, history: history)
                    elements.append(element)
                }
                return
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}

struct Element: Identifiable {
    let id = UUID()
    let symbol: String
    let name: String
    let facts: String
    let history: String
}
