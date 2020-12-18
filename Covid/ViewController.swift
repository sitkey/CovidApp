//
//  ViewController.swift
//  Covid
//
//  Created by Mac15 on 18/12/20.
//

import UIKit
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
class ViewController: UIViewController {
    
    var covidManager = CovidManager()

    @IBOutlet weak var fondoImage: UIImageView!
    @IBOutlet weak var recuperadosHoyLabel: UILabel!
    @IBOutlet weak var muertosHoyLabel: UILabel!
    @IBOutlet weak var contagiadosHoyLabel: UILabel!
    @IBOutlet weak var banderaImage: UIImageView!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var paisTextField: UITextField!
    @IBOutlet weak var contagiadosLabel: UILabel!
    @IBOutlet weak var muertosLabel: UILabel!
    @IBOutlet weak var recuperadosLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        covidManager.delegado = self
        paisTextField.delegate = self
        fondoImage.layer.zPosition = -5; 
    }
    @IBAction func buscarPaisButton(_ sender: UIButton) {
        covidManager.fetchCovid(nombreCiudad: paisTextField.text!)
    }
}
extension ViewController : CovidManagerDelegate {
    func huboError(cualError: Error) {
        DispatchQueue.main.async {
            if cualError.localizedDescription == "The data couldn’t be read because it is missing."{
                self.ciudadLabel.text = "Ciudad no encontrada"
            }
            print(cualError.localizedDescription)
        }
    }
    
    func actualizaPais(pais: CovidModel) {
        DispatchQueue.main.async {
            self.ciudadLabel.text = pais.country
            self.contagiadosLabel.text = "Total de contagiados: \(pais.cases)"
            self.muertosLabel.text = "Total de muertos: \(pais.deaths)"
            self.recuperadosLabel.text = "Total de recuperados: \(pais.recovered)"
            self.contagiadosHoyLabel.text = "Total de contagiados hoy: \(pais.todayCases)"
            self.muertosHoyLabel.text = "Total de muertos hoy: \(pais.todayDeaths)"
            self.recuperadosHoyLabel.text = "Total de recuperados hoy: \(pais.todayRecovered)"
            let urlbandera = URL(string: pais.flag)
            self.banderaImage.load(url: urlbandera!)
        }
    }
    
}

extension ViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        paisTextField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(paisTextField.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if paisTextField.text != ""{
            return true
        }else{
            paisTextField.placeholder = "Escribe una ciudad"
            print("Por favor escibe algo ...")
            return false
        }
    }
}

