//
//  LocalizacaoConsultaAPI.swift
//  Alura Ingressos
//
//  Created by Matheus Rodrigues Araujo on 29/01/20.
//  Copyright © 2020 Curso IOS. All rights reserved.
//

import UIKit
import Alamofire

class LocalizacaoConsultaAPI: NSObject {
    
    func consultaViaCepAPI(cep:String, sucesso:@escaping ( _ localizacao: Localizacao)-> Void, falha: @escaping(_ error: Error) -> Void){
        Alamofire.request("https://viacep.com.br/ws/\(cep)/json/", method: .get).validate().responseJSON { (response) in
            switch response.result{
            case .success:
                if let resultado =  response.result.value as? [String:String]{
                    let localizacao = Localizacao(resultado)
                    sucesso(localizacao)
                }
                break
            case .failure:
                falha(response.result.error!)
                break
            }
        }
    }

}
