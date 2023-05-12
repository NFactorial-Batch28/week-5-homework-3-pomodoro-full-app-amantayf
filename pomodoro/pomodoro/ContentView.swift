//
//  ContentView.swift
//  pomodoro
//
//  Created by Fatima Amantay on 12.05.2023.
//
import SwiftUI

struct PomodoroView: View {
    @State var focusTime: TimeInterval = 25 * 60 // default focus time is 25 minutes
    @State var breakTime: TimeInterval = 5 * 60 // default break time is 5 minutes
    @State var timerMode: TimerMode = .stopped
    @State var timeRemaining: TimeInterval = 0
    @State var history: [Date: (focusTime: TimeInterval, breakTime: TimeInterval)] = [:]

    var body: some View {
        NavigationView {
            VStack {
                Text(timeRemainingString)
                    .font(.largeTitle)
                    .padding(.top, 50)

                Spacer()

                switch timerMode {
                case .stopped, .paused:
                    Button(action: startTimer) {
                        Text("Start")
                            .font(.title)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                case .running:
                    Button(action: pauseTimer) {
                        Text("Pause")
                            .font(.title)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .foregroundColor(.white)
                            .background(Color.yellow)
                            .cornerRadius(10)
                    }
                    Button(action: stopTimer) {
                        Text("Stop")
                            .font(.title)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }

                Spacer()

                NavigationLink(destination: SettingsView(focusTime: $focusTime, breakTime: $breakTime)) {
                    Text("Settings")
                        .font(.title)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 20)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
            .navigationBarTitle("Pomodoro")
        }
    }

    var timeRemainingString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func startTimer() {
        timeRemaining = focusTime
        timerMode = .running
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                addHistoryEntry(focusTime: focusTime, breakTime: breakTime)
                timeRemaining = breakTime
            }
        }
    }

    func pauseTimer() {
        timerMode = .paused
    }

    func stopTimer() {
        timerMode = .stopped
        timeRemaining = 0
    }

    func addHistoryEntry(focusTime: TimeInterval, breakTime: TimeInterval) {
        let today = Calendar.current.startOfDay(for: Date())
        if let existingEntry = history[today] {
            history[today] = (existingEntry.focusTime + focusTime, existingEntry.breakTime + breakTime)
        } else {
            history[today] = (focusTime, breakTime)
        }
    }
}

enum TimerMode {
    case stopped
    case running
    case paused
}

struct SettingsView: View {
    @Binding var focusTime: TimeInterval
    @Binding var breakTime: TimeInterval
    
    var body: some View {
        Form {
            Section(header: Text("Focus Time")) {
                Stepper(value: $focusTime, in: 1...120, step: 1) {
                    Text("\(Int(focusTime / 60)) minutes")
                }
            }
            
            Section(header: Text("Break Time")) {
                Stepper(value: $breakTime, in: 1...60, step: 1) {
                    Text("\(Int(breakTime / 60)) minutes")
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}
