//
//  Route.swift
//  Bus
//
//  Created by Ayaan on 2023-04-15.
//

import Foundation

struct Route: Identifiable, Codable, Hashable {
    var tag: String
    var title: String
    var showing: Bool
    var id: Int 
}

struct PersistenceManager{

       static let defaults = UserDefaults.standard
       private init(){}
       
       // save Data method
       static func saveRoutes(domainSchema: [Route]){
         do{
            let encoder = JSONEncoder()
            let domainsSchema = try encoder.encode(domainSchema)
            defaults.setValue(domainsSchema, forKey: "routes")
         }catch let err{
            print(err)
         }
      }
      
     //retrieve data method
     static func getRoutes() -> [Route]{
   
            guard let domainSchemaData = defaults.object(forKey: "routes") as? Data else{return []}
            do{
                let decoder = JSONDecoder()
                let domainsSchema = try decoder.decode([Route].self, from: domainSchemaData)
                return domainsSchema
            }catch _{
                return([])
          }
       }
}

