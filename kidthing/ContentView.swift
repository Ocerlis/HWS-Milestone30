//
//  ContentView.swift
//  kidthing
//
//  Created by Андрей Поль on 08.12.2025.
//

import SwiftUI

struct ContentView: View {
    private struct Question {
        var firstNumber: Int
        var secondNumber: Int
        var answer: Int {
            firstNumber * secondNumber
        }
    }
    @State private var questionList = [String : Int]()
    @State private var questionTableOne = [2, 3, 4, 5, 6, 7, 8, 9, 10]
    @State private var questionTableTwo = [2, 3, 4, 5, 6, 7, 8, 9, 10]
    @State private var questionStartLimitPick = 2
    @State private var questionLimitPick = 2
    @State private var questionAmountPick = 5
    @State private var questionAmount = [5, 10, 20]
    
    private func startGame() {
        questionList.removeAll()
        var generatedQuestions = 0
        while generatedQuestions < questionAmountPick {
            let addedQuestion = Question(firstNumber: Int.random(in: questionStartLimitPick...questionLimitPick + 1), secondNumber: Int.random(in: questionStartLimitPick...questionLimitPick))
            let keyToCheck = ("\(addedQuestion.firstNumber) x \(addedQuestion.secondNumber)")
            if questionList[keyToCheck] == nil {
                        questionList[keyToCheck] = addedQuestion.answer
                        generatedQuestions += 1
            }
        }
    }
    
    var body: some View {
        Form {
            Section ("Select question amount and difficulty") {
                Picker("Question amount", selection: $questionAmountPick) {
                    ForEach(questionAmount, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }.pickerStyle(.segmented)
                
                Picker("Start difficulty", selection: $questionStartLimitPick) {
                    ForEach(2 ..< 11) {
                        Text("\($0)").disabled($0 > questionLimitPick)
                    }
                }.onChange(of: questionLimitPick) { oldValue, newValue in
                    if questionStartLimitPick > newValue {
                        questionStartLimitPick = newValue
                    }
                }
                
                Picker("Difficulty limit", selection: $questionLimitPick) {
                    ForEach(2 ..< 11) {
                        Text("\($0)").disabled($0 < questionStartLimitPick)
                    }
                }.onChange(of: questionStartLimitPick) { oldValue, newValue in
                    if questionLimitPick < newValue {
                        questionLimitPick = newValue
                    }
                }
             
                Button("Start test") {
                    startGame()
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
