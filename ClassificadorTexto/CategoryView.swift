//
//  MarcaçãoUIView.swift
//  ClassificadorTexto
//
//  Created by Marília de Sousa on 10/05/23.
//

import SwiftUI
import NaturalLanguage


struct CategoryView: View {
    
    @State var letraMusica: [String] = []
    
    let referenceWords = ["sexual", "erótico", "traição", "violência", "amor"]
    
    var body: some View {
        Text(letraMusica.description)
            .onAppear {
                
                for (n, lyric) in Model.allLyrics.enumerated() {
                    print("LETRA \(n)")
                    letraMusica = tags(lyric: lyric)
                    embbedings(words: letraMusica)
                }
            }
    }
    
    func calculateDistanceLow(lyricsWord: String, embedding: NLEmbedding, referenceWord: String) -> (String, Double)? {
        let specificDistance = embedding.distance(between: lyricsWord, and: referenceWord)
        //        print(specificDistance)
        if specificDistance < 1.1 {
            return (lyricsWord, specificDistance)
        }
        return nil
    }
    
    func calculateDistanceHigh(lyricsWord: String, embedding: NLEmbedding, refereceWord: String) -> (String, Double)? {
        let specificDistance = embedding.distance(between: lyricsWord, and: refereceWord)
        if specificDistance == 2.0 {
            return (lyricsWord, specificDistance)
        }
        return nil
    }
    

    func palavras() -> [String] {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = Model.lyrics
        var resultado = [String]()
        tokenizer.enumerateTokens(in: Model.lyrics.startIndex..<Model.lyrics.endIndex) {tokenRange, _ in
            resultado.append(String(Model.lyrics[tokenRange]))
            //            print(resultado)
            return true
        }
        return resultado
    }
    
    
    func tags(lyric: String) -> [String] {
        var nounAdjVerb = [String]()
        
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = lyric
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
        //var endTags = [String]()
        let strRange = lyric.startIndex ..< lyric.endIndex
        tagger.enumerateTags(
            in: strRange,
            unit: .word,
            scheme: .lexicalClass,
            options: options,
            using: { (tag, tagRange) in
                //endTags.append(String(Model.lyrics[tagRange]))
                let tagText = lyric[tagRange]
                if let lexicalClass = tag?.rawValue {
                    //                    print("\(tagText): \(lexicalClass)")
                    if lexicalClass == "Noun" || lexicalClass == "Adjective" || lexicalClass == "Verb" {
                        nounAdjVerb.append("\(tagText)")
                    }
                }
                return true
            }
        )
        //        print(nounAdjVerb)
        return nounAdjVerb
    }
    
    
    func embbedings(words: [String]) {
        
        var distanceDictLow: [String: [(String, distance: Double)]] = [:]
        var distanceDictHigh: [String: [(String, distance: Double)]] = [:]
        
        
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
        
        
        
        /// # Varrendo o array de strings passado pelo parametro, e analisando a distancia de cada palavra (uma por uma) de sexual e erotico
        if let embedding = NLEmbedding.wordEmbedding(for: .portuguese) {
            
//                        print(words.count)
            
            
            // printando todas as distancias que o modelo tem pra essa palavra (e todas as outras)
            //                if let vector = embedding.vector(for: word) {
            //                    print(vector)
            //                }
            
            
            for word in words {
                
                // printando todas as distancias que o modelo tem pra essa palavra (e todas as outras)
                //                if let vector = embedding.vector(for: word) {
                //                    print(vector)
                //                }
                
                for referenceWord in referenceWords {
                    if let tuplaLow = calculateDistanceLow(lyricsWord: word,
                                                           embedding: embedding,
                                                           referenceWord: referenceWord) {
                        var arrayLow = distanceDictLow[referenceWord] ?? []
                        arrayLow.append(tuplaLow)
                        distanceDictLow[referenceWord] = arrayLow
                    }
                    if let tuplaHigh = calculateDistanceHigh(lyricsWord: word,
                                                             embedding: embedding,
                                                             refereceWord: referenceWord) {
                        var arrayHigh = distanceDictHigh[referenceWord] ?? []
                        arrayHigh.append(tuplaHigh)
                        distanceDictHigh[referenceWord] = arrayHigh
                    }
                    
                    //                 [
                    //                 Analysis(analysedWord: "erotico", lyricsWord: "bebida", distance: 0.1)
                    //                 ]
                    //                 */
                    //struct Analysis {
                    //    let analysedWord: String // traicao
                    //    let lyricsWord: String // bebida
                    //    let distance: Double // 0.1
                    //}
                    
                }
            }
            beautifulPrint(dict: distanceDictLow)
//            beautifulPrint(dict: distanceDictHigh)
        }
        
        func beautifulPrint(dict: [String: [(String, Double)]]) {
            for element in dict {
                print("\n")
                print(element.key)
                let arrayLyricWordsWithDistance = element.value
                for wordTuple in arrayLyricWordsWithDistance {
                    print(wordTuple)
                }
            }
            
        }
    }
}

// DONES:
// Printar só os que tem distancia menor que 1.1
// Printar só os que tem distancia 2.0
// Código replicado! Transformar o código que se repete em função. Modelar os parametros como sendo o que não se repete. DistanceDict pode se tornar global pra ser acessado dentro da função, ou pode ser usado como está, mas recebendo como valor o retorno da função (savedWords).
// Criar arrays que armazena as palavras proximas de cada keyword (sexual, erotico, traicao, violencia)
// Criar arrays que armazena as palavras de distancia 2 de cada keyword (sexual, erotico, traicao, violencia), ou seja as que o modelo nao sabe analisar


// TODOS:
// TODO: Possibilidade de refatorar o dicionário pra Array de um tipo customizado (preferencialmente struct, mas poderia ser class, ou tupla) que agrupa as infos de palavra analisada, palavra da letra da musica, e distancia.
// TODO: Parametrizar o Model.lyrics

/*
 música, amor, sexual, violência, traição
 foo, 2, 5, 6, 2
 bar, 6, 5, 6, 2
 
 música, palavra, amor, sexual, violência, traição, erótico
 foo   , amor   ,   0,     0,        0,     1.03
 foo   , raiva  ,   0,     0,        0,     0.93
 bar   , bebida ,   0,     0,        0,     0.93
 */
