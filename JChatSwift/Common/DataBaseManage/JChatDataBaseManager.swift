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
    print("thr database path \(dataBasePath)")
    
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
  func createTable(username: String) -> Bool {
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
    let sql = "CREATE TABLE IF NOT EXISTS T_Contacts( \n" +
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
                  "username TEXT UNIQUE\n" +
              ");"

    return db!.executeUpdate(sql, withVAList: nil)// arr  db.executeUpdate(sql, withArgumentsInArray: ["zs", 30])
  }
  
  func createInvitationTable(currentUser: String) -> Bool {
    let sql = "CREATE TABLE IF NOT EXISTS T_Invitation( \n" +
                      "id INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
                      "username TEXT UNIQUE \n" +
              ");"
    return db!.executeUpdate(sql, withVAList: nil)
  }
  
  // MARK: CONTACTS
  open func removeContact(currentUser: String, with username: String) -> Bool {
    let sql = "DELETE FROM T_Contacts WHERE username = \(username);"
    do {
      return self.db.executeUpdate(sql, withVAList: nil)
    } catch let error as NSError {
      print("delete contact fail \(error)")
      return false
    }
    
  }
  
  open func addContactList(currentUser: String,contactUsernameArr: Array<JMSGUser>) -> Bool {
    do {

      self.db.beginTransaction()
      // delete all contact
      var sql = "DELETE FROM T_Contacts;"
      self.db.executeUpdate(sql, withVAList: nil)
      
      sql = "INSERT INTO T_Contacts(username) values (?)"
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
    
    do {
      let sql = "INSERT INTO T_Contacts(username) values (?)"
      try self.db.executeUpdate(sql, values: [username])
      return true

    } catch let error as NSError {
      print("insert user fail \(error)")
      return false
    }
  }

  open func selectAllContact(currentUser: String) -> Array<String> {
    
    let currentUsername = JMSGUser.myInfo().username
    if currentUsername == nil {
      print("当前没有用户登录")
      return []
    }
    
    let sql = "SELECT * FROM T_Contacts;"
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
  
  
  // MARK: INVITATION
  open func addInvitation(currentUser: String, with username:String) -> Bool {
    do {
      
      let sql = "INSERT INTO T_Invitation(username) values (?)"
      try self.db.executeUpdate(sql, values: [username])
      return true
      
    } catch let error as NSError {
      print("insert user fail \(error)")
      return false
    }
  }
  
  open func deleteInvitation(currentUser: String,with username: String) -> Bool{
    let sql = "DELETE FROM T_Invitation WHERE username = \(username);"
    do {
      return self.db.executeUpdate(sql, withVAList: nil)
    } catch let error as NSError {
      print("delete contact fail \(error)")
      return false
    }
  }

  open func selectInvitation(currentUser: String) -> Array<String> {
    
    let sql = "SELECT * FROM T_Invitation;"
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
}

















