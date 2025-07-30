//
//  ContentView.swift
//  JPApexPredators
//
//  Created by Ana Clara Moreira Rodrigues on 22/01/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    let predators = Predators()
    
    @State var searchText: String = ""
    @State var alphabetical = false
    @State var currentSelection = APType.all
    
    var filteredDinos: [ApexPredator] {
        predators.filter(by: currentSelection)
        
        predators.sort(by: alphabetical)
        
        return predators.search(for: searchText)
    }
    
    var body: some View {
        NavigationStack {
            List(filteredDinos) { predator in
                NavigationLink {
                    PredatorDetail(predator: predator, position:  .camera(MapCamera(centerCoordinate: predator.location, distance: 30000)))
                } label: {
                    HStack {
                        //dinosaur image
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .shadow(color: .gray, radius: 1)
                        
                        VStack(alignment: .leading) {
                            //name
                            Text(predator.name)
                                .fontWeight(.bold)
                            
                            //type
                            Text(predator.type.rawValue.capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 13)
                                .padding(.vertical, 5)
                                .background(predator.type.background)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .navigationTitle("Apex Predators")
            .searchable(text: $searchText)
            .autocorrectionDisabled()
            .animation(.default, value: searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            alphabetical.toggle()
                        }
                    } label: {
                        Image(systemName: alphabetical ? "film" : "textformat")    .padding(9)
                            .background(.gray.opacity(0.2))
                            .clipShape(Circle())
                            .symbolEffect(.bounce, value: alphabetical)
                        
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Filter", selection: $currentSelection.animation()) {
                            ForEach(APType.allCases) { type in
                                Label(type.rawValue.capitalized, systemImage: type.icon)
                            }
                        }
                    } label: {
                        if currentSelection == APType.all {
                            Image(systemName: "slider.horizontal.3")
                                .padding(9)
                                .background(.gray.opacity(0.2))
                                .clipShape(Circle())
                        } else {
                            ForEach(APType.allCases) { type in
                                if type == currentSelection {
                                    Image(systemName: type.icon)
                                        .padding(9)
                                        .background(.gray.mix(with: .black, by: 0.5))
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
