//
//  SqlClass.swift
//  EsportManager2019
//
//  Created by AlexO on 23/01/2019.
//  Copyright © 2019 AlexO. All rights reserved.
//

import Foundation
import SQLite

class sqlClass
{
    let db: Connection
    
    init() {
        let homeUrl = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        let newDbPath = homeUrl.appendingPathComponent("db_esportmanager.db")
        
        let dbPath = URL(fileURLWithPath: Bundle.main.path(forResource: "db_esportmanager", ofType: "db")!)
        
        if (FileManager.default.fileExists(atPath: newDbPath.absoluteString))
        {
            try! FileManager.default.copyItem(at: dbPath, to: newDbPath)
        }
        db = try! Connection(newDbPath.absoluteString)
        
        /*let players = Table("details")
        do {
            for user in try db.prepare(players) {
                print(user)
            }
        } catch {
            // handle
        }*/
    }
    
    func enemyPicker() -> [String : Any]
    {
        let enemyTable = Table("enemyTeams")
        let id = Expression<Int64>("id")
        let randomEnemyTeam = Int64.random(in: 1..<12)
        let idEnemyTeam = enemyTable.filter( id == randomEnemyTeam)
        
        do {
            for enemyTeam in try db.prepare(idEnemyTeam) {
                print(enemyTeam)
                let name = try! enemyTeam.get(Expression<String>("name"))
                let power = try! enemyTeam.get(Expression<Int64>("power"))
                let response = ["name": name, "power": power] as [String : Any]
                return response
            }
        } catch {
            return ["error" : "error"]
        }
        return ["error" : "error"]
    }
}
