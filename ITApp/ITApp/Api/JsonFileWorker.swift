//
//  JsonFileWorker.swift
//  ITApp
//
//  Created by kuotinyen on 2020/10/27.
//

import Foundation

class JsonFileWorker {
    func fetchModel<Model: Codable>(from fileName: String, callback: @escaping (Result<Model, Error>) -> Void) {
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: Constant.jsonFileExtension) else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return }

        do {
            let jsonDataModel = try JSONDecoder().decode(Model.self, from: data)
            callback(.success(jsonDataModel))
        } catch {
            print("#### fetch json failed, error: \(error)")
            callback(.failure(error))
        }
    }
}

// MARK: - Constant
extension JsonFileWorker {

    private enum Constant {
        static var jsonFileExtension: String { "json" }
    }
}
