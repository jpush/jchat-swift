//
//  JChatDataBaseManager.swift
//  JChatSwift
//
//  Created by oshumini on 2016/12/30.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit
import FMDB


class JChatDataBaseManager: NSObject {
  
  static let sharedInstance = JChatDataBaseManager()
  var db:FMDatabase!
  
  override init() {
    super.init()
    openDataBase()
  }
  
  func openDataBase() {
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    print("the document path \(documentPath)")
    let dataBasePath = documentPath.appending("/JChatDataBase.db")
    print("the database path \(dataBasePath)")
    
    self.db = FMDatabase(path: dataBasePath)
    
    if !self.db.open() {
      self.db = nil
    }
    
//    if !createTable() {
//      print("创建数据库失败")
//      return
//    }
    
  }
  
  // MARK: CREATE TABLE
  open func setupTable(username: String) -> Bool {
    if username == "" {
      print("username is nil error")
      return false
    }
    
    if !createContactsTable(currentUser: username) {
      print("创建数据库联系人表失败")
      return false
    }
    
    if !createInvitationTable(currentUser: username) {
      print("创建数据库邀请表失败")
      return false
    }
    
    return true
  }
  
  func createContactsTable(currentUser: String) -> Bool {
    let sql = "CREATE TABLE IF NOT EXISTS Contacts_\(currentUser)( \n" +
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
                  "username TEXT UNIQUE\n" +
              ");"

    return db!.executeUpdate(sql, withVAList: nil)// arr  db.executeUpdate(sql, withArgumentsInArray: ["zs", 30])
  }
  
  func createInvitationTable(currentUser: String) -> Bool {
    let sql = "CREATE TABLE IF NOT EXISTS Invitation_\(currentUser)( \n" +
                      "id INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
                      "username TEXT UNIQUE, \n" +
                      "reason TEXT, \n" +
                      "invitation_type INTEGER \n" +
              ");" // invitation_type  1:已添加   2:好友请求已发送等待验证 3:对方拒绝 4:好友邀请已接受待验证
    return db!.executeUpdate(sql, withVAList: nil)
  }
  
  // MARK: CONTACTS
  open func removeContact(currentUser: String, with username: String) -> Bool {
    if currentUser == "" {
      print("username is nil error")
      return false
    }
    
    let sql = "DELETE FROM Contacts_\(currentUser) WHERE username = '\(username)';"
    do {
      return self.db.executeUpdate(sql, withVAList: nil)
    } catch let error as NSError {
      print("delete contact fail \(error)")
      return false
    }
    
  }
  
  open func addContactList(currentUser: String,contactUsernameArr: Array<JMSGUser>) -> Bool {
    if currentUser == "" {
      print("username is nil error")
      return false
    }
    
    do {

      self.db.beginTransaction()
      // delete all contact
      var sql = "DELETE FROM Contacts_\(currentUser);"
      self.db.executeUpdate(sql, withVAList: nil)
      
      sql = "INSERT INTO Contacts_\(currentUser)(username) values (?)"
      for contact in contactUsernameArr {
        try self.db.executeUpdate(sql, values: [contact.username])
      }
      self.db.commit()
    } catch let error as NSError {
      print("set category fail \(error)")
      self.db.rollback()
      return false
    }
    
    return true
  }
  
  open func addContact(currentUser: String,with username:String) -> Bool {
    if currentUser == "" {
      print("username is nil error")
      return false
    }
    
    do {
      let sql = "INSERT INTO Contacts_\(currentUser)(username) values (?)"
      try self.db.executeUpdate(sql, values: [username])
      return true

    } catch let error as NSError {
      print("insert user fail \(error)")
      return false
    }
  }

  open func selectAllContact(currentUser: String) -> Array<String> {
    if currentUser == "" {
      print("username is nil error")
      return []
    }
    
    let sql = "SELECT * FROM Contacts_\(currentUser);"
    do {
      let contactArr = NSMutableArray()
      let rs = try self.db.executeQuery(sql, values: nil)
      while rs.next() {
        print("\(rs.string(forColumnIndex: 1))")
        contactArr.add(rs.string(forColumnIndex: 1))
      }
      return NSArray(array: contactArr) as! Array<String>
      
    } catch let error as NSError {
      print("get all contact fail \(error)")
      return []
    }
  }
  
  open func selectContact(currentUser: String, user: JMSGUser) -> String {
    if currentUser == "" {
      print("username is nil error")
      return ""
    }
    
    var username = ""
    let sql = "SELECT * FROM Contacts_\(currentUser) WHERE username = '\(user.username)';"
    do {
      let rs = try self.db.executeQuery(sql, values: nil)
      while rs.next() {
        username = rs.string(forColumnIndex: 1)
      }
    } catch let error as NSError {
      print("error")
    }
    return username
  }
  
  // MARK: INVITATION
  open func addInvitation(currentUser: String, with username:String, reason: String, invitationType: NSInteger) -> Bool {
    if currentUser == "" {
      print("username is nil error")
      return false
    }
    
    do {
      var sql = "DELETE FROM Invitation_\(currentUser) WHERE username = '\(username)';"
      self.db.executeUpdate(sql, withVAList: nil)
      
      sql = "INSERT INTO Invitation_\(currentUser)(username,reason,invitation_type) values (?,?,?)"
      try self.db.executeUpdate(sql, values: [username,reason,invitationType])
      return true
      
    } catch let error as NSError {
      print("insert user fail \(error)")
      return false
    }
  }
  
  open func deleteInvitation(currentUser: String,with username: String) -> Bool{
    if currentUser == "" {
      print("username is nil error")
      return false
    }
    
    let sql = "DELETE FROM Invitation_\(currentUser) WHERE username = '\(username)';"
    do {
      return self.db.executeUpdate(sql, withVAList: nil)
    } catch let error as NSError {
      print("delete contact fail \(error)")
      return false
    }
  }
  
  open func deleteAllInvitation(currentUser: String) -> Bool {
    if currentUser == "" {
      print("username is nil error")
      return false
    }
    
    let sql = "DELETE FROM Invitation_\(currentUser);"
    do {
      return self.db.executeUpdate(sql, withVAList: nil)
    } catch let error as NSError {
      print("delete contact fail \(error)")
      return false
    }
  }

  open func selectInvitation(currentUser: String, callback:@escaping CompletionBlock) {
    if currentUser == "" {
      print("username is nil error")
      callback([])
    }
    
    let sql = "SELECT * FROM Invitation_\(currentUser);"
    do {
      let contactArr = NSMutableArray()
      let contactDic = NSMutableDictionary()
      
      let rs = try self.db.executeQuery(sql, values: nil)
      while rs.next() {
        print("\(rs.string(forColumnIndex: 1))")
        let friendModel = JChatInvitationModel()
        let username = rs.string(forColumn: "username")
        let reason = rs.string(forColumn: "reason")
        let type = rs.int(forColumn: "invitation_type")
        friendModel.setData(reason!, type: JChatFriendEventNotificationType(rawValue: NSInteger(type))!)
        contactDic[username] = friendModel
        contactArr.add(username)
      }
      
      JMSGUser.userInfoArray(withUsernameArray: (contactArr as! [String]), completionHandler: { (result, error) in
        if error != nil { return }
        for user in (result as! Array<JMSGUser>) {
            (contactDic[user.username] as! JChatInvitationModel).user = user
        }
        callback(contactDic.allValues)
      })

    } catch let error as NSError {
      print("get all contact fail \(error)")
      callback([])
    }
  }
}

















