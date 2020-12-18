//
//  CovidManager.swift
//  Covid
//
//  Created by Mac15 on 18/12/20.
//

import Foundation

protocol CovidManagerDelegate {
    func actualizaPais(pais: CovidModel)
    func huboError(cualError: Error)
}

struct CovidManager{
    var delegado: CovidManagerDelegate?
        let covidURL = "https://corona.lmao.ninja/v3/covid-19/countries"
        
        func fetchCovid(nombreCiudad: String){
            let urlString = "\(covidURL)/\(nombreCiudad)"
            print(urlString)
            realizarSolicitud(urlString: urlString)
        }
        func realizarSolicitud(urlString: String){
            //Crear url
            if let url = URL(string: urlString){
                //Crear obj URLSession
                let session = URLSession(configuration: .default)
                //Asigna una tarea a las sesion
                let tarea = session.dataTask(with: url){(data, respuesta, error) in
                    if error != nil{
                        print("Error en solicitud")
                        self.delegado?.huboError(cualError: error!)
                        return
                    }
                    
                    if let datosSeguros = data{
                        if let pais = self.parseJSON(covidData: datosSeguros){
                            self.delegado?.actualizaPais(pais: pais)
                        }
                    }
                }
                //Empezar tarea
                tarea.resume()
            }
        }
    func parseJSON(covidData: Data) -> CovidModel? {
            let decoder = JSONDecoder()
            
            do{
                let dataDecodificada = try decoder.decode(CovidData.self, from: covidData)
               
                let nombre = dataDecodificada.country
                let casos = dataDecodificada.cases
                let muertes = dataDecodificada.deaths
                let recuperados = dataDecodificada.recovered
                let casosHoy = dataDecodificada.todayCases
                let muertesHoy = dataDecodificada.todayDeaths
                let recuperadosHoy = dataDecodificada.todayRecovered
                let bandera = dataDecodificada.countryInfo.flag
                let ObjClima = CovidModel(country: nombre, cases: casos, deaths: muertes, recovered: recuperados, todayCases: casosHoy, todayDeaths: muertesHoy, todayRecovered: recuperadosHoy, flag: bandera)
                return ObjClima
                
            }catch{
                print("Error en parse")
                delegado?.huboError(cualError: error)
                return nil
            }
        }
}
