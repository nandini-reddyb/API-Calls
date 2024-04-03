//
//  UserModel.swift
//  API_Calls
//
//  Created by Nandini B on 19/03/24.
//

import Foundation

struct userListModel: Codable {
    let page: Int?
    let per_page: Int?
    let total_pages: Int?
    let data: [userListDataModel]? //array
    let support: userListSupportModel? //dictionary
    
    //defined coding keys -> maping the keys with our variables
    enum codingKeys: String, CodingKey {
        case page = "page"  //coding key
        case per_page = "per_page"
        case total_pages = "total_pages"
        case data = "data"
        case support = "support"
    }
    
    //need to decode
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.page = try container.decodeIfPresent(Int.self, forKey: .page)
        self.per_page = try container.decodeIfPresent(Int.self, forKey: .per_page)
        self.total_pages = try container.decodeIfPresent(Int.self, forKey: .total_pages)
        self.data = try container.decodeIfPresent([userListDataModel].self, forKey: .data)
        self.support = try container.decodeIfPresent(userListSupportModel.self, forKey: .support)
    }
    
}

struct userListDataModel: Codable {
    let id: Int?
    let email: String?
    
    //defined coding keys -> maping the keys with our variables
    enum codingKeys: String, CodingKey {
        case id = "id"  //coding key
        case email = "email"
    }
    
    //need to decode
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
    }
    
}

struct userListSupportModel: Codable {
    let url: String?
    let text: String?
    
    //defined coding keys -> maping the keys with our variables
    enum codingKeys: String, CodingKey {
        case url = "url"  //coding key
        case text = "text"
    }
    
    //need to decode
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
    }
    
}
