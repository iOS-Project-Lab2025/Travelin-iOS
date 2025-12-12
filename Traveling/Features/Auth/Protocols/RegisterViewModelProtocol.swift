//
//  RegisterViewModelProtocol.swift
//  Traveling
//
//  Created by NVSH on 09-12-25.
//
import Foundation

protocol RegisterViewModelProtocol: Observable {
    
    var firstName: String { get set }
    var lastName: String { get set }
    var phone: String { get set }
    var age: any Numeric { get set }
    var email: String { get set }
    var password: String { get set}
    
    func createAccount()
}
