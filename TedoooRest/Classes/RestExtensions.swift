import Combine
import Alamofire

public class RestExtensions {
    
    public static var baseUrl = "https://backend.tedooo.com"
    
    private static func authHeader(token: String?) -> HTTPHeaders? {
        if let token = token {
            return ["Authorization": token]
        } else {
            return nil
        }
    }
    
    private static var queryCharSet: CharacterSet = {
        var set = CharacterSet.urlQueryAllowed
        set.remove("&")
        return set
    }()
    
    static func encodeQuery(query: String) -> String {
        return query.addingPercentEncoding(withAllowedCharacters: RestExtensions.queryCharSet) ?? ""
    }
    
    static func encodeUrl(query: String) -> String {
        return query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    public static func requestRx<T: Encodable, V: Decodable>(outputType: V.Type, baseUrl: String = RestExtensions.baseUrl, _ url: String, token: String?, method: Alamofire.HTTPMethod = HTTPMethod.get, parameters: T, queries: [String: String] = [:]) -> Future<V, AFError> {
        return Future { single in
            var queryString = ""
            if queries.count != 0 {
                queryString = "?"
                var first = true
                for query in queries {
                    if !first {
                        queryString += "&"
                    }
                    queryString += "\(RestExtensions.encodeUrl(query: query.key))=\(RestExtensions.encodeQuery(query: query.value))"
                    first = false
                }
            }
            AF.request(baseUrl + url + queryString, method: method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: authHeader(token: token)).validate().responseDecodable(of: outputType) { result in
                switch result.result {
                case .success(let r):
                    single(.success(r))
                case .failure(let err):
                    single(.failure(err))
                }
            }
        }
    }
    
    public static func requestRx<T: Encodable>(baseUrl: String = RestExtensions.baseUrl, _ url: String, token: String?, method: Alamofire.HTTPMethod = HTTPMethod.get, parameters: T, queries: [String: String] = [:]) -> Future<Any?, AFError> {
        return Future { single in
            var queryString = ""
            if queries.count != 0 {
                queryString = "?"
                var first = true
                for query in queries {
                    if !first {
                        queryString += "&"
                    }
                    queryString += "\(RestExtensions.encodeUrl(query: query.key))=\(RestExtensions.encodeQuery(query: query.value))"
                    first = false
                }
            }
            AF.request(baseUrl + url + queryString, method: method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: authHeader(token: token)).validate().response { result in
                switch result.result {
                case .success:
                    single(.success(nil))
                case .failure(let err):
                    single(.failure(err))
                }
            }
        }
    }
    
    public static func requestRx<T: Decodable>(outputType: T.Type, baseUrl: String = RestExtensions.baseUrl, _ url: String, token: String?, method: Alamofire.HTTPMethod = HTTPMethod.get, queries: [String: String] = [:]) -> Future<T, AFError> {
        return Future { single in
            var queryString = ""
            if queries.count != 0 {
                queryString = "?"
                var first = true
                for query in queries {
                    if !first {
                        queryString += "&"
                    }
                    queryString += "\(RestExtensions.encodeUrl(query: query.key))=\(RestExtensions.encodeQuery(query: query.value))"
                    first = false
                }
            }
            AF.request(baseUrl + url + queryString, method: method, headers: authHeader(token: token)).validate().responseDecodable(of: outputType) { result in
                switch result.result {
                case .success(let r):
                    single(.success(r))
                case .failure(let err):
                    print(err)
                    single(.failure(err))
                }
            }
        }
    }

    public static func requestRx(baseUrl: String = RestExtensions.baseUrl, _ url: String, token: String?, method: Alamofire.HTTPMethod = HTTPMethod.get, queries: [String: String] = [:]) -> Future<Any?, AFError> {
        return Future { single in
            var queryString = ""
            if queries.count != 0 {
                queryString = "?"
                var first = true
                for query in queries {
                    if !first {
                        queryString += "&"
                    }
                    queryString += "\(RestExtensions.encodeUrl(query: query.key))=\(RestExtensions.encodeQuery(query: query.value))"
                    first = false
                }
            }
            AF.request(baseUrl + url + queryString, method: method, headers: authHeader(token: token)).validate().response { result in
                switch result.result {
                case .success:
                    single(.success(nil))
                case .failure(let err):
                    single(.failure(err))
                }
            }
        }
    }
    
}
