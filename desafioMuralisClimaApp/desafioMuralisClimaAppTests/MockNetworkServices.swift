import Foundation
@testable import desafioMuralisClimaApp

class MockNetworkService: NetworkServices {
    var responseStatusCode: Int
    var responseData: Data
    var isError: Bool
    
    init(responseStatusCode: Int, responseData: Data, isError: Bool) {
        self.responseStatusCode = responseStatusCode
        self.responseData = responseData
        self.isError = isError
    }
    
    override func login(username: String, password: String) {
        // Simula uma resposta de sucesso para o login com credenciais válidas
        if username == "user" && password == "password" {
            handleSuccessResponse()
        } else {
            // Simula uma resposta de erro para o login com credenciais inválidas
            handleError()
        }
    }
    
    private func handleSuccessResponse() {
        // Simula uma resposta de sucesso com código de status 200 e dados de resposta vazios
        let response = HTTPURLResponse(url: URL(string: "http://localhost")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        self.delegate?.didReceiveData(data: Data(), response: response, error: nil)
    }
    
    private func handleError() {
        // Simula uma resposta de erro com código de status 500 e mensagem de erro
        let error = NSError(domain: "MockNetworkService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Internal Server Error"])
        self.delegate?.didReceiveData(data: nil, response: nil, error: error)
    }
}
