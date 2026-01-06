//
//  DetailBookingView.swift
//  Traveling
//
//  Created by Daniel Retamal on 04-01-26.
//

import SwiftUI
import TravelinDesignSystem

struct DetailBookingView: View {
    let tour: Tour
    let startDate: Date
    let endDate: Date
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.PathRouter<BookingRoutes>.self) private var router
    @State private var guestName: String = ""
    @State private var guestNumber: String = "2"
    @State private var countryCode: String = "+855"
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var idNumber: String = ""
    
    var totalPrice: Double {
        return tour.price * (Double(guestNumber) ?? 1)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Header
                header
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        // Title and Subtitle
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Detail Booking")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("Get the best out of derleng by creating an account")
                                .font(.system(size: 12))
                                .foregroundColor(.black.opacity(0.8))
                        }
                        .padding(.horizontal, 26)
                        .padding(.top, 10)
                        
                        // Form
                        VStack(spacing: 15) {
                            // Guest Name
                            DSTextField(
                                placeHolder: "Enter guest name",
                                type: .givenName,
                                label: "Guest name",
                                style: .outlined,
                                text: $guestName
                            )
                            
                            // Guest Number
                            DSTextField(
                                placeHolder: "2",
                                type: .phoneNumber,
                                label: "Guest number",
                                style: .outlined,
                                text: $guestNumber
                            )
                            
                            // Phone
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Phone")
                                    .font(.system(size: 10))
                                    .foregroundColor(.black.opacity(0.8))
                                
                                HStack(spacing: 12) {
                                    // Country Code
                                    DSDropDown(
                                        items: ["+855", "+1", "+84"],
                                        selectedItem: $countryCode
                                    )
                                    .frame(width: 85)
                                    
                                    // Phone Number
                                    DSTextField(
                                        placeHolder: "123 456 789",
                                        type: .phoneNumber,
                                        style: .outlined,
                                        text: $phoneNumber
                                    )
                                }
                                .zIndex(1)
                            }
                            
                            // Email
                            DSTextField(
                                placeHolder: "Enter your email",
                                type: .email,
                                label: "Email",
                                style: .outlined,
                                text: $email
                            )
                            
                            // ID Number
                            DSTextField(
                                placeHolder: "Enter ID number",
                                type: .passwordNumbersId,
                                label: "ID Number",
                                style: .outlined,
                                text: $idNumber
                            )
                        }
                        .padding(.horizontal, 26)
                        .padding(.top, 13)
                        .padding(.bottom, 100)
                    }
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
        ZStack {
            Color.white
            
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 25, height: 46)
                }
                .padding(.leading, 24)
                
                Spacer()
            }
        }
        .frame(height: 99)
    }
    
    // MARK: - Bottom Action Bar
    private var bottomActionBar: some View {
        HStack(spacing: 0) {
            // Price
            HStack {
                Text("$\(Int(totalPrice))")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "#0A7BAB"))
                + Text("/\(guestNumber)Person")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#0A7BAB"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .padding(.horizontal, 20)
            
            // Next Button
            DSButton(
                title: "Next",
                variant: .primary
            ) {
                router.goTo(.bookingSuccess)
            }
            .padding(.leading, 5)
            .padding(.trailing, 5)
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 11)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 11.5, x: 0, y: -2)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        DetailBookingView(
            tour: .mockTour,
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 2)
        )
    }
}
