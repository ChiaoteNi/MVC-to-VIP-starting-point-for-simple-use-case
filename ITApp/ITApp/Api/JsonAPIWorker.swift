//
//  JsonAPIWorker.swift
//  ITApp
//
//  Created by kuotinyen on 2020/10/26.
//

import Foundation

class JsonAPIWorker {
    func fetchModel<Model: Codable>(from url: URL, callback: @escaping (Result<Model, Error>) -> Void) {
        
        let filename = url.absoluteString
        guard let path = Bundle.main.path(forResource: filename, ofType: Constant.jsonFileExtension) else { return }
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
extension JsonAPIWorker {

    private enum Constant {
        static var jsonFileExtension: String { "json" }
    }
}
