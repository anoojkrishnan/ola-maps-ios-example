//
//  AuthResponseModel.swift
//  EnRoute
//
//  Created by Anooj Krishnan G on 11/07/24.
//

import Foundation

struct AuthResponseModel: Decodable {
  let accessToken: String

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
  }
}
