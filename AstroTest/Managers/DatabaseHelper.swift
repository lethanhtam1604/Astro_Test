//
//  DatabaseHelper.swift
//  AstroTest
//
//  Created by Thanh-Tam Le on 9/22/17.
//  Copyright © 2017 Tam. All rights reserved.
//

import UIKit
import CoreData

class DatabaseHelper: NSObject {

    fileprivate static var instance: DatabaseHelper!

    static func getInstance() -> DatabaseHelper {
        if instance == nil {
            instance = DatabaseHelper()
        }

        return instance
    }

    private override init() {
        super.init()

    }

    func saveChannel(_ channel: Channel) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        do {

            let context = appDelegate.persistentContainer.viewContext

            let entity = NSEntityDescription.entity(forEntityName: "ChannelModel", in: context)

            let fetchRequest: NSFetchRequest<ChannelModel> = ChannelModel.fetchRequest()
            let searchResults = try context.fetch(fetchRequest)

            var transc: NSManagedObject!
            var isUpdate = false
            for trans in searchResults as [NSManagedObject] {
                let id = trans.value(forKey: "channelId") as? Int64

                if id == channel.channelId {
                    transc = trans
                    isUpdate = true
                    break
                }
            }

            if !isUpdate && entity != nil {
                transc = NSManagedObject(entity: entity!, insertInto: context) //swiftlint:disable:this force_unwrapping
            }

            if transc != nil {
                //set the entity values
                transc.setValue(channel.channelId, forKey: "channelId")
                transc.setValue(channel.currentChannelLogo?.value, forKey: "channelLogo")
                transc.setValue(channel.channelStbNumber, forKey: "channelStbNumber")
                transc.setValue(channel.channelTitle, forKey: "channelTitle")

                //save the object
                try context.save()
                print("saved!")
            }
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {

        }
    }

    func getChannels() -> [Channel]? {

        do {
            //go get the results
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return nil
            }

            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ChannelModel> = ChannelModel.fetchRequest()

            let searchResults = try context.fetch(fetchRequest)

            var channels: [Channel] = []

            for trans in searchResults as [NSManagedObject] {
                let channel = Channel()
                channel.channelId = trans.value(forKey: "channelId") as? Int64
                let channelLogo = ChannelLogo()
                channelLogo.value = trans.value(forKey: "channelLogo") as? String
                channel.currentChannelLogo = channelLogo
                channel.channelStbNumber = trans.value(forKey: "channelStbNumber") as? String
                channel.channelTitle = trans.value(forKey: "channelTitle") as? String
                channels.append(channel)
            }
            return channels
        } catch {
            print("Error with request: \(error)")
        }
        return nil
    }

    func deleteChannel(_ channel: Channel) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        do {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ChannelModel> = ChannelModel.fetchRequest()
            let searchResults = try context.fetch(fetchRequest)

            for trans in searchResults as [NSManagedObject] {
                let id = trans.value(forKey: "channelId") as? Int64
                if id == channel.channelId {
                    context.delete(trans)
                    break
                }
            }

            try context.save()

        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        } catch {
        }
    }

}
