//
//  main.swift
//  TranspositionCipher
//
//  Created by Mihnea Stefan on 27/04/2020.
//  Copyright © 2020 Mihnea Stefan. All rights reserved.
//

import Foundation

class TranspositionCipher{
    
    var text : String
    var key : String
    var asciiK : [Int]
    
    init(plaintext P : String , key K : String){
        self.text = P
        self.key = K
        asciiK = []
        for character in key{
            asciiK.append(Int(character.asciiValue!))
        }
    }

    func encrypt(){
        var tMatrix = [(key : Int, stream : String)]()
        var matrix = [[Character]]()
        var string = [Character]()
        
        for i in 0..<text.count{
            let index = text.index( text.startIndex, offsetBy: i)
            if (i+1) % key.count == 0{
                string.append(text[index])
                 matrix.append(string)
                string.removeAll()
            }else{
                string.append(text[index])
            }
        }
        
        matrix.append(string)
        
        for s in 0..<asciiK.count{
            tMatrix.append((key: asciiK[s], stream: ""))
            for i in 0..<matrix.count{
                for j in 0..<matrix[i].count{
                    if j == s {
                        tMatrix[s].stream+=String(matrix[i][j])
                    }
                }
            }
        }
        for i in 1..<tMatrix.count{
            for j in (1...i).reversed(){
                if tMatrix[j-1].key > tMatrix[j].key{
                    tMatrix.swapAt(j-1, j)
                }else{
                    break
                }
            }
        }
        text.removeAll()
        for i in tMatrix{
            text+=i.stream
        }
        print("Encrypted text \(text)")
    }

    func decrypt(){
        let cat = text.count/key.count
        let rest = text.count%key.count
        var tMatrix = [(key : Int, position : Int, stream : [Character])]()
        var matrix = [[Character]]()
        for i in 0..<asciiK.count{
            tMatrix.append((key: asciiK[i], position: i+1, stream: []))
        }
        
        for i in 1..<tMatrix.count{
            for j in (1...i).reversed(){
                if tMatrix[j-1].key > tMatrix[j].key{
                    tMatrix.swapAt(j-1, j)
                }else{
                    break
                }
            }
        }
        
        for i in 0..<tMatrix.count{
            if tMatrix[i].position<=rest{
                for _ in 0...cat{
                    let index = text.startIndex
                    tMatrix[i].stream+=String(text[index])
                    text.remove(at: index)
                }
            }else{
                if text.count>cat{
                for _ in 0..<cat{
                    let index = text.startIndex
                    tMatrix[i].stream+=String(text[index])
                    text.remove(at: index)
                }
                }else{
                    for _ in 0..<text.count{
                        let index = text.startIndex
                        tMatrix[i].stream+=String(text[index])
                        text.remove(at: index)
                    }
                    text.removeAll()
                }
            }
        }
        for i in 1..<tMatrix.count{
                   for j in (1...i).reversed(){
                       if tMatrix[j-1].position > tMatrix[j].position{
                           tMatrix.swapAt(j-1, j)
                       }else{
                           break
                       }
                   }
               }
       
        for i in 0..<tMatrix.count{
            matrix.append(tMatrix[i].stream)
        }
        text = ""
        var counter = 0
        transformation : while true{
            text+=String(matrix[counter].remove(at: 0))
            if counter == matrix.count-1{
                counter = 0
            }else{
                counter+=1
            }
            if matrix[counter].isEmpty{
                break
            }
        }
        print("Decrypted text \(text)")
    }
}

var object = TranspositionCipher(plaintext: "MEETINGWILLBEONFRIDAYATELEVENTHIRTY", key: "31524")
object.encrypt()
object.decrypt()
