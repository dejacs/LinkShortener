import NetworkCore

enum URLShortenerEndpoint: EndpointProtocol {
    case postAlias(text: String)
    case getLink(id: String)
    
    var host: String { "https://url-shortener-nu.herokuapp.com" }
    
    var path: String {
        switch self {
        case .postAlias:
            return "/api/alias"
        case .getLink(let id):
            return "/api/alias/\(id)"
        }
    }
    
    var headers: (value: String, field: String) { (value: "application/json", field: "Content-Type") }
    
    var params: [String: Any] {
        switch self {
        case .postAlias(let text):
            return ["url": text]
        default:
            return [:]
        }
    }
    
    var method: EndpointMethod {
        switch self {
        case .postAlias:
            return .post
        case .getLink:
            return .get
        }
    }
}
