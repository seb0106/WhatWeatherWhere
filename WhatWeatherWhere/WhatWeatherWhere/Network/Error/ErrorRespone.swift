//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation

struct ErrorResponse: Codable{
    let code: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey{
        case code = "cod"
        case message = "message"
    }
}
