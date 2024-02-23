import XCTest
@testable import desafioMuralisClimaApp

// Função de login que você quer testar
func login(username: String, password: String) -> Bool {
    NetworkServices.shared.login(username: username, password: password)
    return NetworkServices.shared.getLogin()
}

// Classe para testes unitários
class LoginTests: XCTestCase {
    
    // Teste de login com credenciais corretas
    func testLoginWithCorrectCredentials() {
        //Esse teste irá falhar por conta de testar várias vezes, e como tem o erro 500 programado irá dar falha
        XCTAssertTrue(login(username: "user", password: "pass"))
    }
    
    // Teste de login com credenciais incorretas
    func testLoginWithIncorrectCredentials() {
        XCTAssertFalse(login(username: "usuario", password: "senha456"))
        XCTAssertFalse(login(username: "usuario123", password: "senha123"))
        XCTAssertFalse(login(username: "usuario123", password: "senha456"))
    }
    
    // Teste de login com nome de usuário vazio
    func testLoginWithEmptyUsername() {
        XCTAssertFalse(login(username: "", password: "senha123"))
    }
    
    // Teste de login com senha vazia
    func testLoginWithEmptyPassword() {
        XCTAssertFalse(login(username: "usuario", password: ""))
    }
}
