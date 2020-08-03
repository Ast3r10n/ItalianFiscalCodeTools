//
//  ItalianFiscalCodeTools.swift
//
//  Created by fms on 16/04/2020.
//

import Foundation

public enum ItalianFiscalCodeTools {
  static func checkFiscalCode(_ fiscalCode: String,
                       name: String,
                       surname: String,
                       birthDate: String,
                       birthPlace: String) throws -> Bool {

    let meseLettere = ["A", "B", "C", "D", "E", "H", "L", "M", "P", "R", "S", "T"]
    try ItalianFiscalCodeTools.validateFiscalCode(fiscalCode.uppercased())

    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    guard let date = formatter.date(from: birthDate) else {
      throw NSError(domain: "ItalianFiscalCodeTools", code: 5, userInfo: [
        NSLocalizedDescriptionKey: "data nascita errata"
      ])
    }

    /*
     let cfCalc = CFCalc(name: nome, surname: cognome, female: true, date: date, codComune: luogoNascita)
     print(codiceFiscale)
     print(cfCalc)
     */

    let calendar = Calendar.current
    let year = calendar.component(.year, from: date) % 100
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)

    if let fiscalCodeYear = Int(fiscalCode.dropFirst(6).prefix(2)),
      fiscalCodeYear != year {

      throw NSError(domain: "ItalianFiscalCodeTools", code: 1, userInfo: [
        NSLocalizedDescriptionKey: "anno nascita non coincide"
      ])
    }


    if fiscalCode.dropFirst(8).prefix(1) != meseLettere[month - 1] {
      throw NSError(domain: "ItalianFiscalCodeTools", code: 2, userInfo: [
        NSLocalizedDescriptionKey: "mese nascita non coincide"
      ])
    }

    if let fiscalCodeDay = Int(fiscalCode.dropFirst(9).prefix(2)) {
      if fiscalCodeDay != day && fiscalCodeDay != (day + 40) {
        throw NSError(domain: "ItalianFiscalCodeTools", code: 3, userInfo: [
          NSLocalizedDescriptionKey: "giorno nascita non coincide"
        ])
      }
    }

    if cities[birthPlace.uppercased()] != String(fiscalCode.dropFirst(11).prefix(3)) {
      throw NSError(domain: "ItalianFiscalCodeTools", code: 4, userInfo: [
        NSLocalizedDescriptionKey: "luogo di nascita errato"
      ])
    }

    return true
  }

  /// Validates a given Fiscal Code.
  ///
  /// - parameter fiscalCode: The Fiscal Code to validate.
  public static func validateFiscalCode(_ fiscalCode: String) throws {
    guard fiscalCode.count == 16 else {
      throw NSError(domain: "ItalianFiscalCodeTools", code: 3, userInfo: [
        NSLocalizedDescriptionKey: "La lunghezza del Codice Fiscale non è corretta. Deve essere 16 caratteri."
      ])
    }

    var fiscalCode = fiscalCode.uppercased()

    guard var lastCharacter = fiscalCode.popLast()?.utf8.first else {
      throw NSError(domain: "ItalianFiscalCodeTools", code: 3, userInfo: [
        NSLocalizedDescriptionKey: "Errore inatteso."
      ])
    }

    lastCharacter -= 65

    let regEx = "[A-Z0-9a-z]*$"

    let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
    guard predicate.evaluate(with: fiscalCode) else {
      throw NSError(domain: "ItalianFiscalCodeTools", code: 3, userInfo: [
        NSLocalizedDescriptionKey: "Il Codice Fiscale contiene dei caratteri non validi."
      ])
    }

    let setdisp = [1, 0, 5, 7, 9, 13, 15, 17, 19, 21, 2, 4, 18, 20,
                   11, 3, 6, 8, 12, 14, 16, 10, 22, 25, 24, 23]
    var s = 0
    var isEven = false
    let asciiCodes = fiscalCode.utf8
    asciiCodes.forEach { code in
      let diff: Int
      if code >= 48, code <= 57 {
        diff = Int(code) - 48
      } else {
        diff = Int(code) - 65
      }

      if isEven {
        s += diff
      } else {
        s += setdisp[diff]
      }
      isEven.toggle()
    }

    let checkChar = s % 26

    if lastCharacter != checkChar {
      throw NSError(domain: "ItalianFiscalCodeTools", code: 3, userInfo: [
        NSLocalizedDescriptionKey: "codice fiscale errato"
      ])
    }

    return
  }
}
