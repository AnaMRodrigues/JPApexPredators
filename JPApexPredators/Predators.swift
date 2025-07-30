//
//  Predators.swift
//  JPApexPredators
//
//  Created by Ana Clara Moreira Rodrigues on 22/01/25.
//

import Foundation

class Predators {
    var allApexPredators: [ApexPredator] = []
    var apexPredators: [ApexPredator] = []

    init() {
        decodeApexPredatorData()
    }

    func decodeApexPredatorData() {
        //if this file can be founded, store the url to the property
        //if it worked, then ...
        if let url = Bundle.main.url(
            forResource: "jpapexpredators", withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                //converts snake case to camel case
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                allApexPredators = try decoder.decode(
                    [ApexPredator].self, from: data)
                apexPredators = allApexPredators
            } catch {
                print("Error decodind JSON data: \(error)")
            }
        }
    }

    func search(for searchTerm: String) -> [ApexPredator] {
        if searchTerm.isEmpty {
            return apexPredators
        } else {
            return apexPredators.filter { predator in
                predator.name.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    func sort(by alphabetical: Bool) {
        apexPredators.sort { predator1, predator2 in
            if alphabetical {
                predator1.name < predator2.name
            } else {
                predator1.id < predator2.id
            }
        }
    }
    
    func filter(by type: APType) {
        if type == .all {
            apexPredators = allApexPredators
        } else {
            apexPredators = allApexPredators.filter { predator in
                predator.type == type
            }
        }
    }
}
