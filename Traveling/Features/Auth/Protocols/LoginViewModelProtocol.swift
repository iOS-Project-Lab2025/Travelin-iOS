//
//  LoginViewModelProtocol.swift
//  Traveling
//
//  Created by Ivan Pereira on 05-12-25.
//

import Foundation

protocol LoginViewModelProtocol: Observable {
    var email: String { get set }
    var password: String { get set }

    func login()
}
