//
//  API.swift
//  BoxOffice
//
//  Created by Presto on 04/12/2018.
//  Copyright © 2018 presto. All rights reserved.
//

import Foundation

class API {
    private static let baseURL = "http://connect-boxoffice.run.goorm.io"
    private static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

extension API {
    /// 영화 리스트 요청.
    ///
    /// - Parameters:
    ///   - orderType: order_type
    ///   - completion: 네트워크로부터 응답이 왔을 때 실행될 핸들러
    static func requestMovieList(orderType: Int, completion: @escaping (MovieList?, Error?) -> Void) {
        assert((0...2).contains(orderType), "order_type must be between 0 and 2.")
        guard let url = URL(string: "\(baseURL)/movies?order_type=\(orderType)") else { return }
        Network.get(url, successHandler: { data in
            do {
                let decoded = try jsonDecoder.decode(MovieList.self, from: data)
                completion(decoded, nil)
            } catch {
                completion(nil, error)
            }
        }, failureHandler: { completion(nil, $0) })
    }
    
    /// 영화 상세정보 요청.
    ///
    /// - Parameters:
    ///   - id: 영화 ID
    ///   - completion: 네트워크로부터 응답이 왔을 때 실행될 핸들러
    static func requestMovieDetail(id: String, completion: @escaping (MovieDetail?, Error?) -> Void) {
        assert(!id.isEmpty, "id must not be empty.")
        guard let url = URL(string: "\(baseURL)/movie?id=\(id)") else { return }
        Network.get(url, successHandler: { data in
            do {
                let decoded = try jsonDecoder.decode(MovieDetail.self, from: data)
                completion(decoded, nil)
            } catch {
                completion(nil, error)
            }
        }, failureHandler: { completion(nil, $0) })
    }
    
    /// 댓글 요청.
    ///
    /// - Parameters:
    ///   - id: 영화 ID
    ///   - completion: 네트워크로부터 응답이 왔을 때 실행될 핸들러
    static func requestComments(id: String, completion: @escaping (Comment?, Error?) -> Void) {
        assert(!id.isEmpty, "id must not be empty.")
        guard let url = URL(string: "\(baseURL)/comments?movie_id=\(id)") else { return }
        Network.get(url, successHandler: { data in
            do {
                let decoded = try jsonDecoder.decode(Comment.self, from: data)
                completion(decoded, nil)
            } catch {
                completion(nil, error)
            }
        }, failureHandler: { completion(nil, $0) })
    }
}
