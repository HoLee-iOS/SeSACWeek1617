//
//  APIService.swift
//  SeSACWeek1617
//
//  Created by 이현호 on 2022/10/20.
//

import Foundation
import Alamofire

class APIService {
    
    static func searchPhoto(query: String, completion: @escaping (SearchPhoto?, Int?, Error?) -> Void) {
        let url = "\(APIKey.searchURL)\(query)"
        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
        
        //Codable을 사용한다면 swiftyJson 필요없음!
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchPhoto.self) { response in
            
            let statusCode = response.response?.statusCode //상태코드 조건문 처리 해보기!
            
            switch response.result {
            case .success(let value): completion(value, statusCode, nil)
            case .failure(let error): completion(nil, statusCode, error)
            }
        }
    }
    
    private init() { }
    
}
