//
//  ContentView.swift
//  TEKNews
//
//  Created by Thomas Nyuma on 7/26/20.
//  Copyright © 2020 Thomas Nyuma. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit

struct ContentView: View {
    
    @ObservedObject var list = getApiData()
    
    var body: some View {
        NavigationView{
      
            List(list.dates){ i in
                 
                NavigationLink(destination:
                     
                webView(url: i.url)
                    .navigationBarTitle("", displayMode: .inline)) {
                    
                    HStack(spacing: 15) {
                       
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text(i.title).fontWeight(.heavy)
                            Text(i.desc).lineLimit(2)
                            
                        }
                        
                        
                        if i.image != "" {
                        
                        
                        WebImage(url: URL(string:  i.image)!, options:  .highPriority, context: nil)
                            .resizable()
                            .frame(width: 110, height: 135)
                            .cornerRadius(20)

                            
                            
                        }

                    }.padding(.vertical, 15)
                    
                }
                
            func getCountry(_ country : String)!
          {
           var country = getApiData(country : String)                  
              for country in i.country 
             {
                if (i.country == country)
                {
                    return country
                } 
                 
              }
          
          }
            }.navigationBarTitle("Top \(country) News Stories")
        
        

        
            
        }
        
    }
        
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.colorScheme, .light)
            ContentView()
                .environment(\.colorScheme, .dark)
        }
        
    }
}


struct dataType : Identifiable {
    
    var id : String
    var title : String
    var desc : String
    var url : String
    var image : String
    var country : String
    
}

// Load in API Data for the app to display.

class getApiData : ObservableObject {
    
    @Published var  dates = [dataType]()
    
    init() {
        
        let source = "https://newsapi.org/v2/top-headlines?country=us&apiKey=42cfb7a4c2944f05b90422c99a597268"
        
        let url = URL(string: source)!
        
        let session = URLSession(configuration: .default )
        
        let country = Country(string: source)!
        
        session.dataTask(with: url)  {  (data,  _,  err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            let json = try! JSON(data: data!)
            
            for i in json["articles"]{
                
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url = i.1["url"].stringValue
                let image = i.1["urlToImage"].stringValue
                let id = i.1["publishedAt"].stringValue
                let country = i.1["country"].stringValue
            
                DispatchQueue.main.async {
                    
                       self.dates.append(dataType(id: id, title: title, desc: description, url: url, image: image, country: country))
                    
                }
            }
            
        }.resume()
    }
}


struct webView : UIViewRepresentable {
    
    var url : String
    
    func makeUIView(context: UIViewRepresentableContext<webView>) -> WKWebView {
        
        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
        return view
    
    }
    
    func updateUIView (_ uiView: WKWebView, context:
        UIViewRepresentableContext<webView>) {
    
    }
    
}
