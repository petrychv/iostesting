//
//  MainProfileView.swift
//  Hub
//
//  Created by John Robert Prince on 25.04.2025.
//

import PhotosUI
import SwiftUI

struct MainProfileView: View {
    @StateObject var viewModel = MainProfileViewModel()
    @Binding var user: User
    @State private var aboutMe: String = ""
    @State private var selectedDate: Date?
    @State private var showDatePicker = false
    
    let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        //NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    if let profilePhoto = viewModel.profilePhoto {
                        profilePhoto
                            .resizable()
                            .scaledToFill()
                            .frame(width: ProfileImageSize.maxLarge.size, height: ProfileImageSize.maxLarge.size)
                            .clipShape(Circle())
                    } else {
                        ProfileImageView(user: user, size: .maxLarge)
                            .padding(.top, 20)
                    }
                    
                    PhotosPicker("Изменить фотографию", selection: $viewModel.selectedPhoto)
                }
                
                SettingsCell(description: "Укажите имя и, если хотите, добавьте фотографию для Вашего профиля") {
                    TextField("Имя", text: $user.name)
                        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                    Divider()
                        .padding(.leading)
                    TextField("Фамилия", text: $user.lastName)
                        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                }
                
                SettingsCell(description: "Вы можете добавить нескольо строк о себе. В настройках можно выбрать, кому они будут видны") {
                    TextField("О себе", text: $aboutMe, prompt: Text("О себе"), axis: .vertical)
                        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                }
                
                SettingsCell(description: "Ваш день рождения могут видеть только контакты.") {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showDatePicker.toggle()
                        }
                    } label: {
                        ProfileCell(data: "Дата рождения", description: selectedDate == nil ? "Указать" : "\(fullDateFormatter.string(from: selectedDate ?? Date()))")
                    }
                    
                    if showDatePicker {
                        Divider()
                            .padding(.leading)
                        
                        DatePicker(
                            "Дата рождения",
                            selection: Binding<Date>(
                                get: { selectedDate ?? Date().addingTimeInterval(-60 * 60 * 24 * 365 * 25) },
                                set: { newDate in
                                    selectedDate = newDate
                                }
                            ),
                            in: Date().addingTimeInterval(-60 * 60 * 24 * 365 * 125)...Date(),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        
                        Divider()
                            .padding(.leading)
                        
                        Button("Удалить дату рождения", role: .destructive) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedDate = nil
                                showDatePicker.toggle()
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                    }
                }
                
                SettingsCell(description: "Вы можете изменить данные профиля") {
                    NavigationLink {
                        Text("")
                    } label: {
                        ProfileCell(data: "Почта", description: "prince@mail.ru")
                    }
                    
                    Divider()
                        .padding(.leading)
                    
                    NavigationLink {
                        
                    } label: {
                        ProfileCell(data: "Имя профиля", description: "@prince")
                    }
                }
                
                Button(role: .destructive) {
                    
                } label: {
                    Text("Выйти")
                        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("formColor"))
                        }
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .safeAreaPadding(.bottom, 70)
        //}
    }
}

struct BirthdayPickerView: View {
    @State private var selectedDate: Date? = nil
    @State private var isDatePickerVisible = false
    
    // Форматтер для отображения месяца как слова
    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU") // можно заменить на нужный язык
        formatter.dateFormat = "LLLL"
        return formatter
    }()
    
    // Форматтер для отображения полной даты
    let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            if let date = selectedDate {
                Text("Выбранная дата: \(fullDateFormatter.string(from: date))")
                    .font(.title3)
            } else {
                Text("Дата рождения не указана")
                    .foregroundColor(.gray)
                    .font(.title3)
            }
            
            Button(action: {
                isDatePickerVisible.toggle()
            }) {
                Text(selectedDate == nil ? "Выбрать дату" : "Изменить дату")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            if isDatePickerVisible {
                DatePicker(
                    "Дата рождения",
                    selection: Binding<Date>(
                        get: { selectedDate ?? Date() },
                        set: { newDate in
                            selectedDate = newDate
                        }
                    ),
                    in: Date().addingTimeInterval(-60 * 60 * 24 * 365 * 100)...Date(), // Ограничение: до сегодняшней даты
                    displayedComponents: [.date]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            }
            
            if selectedDate != nil {
                Button(action: {
                    selectedDate = nil
                }) {
                    Text("Сбросить дату")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Дата рождения")
    }
}

//struct BirthdayPickerView: View {
//    @State private var day: Int = 1
//    @State private var month: Int = 1
//    @State private var year: String = "–"
//
//    // Возможные значения
//    private let days = Array(1...31)
//    private let months = ["января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"]
//    private let years: [String] = Array(1900...2025).map { String($0) } + ["–"]
//
//    var body: some View {
//        VStack(spacing: 16) {
//            ZStack(alignment: .center) {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color(.systemGray5))
//                    .frame(height: 30)
//
//                HStack(spacing: 0) {
//                    Picker("День", selection: $day) {
//                        ForEach(days, id: \.self) {
//                            Text("\($0)")
//                        }
//                    }
//                    .pickerStyle(.wheel)
//                    .accentColor(.clear)
//                    
//                    Picker("Месяц", selection: $month) {
//                        ForEach(months, id: \.self) {
//                            Text("\($0)")
//                        }
//                    }
//                    .pickerStyle(.wheel)
//                    
//                    Picker("Год", selection: $year) {
//                        ForEach(years, id: \.self) {
//                            Text($0)
//                        }
//                    }
//                    .pickerStyle(.wheel)
//                }
//            }
//
//            Button(role: .destructive) {
//                resetBirthday()
//            } label: {
//                Text("Сбросить дату")
//                    .foregroundColor(.red)
//                    .padding()
//                    .background(Color.red.opacity(0.1))
//                    .cornerRadius(8)
//            }
//
//            Spacer()
//        }
//        .padding()
//        .navigationTitle("Дата рождения")
//    }
//
//    private func resetBirthday() {
//        day = 1
//        month = 1
//        year = "-"
//    }
//}

struct SettingsCell<Content: View>: View {
    let description: String
    let content: () -> Content
    
    init(description: String, @ViewBuilder content: @escaping () -> Content) {
        self.description = description
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            content()
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("formColor"))
        }
        .padding(.top)
        
        Text(description)
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
    }
}

struct ProfileCell: View {
    //let image: String
    let data: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
//            Image(systemName: image)
//                .font(.title3)
//                .symbolRenderingMode(.multicolor)
//                .frame(width: 25)
//                .background {
//                    RoundedRectangle(cornerRadius: 6)
//                        .fill(Color.red)
//                        .padding(-5)
//                        .aspectRatio(1, contentMode: .fill)
//                    
//                }
            
            Text(data)
                .foregroundStyle(.primary)
            
            Spacer(minLength: 0)
            
            Text(description)
                .foregroundStyle(.gray)
        }
        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
    }
}

#Preview {
    NavigationStack {
        MainProfileView(user: .constant(User.MockUser))
    }
}
