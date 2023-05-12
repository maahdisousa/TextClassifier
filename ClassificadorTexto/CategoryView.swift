//
//  MarcaçãoUIView.swift
//  ClassificadorTexto
//
//  Created by Marília de Sousa on 10/05/23.
//

import SwiftUI
import NaturalLanguage

//static let portuguese: NLLanguage

/*
 init -> letraMusica -> self -> onAppear -> self.tags() OK
 init -> letraMusica = self.tags() sem self! Erro
 */

struct CategoryView: View {
    
    @State var letraMusica: [String] = []
    
    var body: some View {
        Text(letraMusica.description)
            .onAppear {
                letraMusica = tags()
                embbedings(words: letraMusica)
            }
    }
    
    func palavras() -> [String] {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = Model.lyrics
        var resultado = [String]()
        tokenizer.enumerateTokens(in: Model.lyrics.startIndex..<Model.lyrics.endIndex) {tokenRange, _ in
            resultado.append(String(Model.lyrics[tokenRange]))
            print(resultado)
            return true
        }
        return resultado
    }
    
    // TODO: parametrizar o Model.lyrics
    func tags() -> [String] {
        var nounAdjVerb = [String]()
        
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = Model.lyrics
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
        //var endTags = [String]()
        let strRange = Model.lyrics.startIndex ..< Model.lyrics.endIndex
        tagger.enumerateTags(
            in: strRange,
            unit: .word,
            scheme: .lexicalClass,
            options: options,
            using: { (tag, tagRange) in
                //endTags.append(String(Model.lyrics[tagRange]))
                let tagText = Model.lyrics[tagRange]
                if let lexicalClass = tag?.rawValue {
                    print("\(tagText): \(lexicalClass)")
                    if lexicalClass == "Noun" || lexicalClass == "Adjective" || lexicalClass == "Verb" {
                        nounAdjVerb.append("\(tagText)")
                    }
                }
                return true
            }
        )
        print(nounAdjVerb)
        return nounAdjVerb
    }
    
    
    func embbedings(words: [String]) {
        
        var distanceDict: [String: [(String, distance: Double)]] = [:]
        
        /// # Pegando as 10 palavras mais proximas de erotico e sexual e mostrando a pontuacao
        //        if let embedding = NLEmbedding.wordEmbedding(for: .portuguese) {
        //            embedding.enumerateNeighbors(for: "erótico", maximumCount: 10) { neighbor, distance in
        //                print("erotico \(neighbor): \(distance.description)")
        //                return true
        //            }
        //            embedding.enumerateNeighbors(for: "sexual", maximumCount: 10) { neighbor, distance in
        //                print("sexual \(neighbor): \(distance.description)")
        //                return true
        //            }
        //        }
        //        print("\n")
        
        //TODO: Criar arrays que armazena as palavras proximas de cada keyword (sexual, erotico, traicao, violencia)
        //TODO: Criar arrays que armazena as palavras de distancia 2 de cada keyword (sexual, erotico, traicao, violencia), ou seja as que o modelo nao sabe analisar
        
        /// # Varrendo o array de strings passado pelo parametro, e analisando a distancia de cada palavra (uma por uma) de sexual e erotico
        if let embedding = NLEmbedding.wordEmbedding(for: .portuguese) {
            
            print(words.count)
            
            for word in words {
                // printando todas as distancias que o modelo tem pra essa palavra (e todas as outras)
                //                if let vector = embedding.vector(for: word) {
                //                    print(vector)
                //                }
                
                // TODO: Código replicado! Transformar o códig oque se repete em função. Modelar os parametros como sendo o que não se repete. DistanceDict pode se tornar global pra ser acessado dentro da função, ou pode ser usado como está, mas recebendo como valor o retorno da função (savedWords).
                /// # Calcula a distância entre a palavra da iteração e a palavra sexual
                let specificDistanceSexual = embedding.distance(between: word, and: "sexual")
                if specificDistanceSexual < 1.1 || specificDistanceSexual == 2.0 {
                    print("\(word) - sexual", specificDistanceSexual.description) // printa a distância
                    var savedWords1 = distanceDict["sexual"] ?? []
                    savedWords1.append((word, specificDistanceSexual))
                    distanceDict["sexual"] = savedWords1
                    
                }
                
                /// # Calcula a distância entre a palavra da iteração e a palavra erótico
                let specificDistanceErotic = embedding.distance(between: word, and: "erótico")
                if specificDistanceErotic < 1.1 || specificDistanceErotic == 2.0 {
                    print("\(word) - erótico", specificDistanceErotic.description) // printa a distância
                    var saveWords2 = distanceDict["erótico"] ?? []
                    saveWords2.append((word, specificDistanceErotic))
                    distanceDict["erótico"] = saveWords2
                }
                //                print(distanceEroticDict)
                
                /// # Calcula a distância entre a palavra da iteração e a palavra traição
                let specificDistanceBetrayal = embedding.distance(between: word, and: "traição")
                if specificDistanceBetrayal < 1.1 || specificDistanceBetrayal == 2.0 {
                    print("\(word) - traição", specificDistanceBetrayal.description) // printa a distância
                    var saveWords3 = distanceDict["traição"] ?? []
                    saveWords3.append((word, specificDistanceBetrayal))
                    distanceDict["traição"] = saveWords3
                }
                //                print(distanceEroticDict)
                
                /// # Calcula a distância entre a palavra da iteração e a palavra violência
                let specificDistanceViolence = embedding.distance(between: word, and: "violência")
                if specificDistanceViolence < 1.1 || specificDistanceViolence == 2.0 {
                    print("\(word) - violência", specificDistanceViolence.description) // printa a distância
                    var saveWords4 = distanceDict["violência"] ?? []
                    saveWords4.append((word, specificDistanceViolence))
                    distanceDict["violência"] = saveWords4
                }
                //                print(distanceViolenceDict)
                
            }
        }
        
        print("RESULTADO")
        
        // [String: [(String, distance: Double)]]
        /*
         distanceDict.keys é um [String]
         distanceDict.values é um [[(String, distance: Double)]]
         Digamos que...
            distanceDict.values = [
                [("a", distance: 0.1), ("b", distance: 0.1)],
                [("c", distance: 0.3)],
            ]
         então distanceDict.values[0] é [("a", distance: 0.1), ("b", distance: 0.1)]
         e distanceDict.values[0][0] é ("a", distance: 0.1)
         
         Um exemplo completo de distanceDict seria:
         {
             "erótico": [
                ("Parece", distance: 2.0),
                ("Sabe", distance: 2.0),
                ("Me", distance: 2.0),
                ("Sabe", distance: 2.0),
                ("Você", distance: 2.0),
                ("É", distance: 2.0),
                ("fudido", distance: 2.0)
             ],
             "violência": [
                ("Parece", distance: 2.0),
                ("Sabe", distance: 2.0),
                ("Me", distance: 2.0),
                ("Sabe", distance: 2.0),
                ("Você", distance: 2.0),
                ("É", distance: 2.0),
                ("fudido", distance: 2.0)
             ],
             "sexual": [
                ("Parece", distance: 2.0),
                ("Sabe", distance: 2.0),
                ("Me", distance: 2.0),
                ("Sabe", distance: 2.0),
                ("Você", distance: 2.0),
                ("É", distance: 2.0),
                ("fudido", distance: 2.0)
             ],
             "traição": [
                ("Parece", distance: 2.0),
                ("Sabe", distance: 2.0),
                ("Me", distance: 2.0),
                ("Sabe", distance: 2.0),
                ("raiva", distance: 1.2871456146240234),
                ("Você", distance: 2.0),
                ("É", distance: 2.0),
                ("fudido", distance: 2.0)
             ]
         }
         */
        
        /* Quando fazemos um for num dicionario, durante esse for, ele se transforma em array de tupla. Depois ele volta ao normal.
        [
            (
                 key: "erótico",
                 value: [
                   ("Parece", distance: 2.0),
                   ("Sabe", distance: 2.0),
                   ("Me", distance: 2.0),
                   ("Sabe", distance: 2.0),
                   ("Você", distance: 2.0),
                   ("É", distance: 2.0),
                   ("fudido", distance: 2.0)
                ]
            ),
            (
                key: "traição",
                value: [
                   ("Parece", distance: 2.0),
                   ("Sabe", distance: 2.0),
                   ("Me", distance: 2.0),
                   ("Sabe", distance: 2.0),
                   ("Você", distance: 2.0),
                   ("É", distance: 2.0),
                   ("fudido", distance: 2.0)
                ]
            )
        ]
        */
        // TODO: Printar só os que tem distancia 2.0
        // TODO: Printar só os que tem distancia 1.1
        // element é uma tupla do tipo (key: String, value: [(String, distance: Double)])
        for element in distanceDict {
            print("\n")
            let analysedWord = element.key // erotico
            let arrayLyricWordsWithDistance = element.value // array do tipo [(String, distance: Double)]
            
            // wordTuple é do tipo (String, distance: Double)
            for wordTuple in arrayLyricWordsWithDistance {
                let lyricWord = wordTuple.0
                let distance = wordTuple.distance
                
                print(distance, "|", analysedWord, "-", lyricWord)
            }
        }
        
    }
    
    
    
}


//"paz"
//
//var dict = ["sexual" : ["bla":  1.2]]
//
//
//var sexualDict =  dict["sexual"]  ?? [:] //   ["bla":  1,2]
//
//sexualDict["paz"] = 1.8  //
//
//dict["sexual"] = sexualDict // ["sexual" :["bla":  1,2, "paz": 1.8]]


// TODO: Possibilidade de refatorar o dicionário pra Array de um tipo customizado (preferencialmente struct, mas poderia ser class, ou tupla) que agrupa as infos de palavra analisada, palavra da letra da musica, e distancia.
/*
[
    Analysis(analysedWord: "erotico", lyricsWord: "bebida", distance: 0.1)
]
*/
//struct Analysis {
//    let analysedWord: String // traicao
//    let lyricsWord: String // bebida
//    let distance: Double // 0.1
//}
