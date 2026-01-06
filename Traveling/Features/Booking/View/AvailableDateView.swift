//
//  AvailableDateView.swift
//  Traveling
//
//  Created by Daniel Retamal on 04-01-26.
//

import SwiftUI

struct AvailableDateView: View {
    let tour: Tour
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.PathRouter<BookingRoutes>.self) private var router
    @State private var selectedStartDate: Date?
    @State private var selectedEndDate: Date?
    @State private var displayedMonths: [Date] = []
    
    init(tour: Tour) {
        self.tour = tour
        let calendar = Calendar.current
        let currentDate = Date()
        _displayedMonths = State(initialValue: [
            currentDate,
            calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        ])
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Header
                header
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {
                        // Title
                        Text("Choose your booking")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 26)
                            .padding(.top, 16)
                        
                        // Calendars
                        ForEach(displayedMonths, id: \.self) { month in
                            CalendarMonthView(
                                month: month,
                                selectedStartDate: $selectedStartDate,
                                selectedEndDate: $selectedEndDate
                            )
                            .padding(.horizontal, 26)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            
            // Bottom Action Bar
            bottomActionBar
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(spacing: 0) {
            // Status Bar Background
            Rectangle()
                .fill(Color.white)
                .frame(height: 44)
            
            // Navigation Header
            HStack(spacing: 19) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 36, height: 36)
                }
                
                Text("Available date")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .frame(height: 57)
            .background(Color.white)
        }
        .shadow(color: Color.black.opacity(0.1), radius: 4.5, x: 0, y: 2)
    }
    
    // MARK: - Bottom Action Bar
    private var bottomActionBar: some View {
        HStack(spacing: 13) {
            // Back Button
            Button(action: { dismiss() }) {
                Text("Back")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#797979"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(Color(hex: "#F3F3F3"))
                    .cornerRadius(15)
            }
            
            // Next Button
            Button(action: {
                if let start = selectedStartDate, let end = selectedEndDate {
                    router.goTo(.detailBooking(tour, start, end))
                }
            }) {
                Text("Next")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(
                        (selectedStartDate != nil && selectedEndDate != nil)
                            ? Color(hex: "#0FA3E2")
                            : Color.gray.opacity(0.5)
                    )
                    .cornerRadius(15)
            }
            .disabled(selectedStartDate == nil || selectedEndDate == nil)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 11)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 11.5, x: 0, y: -2)
    }
}

// MARK: - Calendar Month View
struct CalendarMonthView: View {
    let month: Date
    @Binding var selectedStartDate: Date?
    @Binding var selectedEndDate: Date?
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 10) {
            // Month Title
            Text(monthYearString)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 5) {
                // Days of Week Header
                HStack(spacing: 0) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .font(.system(size: 13.84))
                            .foregroundColor(.black)
                            .frame(width: 46.143, height: 34.607)
                    }
                }
                
                // Calendar Days
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(46.143), spacing: 0), count: 7), spacing: 0) {
                    ForEach(daysInMonth, id: \.self) { date in
                        CalendarDayCell(
                            date: date,
                            isCurrentMonth: calendar.isDate(date, equalTo: month, toGranularity: .month),
                            isSelected: isDateSelected(date),
                            isInRange: isDateInRange(date),
                            isStartDate: isStartDate(date),
                            isEndDate: isEndDate(date),
                            onTap: { selectDate(date) }
                        )
                    }
                }
            }
        }
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: month)
    }
    
    private var daysInMonth: [Date] {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: month)),
              let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthStart).weekday else {
            return []
        }
        
        var days: [Date] = []
        
        // Add previous month days
        let previousMonthDays = firstWeekday - 1
        if previousMonthDays > 0, let previousMonthStart = calendar.date(byAdding: .day, value: -previousMonthDays, to: monthStart) {
            for dayOffset in 0..<previousMonthDays {
                if let date = calendar.date(byAdding: .day, value: dayOffset, to: previousMonthStart) {
                    days.append(date)
                }
            }
        }
        
        // Add current month days
        let range = calendar.range(of: .day, in: .month, for: month)!
        for day in range {
            if let date = calendar.date(bySetting: .day, value: day, of: monthStart) {
                days.append(date)
            }
        }
        
        // Add next month days to complete the grid
        let totalCells = days.count
        let remainingCells = 35 - totalCells // 5 weeks = 35 cells
        if remainingCells > 0, let nextMonthStart = calendar.date(byAdding: .month, value: 1, to: monthStart) {
            for dayOffset in 0..<remainingCells {
                if let date = calendar.date(byAdding: .day, value: dayOffset, to: nextMonthStart) {
                    days.append(date)
                }
            }
        }
        
        return days
    }
    
    private func isDateSelected(_ date: Date) -> Bool {
        if let start = selectedStartDate, calendar.isDate(date, inSameDayAs: start) {
            return true
        }
        if let end = selectedEndDate, calendar.isDate(date, inSameDayAs: end) {
            return true
        }
        return false
    }
    
    private func isDateInRange(_ date: Date) -> Bool {
        guard let start = selectedStartDate, let end = selectedEndDate else {
            return false
        }
        return date > start && date < end
    }
    
    private func isStartDate(_ date: Date) -> Bool {
        guard let start = selectedStartDate else { return false }
        return calendar.isDate(date, inSameDayAs: start)
    }
    
    private func isEndDate(_ date: Date) -> Bool {
        guard let end = selectedEndDate else { return false }
        return calendar.isDate(date, inSameDayAs: end)
    }
    
    private func selectDate(_ date: Date) {
        if selectedStartDate == nil {
            selectedStartDate = date
        } else if selectedEndDate == nil {
            if date >= selectedStartDate! {
                selectedEndDate = date
            } else {
                selectedStartDate = date
            }
        } else {
            selectedStartDate = date
            selectedEndDate = nil
        }
    }
}

// MARK: - Calendar Day Cell
struct CalendarDayCell: View {
    let date: Date
    let isCurrentMonth: Bool
    let isSelected: Bool
    let isInRange: Bool
    let isStartDate: Bool
    let isEndDate: Bool
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: isCurrentMonth ? onTap : {}) {
            ZStack {
                // Range background
                if isInRange || isSelected {
                    Rectangle()
                        .fill(Color(hex: "#99E1FF"))
                        .frame(width: 46.143, height: 46.143)
                        .clipShape(
                            RoundedCorners(
                                radius: isStartDate || isEndDate ? 23 : 0,
                                corners: isStartDate ? [.topLeft, .bottomLeft] : isEndDate ? [.topRight, .bottomRight] : []
                            )
                        )
                }
                
                // Day circle
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color(hex: "#0FA3E2"))
                            .frame(width: 46.143, height: 46.143)
                    }
                    
                    Text("\(calendar.component(.day, from: date))")
                        .font(.system(size: 13.84))
                        .foregroundColor(isSelected ? .white : .black)
                }
            }
        }
        .frame(width: 46.143, height: 46.143)
        .opacity(isCurrentMonth ? 1.0 : 0.3)
        .disabled(!isCurrentMonth)
    }
}

// MARK: - Rounded Corners Shape
struct RoundedCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AvailableDateView(tour: .mockTour)
    }
}
