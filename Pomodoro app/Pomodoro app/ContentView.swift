//
//  ContentView.swift
//  Pomodoro app
//
//  Created by Fatima Amantay on 21.04.2023.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @State private var isFocusTime = true
    @State private var isRunning = false
    @State private var isPaused = false
    @State private var timeRemaining = 0
    @State private var focusTime = 25 // default focus time
    @State private var breakTime = 5 // default break time
    @State private var currentDate = Date()
    
    // Notification Center
    let notificationCenter = UNUserNotificationCenter.current()
    
    var body: some View {
        VStack {
            Text(isFocusTime ? "Focus Time" : "Break Time")
                .font(.largeTitle)
                .padding()
            
            Text("\(timeRemaining)")
                .font(.system(size: 60))
                .padding()
            
            HStack {
                Button(isRunning ? "Pause" : "Start") {
                    if isRunning {
                        isPaused.toggle()
                    } else {
                        startTimer()
                    }
                }
                .padding(.trailing)
                
                Button("Stop") {
                    stopTimer()
                }
                .padding(.leading)
            }
            .padding(.vertical)
            
        
            }
            
            Spacer()
        }
         {
            // Load saved focus time history
            focusTimeHistory = loadFocusTimeHistory()
        }
        .onChange(of: isPaused) { _ in
            if isPaused {
                pauseTimer()
            } else {
                resumeTimer()
            }
        }
        .sheet(isPresented: $isRunning) {
            FocusCategoryView(isFocusTime: $isFocusTime)
        }
        .sheet(isPresented: $isPaused) {
            PauseView(resumeAction: {
                isPaused = false
            })
        }
        .sheet(isPresented: $focusTimeHistory.isEmpty) {
            Text("No history yet.")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Settings") {
                    showSettings()
                }
            }
        }
    }
    
    // MARK: - Timer
    
    func startTimer() {
        isRunning = true
        timeRemaining = isFocusTime ? focusTime : breakTime
        
        // Create timer
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timeRemaining -= 1
            
            // Update notification when app is in the background
            updateNotification()
            
            // Switch to break time
            if timeRemaining == 0 {
                isFocusTime.toggle()
                timeRemaining = isFocusTime ? focusTime : breakTime
                addFocusTimeRecord()
                playSound()
            }
        }
    }
    
    func pauseTimer() {
        // Pause timer
    }
    
    func resumeTimer() {
        // Resume timer
    }
    
    func stopTimer() {
        // Stop timer
        isRunning = false
        timeRemaining = 0
    }
    
    // MARK: - Focus Time History
    
    func addFocusTimeRecord() {
        let focusTimeRecord = FocusTimeRecord(date: currentDate, duration: isFocusTime ? focusTime : breakTime)
        focusTimeHistory.append(focusTimeRecord)
        saveFocusTimeHistory()
    }
    
    func loadFocusTimeHistory() -> [FocusTimeRecord] {
        // Load focus time history from storage
        return []
    }
    
    func saveFocusTimeHistory() {
        // Save focus time history to storage
    }
    
    func show
    struct HistoryView: View {
        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \FocusTime.start, ascending: false)],
            animation: .default)
        private var focusTimes: FetchedResults<FocusTime>

        var body: some View {
            NavigationView {
                List {
                    ForEach(focusTimes, id: \.self) { focusTime in
                        Section(header: Text(formatDate(focusTime.start))) {
                            HStack {
                                Text("Focus Time: \(formatTime(focusTime.focusDuration))")
                                Spacer()
                                Text("Break Time: \(formatTime(focusTime.breakDuration))")
                            }
                        }
                    }
                }
                .navigationTitle("History")
            }
        }

        private func formatDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
            return dateFormatter.string(from: date)
        }

        private func formatTime(_ duration: Int64) -> String {
            let minutes = duration / 60
            let seconds = duration % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    struct NotificationManager {
        static func scheduleNotification(title: String, body: String, date: DateComponents) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default

            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
    }

    struct contentView: View {
        @AppStorage("focusDuration") private var focusDuration: Int = 25
        @AppStorage("breakDuration") private var breakDuration: Int = 5

        @State private var isRunning = false
        @State private var isFocusTime = true
        @State private var progress: CGFloat = 0.0
        @State private var timer: Timer?
        @State private var startTime: Date?
        @State private var remainingTime: Int = 0

        var body: some View {
            NavigationView {
                VStack(spacing: 32) {
                    ProgressView(value: progress)
                        .progressViewStyle(CircularProgressViewStyle(tint: isFocusTime ? .red : .green))
                        .scaleEffect(2.0)
                        .onAppear {
                        }

                    Text(formatTime(remainingTime))
                        .font(.system(size: 64, weight: .bold))
                        .onTapGesture {
                            isRunning.toggle()
                            if isRunning {
                                startTimer()
                            } else {
                                pauseTimer()
                            }
                        }

                    HStack(spacing: 32) {
                        Button("Stop") {
                            stopTimer()
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 32)
                        .background(Color.red)
                        .cornerRadius(16)

                        Button(isRunning ? "Pause" : "Resume") {
                            isRunning.toggle()
                            if isRunning {
                                startTimer()
                            } else {
                                pauseTimer()
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 32)
                        .background(Color.green)
                        .cornerRadius(16)
                    }
                    .padding(.bottom, 32)

                    Button("Category") {
                        // Show bottom sheet for focus category
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .background(Color.blue)
                    .cornerRadius(16)

                    NavigationLink(destination: (focusDuration: $focusDuration, breakDuration: $breakDuration)) {
                        Text("Settings")
                    }
                }
                .navigationTitle(isFocusTime ? "Focus Time" : "Break Time")
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) {
                }
            }
        }

        private func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                remainingTime -= 1
                progress = CGFloat(remainingTime) / CGFloat(isFocusTime ? focusDuration * 60 : breakDuration * 60)
                if remainingTime <= 0 {
                    isFocusTime.toggle()
                    remainingTime = isFocusTime ? focusDuration * 60 : breakDuration * 60
    
                    }
                
                struct ContentView: View {
                    @AppStorage("focusTime") private var focusTime: Int = 25
                    @AppStorage("breakTime") private var breakTime: Int = 5

                    var body: some View {
                        TabView {
                           
                                }
                            HistoryView()
                                .tabItem {
                                    Label("History", systemImage: "clock")
                                }
                        }
                    }
                }

                    }
                                                             }

