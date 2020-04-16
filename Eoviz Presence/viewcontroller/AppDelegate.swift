//
//  AppDelegate.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import GoogleMaps
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import DIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var mainNavigationController : UINavigationController?
    lazy var preference: Preference = { return Preference() }()
    lazy var constant: Constant = { return Constant() }()

    func changeRootViewController(rootVC : UIViewController){
        mainNavigationController = UINavigationController(rootViewController: rootVC)
        mainNavigationController?.isNavigationBarHidden = true
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = self.mainNavigationController
        }, completion: { completed in
            // maybe do something here
        })
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Set default language
        setDefaultLanguage()
        
        //DIKit
        setupDependencyInjection()
        
        //firebase
        configureFirebase(application: application)
        
        //keyboard manager
        IQKeyboardManager.shared.enable = true
        
        //google maps
        GMSServices.provideAPIKey("AIzaSyDXK-XZW0M7I1joeJYgpaEOhJqGtaXb2BU")
        
        //root viewcontroller
        changeRootViewController(rootVC: SplashController())
        
        return true
    }
    
    private func setupDependencyInjection() {
        DependencyContainer.defined(by: module {
            single { SplashVM() }
            single { NotificationVM() }
            single { ProfileVM() }
            single { BerandaVM() }
            single { LoginVM() }
            single { PresensiVM() }
            single { DaftarPresensiVM() }
            single { FilterDaftarPresensiVM() }
            single { TukarShiftVM() }
            single { ApprovalVM() }
            single { DetailPersetujuanTukarShiftVM() }
        })
    }
    
    private func setDefaultLanguage() {
        let language = preference.getString(key: constant.LANGUAGE)
        
        if language == "" { preference.saveString(value: constant.INDONESIA, key: constant.LANGUAGE) }
        
        Bundle.swizzleLocalization()
    }
    
    private func notificationListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEvent), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleEvent() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    private func configureFirebase(application: UIApplication) {
        FirebaseApp.configure()
        
        // For iOS 10 display notification (sent via APNS)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        //get application instance ID
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.preference.saveString(value: result.token, key: self.constant.FCM_TOKEN)
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("fcm token \(fcmToken)")
        preference.saveString(value: fcmToken, key: constant.FCM_TOKEN)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        if (fcmToken != preference.getString(key: constant.TOKEN)) {
            preference.saveString(value: fcmToken, key: constant.FCM_TOKEN)
            preference.saveBool(value: false, key: constant.IS_LOGIN)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//        let token = tokenParts.joined()
//        Messaging.messaging().apnsToken = deviceToken
//        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("notification data: \(userInfo)")
    }
    
//    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
//        let data = remoteMessage.appData
//        print("Receive data message: \(data)")
//    }
    
    // function to handle when notification clicked
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print("full message \(userInfo)")
        
        guard
            //let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
            let data_id = userInfo[AnyHashable("data_id")],
            let redirect = userInfo[AnyHashable("redirect")]
            else {
                // handle any error here
                return
            }
        
        print("redirect: \(redirect), data_id: \(data_id)")
        
        checkRedirect(redirect: "\(redirect)", leave_id: "\(data_id)")
        
        completionHandler()
    }
    
    // handle notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        print("notification data foreground: \(content.userInfo)")
        completionHandler([.alert, .sound, .badge])
    }
    
    private func checkRedirect(redirect: String, leave_id: String) {
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension Bundle {
    static func swizzleLocalization() {
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector) else { return }

        let mySelector = #selector(myLocaLizedString(forKey:value:table:))
        guard let myMethod = class_getInstanceMethod(self, mySelector) else { return }

        if class_addMethod(self, orginalSelector, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)) {
            class_replaceMethod(self, mySelector, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, myMethod)
        }
    }

    @objc private func myLocaLizedString(forKey key: String,value: String?, table: String?) -> String {
        let preference = Preference()
        let constant = Constant()
        let language = preference.getString(key: constant.LANGUAGE)
        guard let bundlePath = Bundle.main.path(forResource: language, ofType: "lproj"),
        let bundle = Bundle(path: bundlePath) else {
            return Bundle.main.myLocaLizedString(forKey: key, value: value, table: table)
        }
        return bundle.myLocaLizedString(forKey: key, value: value, table: table)
    }
}
