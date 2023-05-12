//
//  ContentView.swift
//  ClassificadorTexto
//
//  Created by Marília de Sousa on 04/05/23.
//

import SwiftUI
import NaturalLanguage

struct TokensView: View {
    @State var letraMusica: [String] = []//palavras()
    var body: some View {
        Text(letraMusica.description)
            .onAppear {
                //let nlp = NaturalLanguage()
                //let output = nlp.process(Model.lyrics)
                //print(output)
            }
    }
}



//func palavras() -> [String] {
//    let tokenizer = NLTokenizer(unit: .sentence )
//    tokenizer.string = Model.lyrics
//    var resultado = [String]()
//    tokenizer.enumerateTokens(in: Model.lyrics.startIndex..<Model.lyrics.endIndex) {tokenRange, _ in
//        resultado.append(String(Model.lyrics[tokenRange]))
//        print(resultado)
//        return true
//    }
//    return resultado
//}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
