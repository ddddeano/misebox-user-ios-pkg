//
//  MiseboxUser.swift
//
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore
import FirebaseiOSMisebox
import GlobalMiseboxiOS

extension MiseboxUserManager {
    
    public final class MiseboxUser: ObservableObject, Identifiable, Listenable {
        
        public let doc = "misebox-user"
        public let collection = "misebox-users"
        
        @Published public var id: String = ""
        @Published public var username: String = ""
        @Published public var imageUrl: String = defaultImage
        @Published public var verified: Bool = false
        @Published public var userRoles: [UserRole] = []
        
        public init() {}
        
        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            update(with: data)
        }
        
        public func update(with data: [String: Any]) {
            username = data["username"] as? String ?? ""
            imageUrl = data["image_url"] as? String ?? defaultImage
            verified = data["verified"] as? Bool ?? false
            
            if let rolesData = data["user_roles"] as? [[String: Any]] {
                userRoles = rolesData.compactMap(UserRole.init)
            }

        }
        
        public func toFirestore() -> [String: Any] {
            return [
                "username": username,
                "image_url": imageUrl,
                "verified": verified,
                "user_roles": userRoles.map { $0.toFirestore() }
            ]
        }
    }
}


