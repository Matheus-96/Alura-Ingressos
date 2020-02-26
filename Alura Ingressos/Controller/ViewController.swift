//
//  ViewController.swift
//  Alura Ingressos
//
//  Created by Matheus Rodrigues Araujo on 29/01/20.
//  Copyright © 2020 Curso IOS. All rights reserved.
//

import UIKit
import Money

class ViewController: UIViewController, PickerViewMesSelecionado, PickerViewAnoSelecionado, PickerViewNumeroDeParcela {
    
    
    
    //MARK: - Outlets
    
    var pickerViewMes = PickerViewMes()
    var pickerViewAno = PickerViewAno()
    var pickerViewParcela = PickerViewParcela()
    
    var valorDoIngresso:BRL = 199.00
    
    @IBOutlet weak var imagemBanner: UIImageView!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var scrollViewPrincipal: UIScrollView!
    @IBOutlet weak var labelValorDasParcelas: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagemBanner.layer.cornerRadius = 10
        self.imagemBanner.layer.masksToBounds = true
        pickerViewMes.delegate = self
        pickerViewAno.delegate = self
        pickerViewParcela.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(aumentarScrollView(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    //MARK: - Metodos

    @objc func aumentarScrollView(notification:Notification){
        self.scrollViewPrincipal.contentSize = CGSize(width: self.scrollViewPrincipal.frame.width, height: self.scrollViewPrincipal.frame.height + 750)
    }
    
    func buscaTextField(tipoDeTextField:TiposDeTestField, completion:(_ textFieldSolicidado:UITextField) -> Void ){
        for textField in textFields {
            if let textFieldAtual = TiposDeTestField(rawValue: textField.tag) {
                if textFieldAtual == tipoDeTextField{
                    completion(textField)
                }
            }
        }
    }
    
    //MARK: - PickerViewDelegate
    
    func mesSelecionado(mes: String) {
        self.buscaTextField(tipoDeTextField: .mesDeVencimento) { (textFieldMes) in
            textFieldMes.text = mes
        }
    }
    
    func anoSelecionado(ano: String) {
        self.buscaTextField(tipoDeTextField: .anoDeVencimento) { (textFieldAno) in
            textFieldAno.text = ano
        }
    }
    
    func parcelaSelecionada(parcela: String) {
        self.buscaTextField(tipoDeTextField: .numeroDeParcela) { (textFieldNumeroDeParcelas) in
            textFieldNumeroDeParcelas.text = "\(parcela)x"
            
            let calculoDaParcela = "\(valorDoIngresso / Int(parcela)!)"
            self.labelValorDasParcelas.text = String(format: "%@x %@ (ou R$199,00 á vista)", parcela, calculoDaParcela)
        }
    }
    
    //MARK: - Action
    
    @IBAction func botaoComprar(_ sender: Any) {
        let textFieldsEstaoPreenchidos = ValidaFormulario().verificaTextFieldsPreenchidos(textFields: textFields)
        let validaFormulario = ValidaFormulario().verificaTextFieldsValidos(listaDeTextField: textFields)
        if textFieldsEstaoPreenchidos && validaFormulario{
            let alerta = ValidaFormulario().exibeNotificacaoDePreenchimentoDosTextFields(titulo: "Parabéns", mensagem: "Compra realizada com sucesso")
            present(alerta, animated: true, completion: nil)
        } else {
            let alerta = ValidaFormulario().exibeNotificacaoDePreenchimentoDosTextFields(titulo: "Atenção", mensagem: "Preencha corretamente todos os campos")
            present(alerta, animated: true, completion: nil)
        }
    }
    
    @IBAction func textFieldAlterouValor(_ sender: UITextField) {
        guard let cep = sender.text else { return  }
        LocalizacaoConsultaAPI().consultaViaCepAPI(cep: cep, sucesso: { (localizacao) in
            self.buscaTextField(tipoDeTextField: .endereco) { (textFieldEndereco) in
                textFieldEndereco.text = localizacao.logradouro
            }
            self.buscaTextField(tipoDeTextField: .bairro) { (textFieldBairro) in
                textFieldBairro.text = localizacao.bairro
            }
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func textFieldMesEntrouEmFoco(_ sender: UITextField) {
        
        let pickerView = UIPickerView()
        pickerView.delegate = pickerViewMes
        pickerView.dataSource = pickerViewMes
        sender.inputView = pickerView
    }
    
    @IBAction func textFieldAnoEntrouEmFoco(_ sender: UITextField) {
        
        let pickerView = UIPickerView()
        pickerView.delegate = pickerViewAno
        pickerView.dataSource = pickerViewAno
        sender.inputView = pickerView
    }
    
    
    @IBAction func textFieldCodigoDeSeguranca(_ sender: UITextField) {
        
        guard let texto = sender.text else {return}
        if texto.count > 3 {
            let codigo = texto.suffix(3)
            self.buscaTextField(tipoDeTextField: .codigoDeSeguranca) { (textFieldCodigoDeSeguranca) in
                textFieldCodigoDeSeguranca.text = String(codigo)
            }
            
        } else {
            self.buscaTextField(tipoDeTextField: .codigoDeSeguranca) { (textFieldCodigoDeSeguranca) in
                textFieldCodigoDeSeguranca.text = texto
            }
        }
        
    }
    
    @IBAction func textFieldParcelas(_ sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = pickerViewParcela
        pickerView.dataSource = pickerViewParcela
        sender.inputView = pickerView
    }
    

}

