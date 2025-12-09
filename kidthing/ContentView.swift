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
    @State private var questionStartLimitPick = 2
    @State private var questionLimitPick = 2
    @State private var questionAmountPick = 5
    @State private var questionAmount = [5, 10, 20]
    @State private var showInput = false
    @State private var playerAnswer: Int?
    @State private var playerScore = 0
    @State private var answeredQuestions = 0
    
    private func startGame() {
        answeredQuestions = 0
        playerScore = 0
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
        print("\(questionList.first!.key)")
    }
    
    private func gameProcess(checkingNumber: Int) {
        if checkingNumber == questionList.first?.value ?? 0 {
            print("Answer was right")
            questionList.remove(at: questionList.startIndex)
            answeredQuestions += 1
            playerScore += 1
        } else {
            print("Answer is not right")
            questionList.remove(at: questionList.startIndex)
            answeredQuestions += 1
        }
        
        if answeredQuestions == questionAmountPick {
            print("Game has ended")
            startGame()
            return
        }
        print("\(questionList.first!.key)")
        print("Answered questions: \(answeredQuestions) / \(questionAmountPick) ")
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
            }
            Button("Start new test") {
                startGame()
                if showInput == false {
                    showInput.toggle()
                } else {
                    playerAnswer = 0
                }
            }
            if showInput {
                Section("Answer") {
                    TextField("Input answer here", value: $playerAnswer, format: .number).keyboardType(.numberPad).onSubmit {
                        gameProcess(checkingNumber: playerAnswer ?? 0)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
