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
    @State private var questionAmountLimit = 5
    @State private var perfectResultAlert = false
    @State private var goodResultAlert = false
    @State private var badResultAlert = false
    @State private var checkLastQuestion = "questionmark.app.fill"
    @State private var colorOfQuestionSymbol = false
    @State private var questionAnswered = false
    private func startGame() {
        questionAmountLimit = questionAmountPick
        answeredQuestions = 0
        playerScore = 0
        questionList.removeAll()
        var generatedQuestions = 0
        while generatedQuestions <= questionAmountLimit {
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
        questionAnswered = true
        if checkingNumber == questionList.first?.value ?? 0 {
            print("Answer was right")
            colorOfQuestionSymbol = true
            checkLastQuestion = "checkmark.square.fill"
            answeredQuestions += 1
            playerScore += 1
            questionList.remove(at: questionList.startIndex)
        } else {
            print("Answer is not right")
            colorOfQuestionSymbol = false
            checkLastQuestion = "multiply.square.fill"
            answeredQuestions += 1
            questionList.remove(at: questionList.startIndex)
        }
        
        if answeredQuestions == questionAmountLimit {
            print("Game has ended")
            
            if playerScore == questionAmountLimit {
                perfectResultAlert = true
            } else if playerScore > (questionAmountLimit / 2) {
                goodResultAlert = true
            } else {
                badResultAlert = true
            }
            
            startGame()
            return
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
                    ForEach(2 ..< 11, id: \.self) {
                        Text("\($0)").disabled($0 > questionLimitPick)
                    }
                }.onChange(of: questionLimitPick) { oldValue, newValue in
                    if questionStartLimitPick > newValue {
                        questionStartLimitPick = newValue
                    }
                }
                
                Picker("Difficulty limit", selection: $questionLimitPick) {
                    ForEach(2..<11, id: \.self) {
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
                Section {
                    if questionAnswered {
                        HStack {
                            Spacer()
                            Image(systemName: checkLastQuestion).resizable().scaledToFit().frame(width: 50, height: 50).foregroundStyle(colorOfQuestionSymbol && (checkLastQuestion == "checkmark.square.fill" || checkLastQuestion == "multiply.square.fill") ? Color.green : Color.red)
                            Spacer()
                        }.listRowSeparator(.hidden)
                    }
                    Text("""
                         Questions answered
                         \(answeredQuestions) / \(questionAmountLimit)
                         """).frame(maxWidth: .infinity).multilineTextAlignment(.center)
                }.alert("You're perfect!", isPresented: $perfectResultAlert) {
                    Button("Start new test", role: .cancel) { }
                }
                
                Section {
                    Text("""
                         Question:
                         \(questionList.first?.key ?? "You finished!")?
                         """).frame(maxWidth: .infinity).multilineTextAlignment(.center)
                }.alert("You're getting good!", isPresented: $goodResultAlert) {
                    Button("Start new test", role: .cancel) { }
                }
                
                Section("Answer") {
                    TextField("Input answer here", value: $playerAnswer, format: .number).keyboardType(.numberPad).onSubmit {
                        gameProcess(checkingNumber: playerAnswer ?? 0)
                    }
                }.alert("You're result is bad, keep trying!", isPresented: $badResultAlert) {
                    Button("Start new test", role: .cancel) { }
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
