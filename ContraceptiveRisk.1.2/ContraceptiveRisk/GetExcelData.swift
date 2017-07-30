//
//  GetExcelData.swift
//  ContraceptiveRisk
//
//  Created by Tak Igusa on 7/25/17.
//  Copyright © 2017 JHU. All rights reserved.
//

import Foundation
import CSVImporter

class GetExcelData {
    var stringArray = Array<Array<String>>()
    var contraceptive: [String]!
    
    init() {
//        let path = "/Users/ti/Developer/ContraceptiveRisk/SFP_MonteCarloModel_2017.04.06_SOB_ti.csv"
        let path = Bundle.main.path(forResource: "ContraceptiveRiskData", ofType: "csv")
        let importer = CSVImporter<[String]>(path: path!)
        let importedRecords = importer.importRecords{ $0 }
        for record in importedRecords {
            stringArray.append(record)
        contraceptive = ["ster", "pil1", "pil2", "IUD1", "IUD2", "inje", "impl", "cond", "with", "none"]

        }
    }
    
    func getMethodNames(indeces: [Int]) -> Array<String> {
        var methodNames = Array<String>()
        for i in indeces {
            methodNames.append(contraceptive[i])
            print(i,methodNames)
        }
        return methodNames
    }
    
    func getDatum(dataRowIndex: Int, dataColumnIndex: Int) -> Double {
        return Double(stringArray[dataRowIndex][dataColumnIndex])!
    }
}
