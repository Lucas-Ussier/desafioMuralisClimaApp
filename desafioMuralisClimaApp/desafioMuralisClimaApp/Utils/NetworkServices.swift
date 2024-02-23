//
//  NetworkServices.swift
//  desafioMuralisClimaApp
//
//  Created by Lucas Galvao on 17/02/24.
//

import Foundation
import UIKit

protocol DetailsReloadTableProtocol {
    func reloadTable()
}
class NetworkServices{
    static let shared = NetworkServices()
    
    var detailsReloadDelegate: DetailsReloadTableProtocol?
    
    private var count = 1
    private var limit = 0
    
    private var login = false
    private var isError = false
    
    private var jwtToken: Token?
    private var measures: Measures?
    private var id = ""
    private var details = WeatherDescription(id: "", temperature: 0, precipitation: 0, humidity: 0, windSpeed: 0, windDirection: 0, pressure: 0, visibility: 0, date: "", changedAt: "", weatherCondition: "")
    private var dates: [[WeatherEntry]]?
    
    public func getisError() -> Bool{
        return self.isError
    }
    
    public func setId(id: String){
        self.id = id
    }
    
    public func getId() -> String{
        return self.id
    }
    
    public func getDetails() -> WeatherDescription{
        return details
    }
    
    public func getTotalCount() -> String{
        let count = self.measures?.totalCount
        guard let count else {return ""}
        
        return String(count)
    }
    
    public func getTotalCount() -> Int{
        return self.measures?.totalCount ?? 0
    }
    
    ///function: save the given data as a token, used at login process
    ///token: Data
    public func saveToken(token: Data?){
        guard let token else {return}
        self.jwtToken = try? JSONDecoder().decode(Token.self, from: token)
        
        UserDefaults.standard.setValue(token, forKey: "jwtToken")
        UserDefaults.standard.synchronize()
    }
    
    public func loadToken(){
        UserDefaults.standard.string(forKey: "jwtToken")
    }
    
    public func getToken() -> Token?{
        return jwtToken
    }
    
    ///function: get the entrys by each of date
    ///entry: data:[WeatherEntry]
    ///return [String: [WeatherEntry]]
    func getEntryByDate(_ data: [WeatherEntry]) -> [String: [WeatherEntry]] {
        var separatedData: [String: [WeatherEntry]] = [:]
        let dataSorted = data.sorted{$0.date < $1.date}
        // Percorre o array de WeatherEntry
        for entry in dataSorted {
            let dateString = String(entry.date[..<entry.date.index(entry.date.startIndex, offsetBy: 10)])
            // Verifica se já existe um array para essa data
            if var entriesForDate = separatedData[dateString] {
                // Se já existir, adiciona a entrada ao array existente
                entriesForDate.append(entry)
                separatedData[dateString] = entriesForDate
            } else {
                // Se não existir, cria um novo array com a entrada
                separatedData[dateString] = [entry]
            }
        }
        
        return separatedData
    }
    
    public func resetToken(){
        self.jwtToken = Token(token: " ")
    }
    
    public func getLogin() -> Bool{
        return self.login
    }
    
    public func getMeasures() -> [WeatherEntry]?{
        return measures?.data
    }
    
    public func getMeasuresCount() -> Int{
        return measures?.data.count ?? 0
    }
    
    ///function: perform login
    ///username: String
    ///password: String
    public func login(username: String, password: String){
        let parameters: [String: String] = ["username": username,
                                            "password": password]
        
        let urlString = "http://localhost:8080/login"
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Erro na requisição: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {return}
            if !(200...299).contains(httpResponse.statusCode){
                if(httpResponse.statusCode == 500){
                    self.isError = true
                }
                self.login = false
                print("Erro na resposta do servidor.")
            }
            
            if let data = data{
                if((200...299).contains(httpResponse.statusCode)){
                    self.login = true
                    self.isError = false
                    self.saveToken(token: data)
                }
            }
        }
        task.resume()
    }
 
    func getMeasurements(page: Int, pageSize: Int, completion: @escaping (Result<[WeatherEntry], Error>) -> Void) {
        // URL do endpoint para a requisição
        let urlString = "http://localhost:8080/measurements?page=\(page)&page_size=\(pageSize)"
        
        // Criando a requisição
        guard let url = URL(string: urlString) else {
            print("URL inválida.")
            completion(.failure(URLError(.badURL)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Método GET
        
        // Adicionando o cabeçalho de autorização com o token Bearer
        guard let token = self.jwtToken?.token else {return}
        request.allHTTPHeaderFields = [
            "Authorization" : "Bearer \(token)"
        ]
        
        // Criando a sessão
        let session = URLSession.shared
        
        // Criando a tarefa de data task para enviar a requisição
        let task = session.dataTask(with: request) { data, response, error in
            // Verificando se ocorreu algum erro
            if let error = error {
                completion(.failure(error))
                print("Erro na requisição: \(error.localizedDescription)")
                return
            }

            // Verificando a resposta do servidor
            guard let httpResponse = response as? HTTPURLResponse else {return}
            
            if !(200...299).contains(httpResponse.statusCode){
                if(httpResponse.statusCode == 500){
                    self.isError = true
                    print("Erro 500")
                }
                //print("Erro na resposta do servidor.")
            }
            
            // Processando os dados recebidos, se houver
            guard let data else {
                print("erro de unwrap")
                return
            }
            
            if(data.isEmpty){
                completion(.failure(URLError(URLError.Code.fileDoesNotExist)))
                print("data vazia")
            }else{
                do{
                    if((200...299).contains(httpResponse.statusCode)){
                        let decoded = try JSONDecoder().decode(Measures.self, from: data)
                        self.measures = decoded
                        self.isError = false
                        completion(.success(decoded.data))
                    }
                }catch{
                    completion(.failure(error))
                    print("Erro ao decodificar:", error)
                }
            }
        }
        
        // Iniciando a tarefa
        task.resume()
    }
    
    func getMeasurementsDetails(at id: String){
        // URL do endpoint para a requisição
        let urlString = "http://localhost:8080/measurements/\(id)"
        
        // Criando a requisição
        guard let url = URL(string: urlString) else {
            print("URL inválida.")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Método GET
        
        // Adicionando o cabeçalho de autorização com o token Bearer
        guard let token = self.jwtToken?.token else {return }
        request.allHTTPHeaderFields = [
            "Authorization" : "Bearer \(token)"
        ]
        
        // Criando a sessão
        let session = URLSession.shared
        
        // Criando a tarefa de data task para enviar a requisição
        let task = session.dataTask(with: request) { data, response, error in
            // Verificando se ocorreu algum erro
            if let error = error {
                print("Erro na requisição: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {return}
            
            if !(200...299).contains(httpResponse.statusCode){
                if(httpResponse.statusCode == 500){
                    self.isError = true
                    print("Erro 500")
                }
                //print("Erro na resposta do servidor.")
            }
            
            // Processando os dados recebidos, se houver
            guard let data else {
                print("erro de unwrap")
                return
            }
            
            if(data.isEmpty){
                self.isError = true
                print("data vazia")
            }else{
                do{
                    let decoded = try JSONDecoder().decode(WeatherDescription.self, from: data)
                    self.details = decoded
                    self.isError = false
                    DispatchQueue.main.async {
                        self.detailsReloadDelegate?.reloadTable()
                    }
                }catch{
                    print("Erro ao decodificar:", error)
                }
            }
        }
        
        // Iniciando a tarefa
        task.resume()
    }
}
