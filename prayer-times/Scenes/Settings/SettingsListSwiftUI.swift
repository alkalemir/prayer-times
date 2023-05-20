//
//  SettingsListSwiftUI.swift
//  FinalMuslim
//
//  Created by Emir Alkal on 18.06.2022.
//

import SwiftUI

struct SettingsListSwiftUI: View {
    
    @State var isOn = false
    @State var selectedMinute = "15 dakika önce"
    let minutes = ["15 dakika önce", "30 dakika önce", "45 dakika önce"]
    @State private var isSharePresented: Bool = false
    
    var body: some View {
        NavigationView {
                VStack {
                    Section {
                        List {
                            Toggle(isOn: $isOn) {
                                Text("Namaz bildirimlerini aç")
                            }.onAppear(perform: {
                                if selectedMinute == minutes[0] {
                                    UserDefaults.standard.set(15 * 60, forKey: "timeInterval")
                                } else if selectedMinute == minutes[1] {
                                    UserDefaults.standard.set(30 * 60, forKey: "timeInterval")
                                } else {
                                    UserDefaults.standard.set(45 * 60, forKey: "timeInterval")
                                }
                            }).onChange(of: isOn, perform: { newValue in
                                let center = UNUserNotificationCenter.current()
                                center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                                    if granted {
                                        print("we have permission")
                                    } else {
                                        DispatchQueue.main.async {
                                            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                                        }
                                    }
                                }
                            }).listRowBackground(Color(UIColor(named: "background-color")!))
                            if isOn {
                                Picker("Tip Percentage", selection: $selectedMinute) {
                                    ForEach(minutes, id: \.self) {
                                        Text("\($0)")
                                    }
                                }.onChange(of: selectedMinute, perform: { newValue in
                                    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                                    if selectedMinute == minutes[0] {
                                        UserDefaults.standard.set(15 * 60, forKey: "timeInterval")
                                    } else if selectedMinute == minutes[1] {
                                        UserDefaults.standard.set(30 * 60, forKey: "timeInterval")
                                    } else {
                                        UserDefaults.standard.set(45 * 60, forKey: "timeInterval")
                                    }
                                }).pickerStyle(.segmented)
                                    .listRowBackground(Color(UIColor(named: "background-color")!))
                            }
                            Section {
                                HStack {
                                    Text("Share that app")
                                    Spacer()
                                    Button {
                                        self.isSharePresented = true
                                    } label: {
                                        Image(systemName: "square.and.arrow.up")
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                                    }
                                    .sheet(isPresented: $isSharePresented, onDismiss: {
                                        print("Dismiss")
                                    }, content: {
                                        ActivityViewController(activityItems: [URL(string: "https://www.apple.com")!])
                                    })
                                }
                            }
                                .listRowBackground(Color(UIColor(named: "background-color")!))
                        }
                    }
                }
                .navigationTitle("Settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsListSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        SettingsListSwiftUI()
    }
}
