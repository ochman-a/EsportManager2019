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
    }
    
    func enemyPicker() -> [String : Any]
    {
        let enemyTable = Table("enemyTeams")
        let id = Expression<Int64>("id")
        let randomEnemyTeam = Int64.random(in: 1..<12)
        let idEnemyTeam = enemyTable.filter( id == randomEnemyTeam)
        
        do {
            for enemyTeam in try db.prepare(idEnemyTeam) {
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
    
    func myTeamInfo() -> [String : Any?]
    {
        let myTeamTable = Table("myTeam")
        let id = Expression<Int64>("id")
        let myTeamLine = myTeamTable.filter(id == 1)
        
        do {
            for myTeamInfo in try db.prepare(myTeamLine) {
                var name: String?
                var budget: Int64?
                name = try? myTeamInfo.get(Expression<String>("name"))
                budget = try? myTeamInfo.get(Expression<Int64>("budget"))
                let response = ["name": name, "budget": budget] as [String : Any?]
                return response
            }
        } catch {
            return ["error" : "error"]
        }
        return ["error" : "error"]
    }
    
    func pickPlayerDetails(idP: Int64) -> [String : Any]
    {
        let detailsTable = Table("details")
        let id = Expression<Int64>("id")
        
        let detailsRequest = detailsTable.filter( id == idP)
        
        do {
            for player in try! db.prepare(detailsRequest) {
                let nickname = try! player.get(Expression<String>("nickname"))
                let power = try! player.get(Expression<Int64>("power"))
                let precision = try! player.get(Expression<Int64>("precision"))
                let kd = try! player.get(Expression<Int64>("kd"))
                let reflexe = try! player.get(Expression<Int64>("reflexe"))
                let patience = try! player.get(Expression<Int64>("patience"))
                let price = try! player.get(Expression<Int64>("price"))
                let response = ["nickname": nickname, "power": power, "precision": precision, "kd": kd, "reflexe": reflexe, "patience": patience, "price": price] as [String : Any]
                return response
            }
        } catch {
            return ["error" : "error"]
        }
        return ["error" : "error"]
    }
    
    func playerList() -> [Int64 : String]
    {
        let detailsTable = Table("details")
        let id = Expression<Int64>("id")
        var randomNumber = [Int64]()
        var exist = 0;
        
        for _ in 1..<11 {
            var randomPlayer = Int64.random(in: 1..<30)
            if randomNumber.contains (randomPlayer) {
                exist=1
                while(exist == 1) {
                    if randomNumber.contains (randomPlayer) {
                        randomPlayer = Int64.random(in: 1..<30)
                    } else {
                        exist = 0
                        randomNumber.append(randomPlayer)
                    }
                }
            } else {
                randomNumber.append(randomPlayer)
            }
        }
        let idPlayer = detailsTable.filter(randomNumber.contains(id))
        var response: [Int64 : String] = [:]
        do {
            for playerList in try db.prepare(idPlayer)
            {
                let name = try! playerList.get(Expression<String>("nickname"))
                let myId = try! playerList.get(Expression<Int64>("id"))
                response[myId] = name
            }
            return response
        } catch {
            return [0 : "error"]
        }
    }
}
