# Calendar App

Welcome to the **Calendar App**! This app is part of my assignment for the **62417 Mobile Application Development with Swift** course. It demonstrates key concepts learned during the course, including **SwiftUI, SwiftData, Firebase Authentication, and Firestore**. The app helps users efficiently manage events with a user-friendly interface, stores events locally using **SwiftData**, and provides additional features like weather information from **DMI’s Open Data API**.

## Features

- **User Authentication**: Create an account or log in with Firebase Authentication.
- **Group Management**:
  - **Create a Group**: Users can create a new group, generating a unique **Group ID**.
  - **Join a Group**: Users can join an existing group by entering its **Group ID**.
- **Event Management**: 
  - Create, edit, and view events with ease.
  - **Assign Members**: Choose which group members are assigned to an event.
- **Temperature View**: Provides weather data (temperature) for the event’s start date using **DMI’s Open Data API**.
- **Custom Alert Times**: Set custom alert times for your events.
- **Local Storage**: Events are stored locally using **SwiftData**, making the app fast and efficient.
- **Remote Storage**: User data, group information, and events are stored in **Firestore**, ensuring synchronization across devices.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/calendar-app.git
   ```
2.	Open the project in Xcode.
3.	Build and run the app on the simulator or a connected device.

## Prerequisites

Ensure you have the following:

- Xcode (latest stable version)
- SwiftUI and SwiftData (iOS 16.0+)
- Firebase setup (Firebase Authentication and Firestore configuration)

## Usage

1. **User Authentication**: Sign up, log in, or log out with Firebase Authentication.
2. **Group Management**:
   - Create a group and get a **Group ID**.
   - Join an existing group by entering its **Group ID**.
3. **Event Management**:
   - Create and edit events.
   - Assign specific group members to events.
4. **Temperature View**: Displays the weather forecast for the event’s start date.

## Technologies Used

- **SwiftUI**: For building the user interface.
- **SwiftData**: For local event data storage and management.
- **Firebase Authentication**: For user login/signup.
- **Firestore**: For remote data storage and synchronization.
- **DMI’s Open Data API**: For fetching temperature data for the event’s start date.
- **UserNotifications**: To add custom notifications for events.

## API Integration

The **TemperatureView** integrates with **DMI’s Open Data API** to fetch weather data based on the event’s start date. The API retrieves temperature information, helping users make informed decisions based on the expected weather.

- If temperature data is unavailable, the app will show an alert to inform the user of the issue.

## Firebase Authentication & Firestore

- **Firebase Authentication** is used to manage user login, sign-up, and logout processes.
- **Firestore** is used to store user data, groups, and events remotely, ensuring synchronization across devices and easy data management.

**Note**: You will need to set up Firebase in the Firebase Console and configure your iOS app to use Firebase Authentication and Firestore.

## About this Project

This **Calendar App** is an assignment for my **62417 Mobile Application Development with Swift** course, where I am learning to build iOS apps using Swift and SwiftUI. The project demonstrates my ability to:

- Build user interfaces with **SwiftUI**.
- Use **SwiftData** for local data storage and management.
- Integrate third-party services like **Firebase Authentication and Firestore**.
- Work with external APIs like **DMI’s Open Data API** for fetching real-time data.

This project is part of my coursework and will contribute to my final exam. The app is designed to be **functional, scalable, and follow best practices** taught during the course.
## About this Project

This **Calendar App** is an assignment for my **62417 Mobile Application Development with Swift** course, where I am learning to build iOS apps using **Swift** and **SwiftUI**. The project demonstrates my ability to:

- Build user interfaces with **SwiftUI**.
- Use **SwiftData** for local data storage and management.
- Integrate third-party services like **Firebase Authentication** and **Firestore**.
- Work with external APIs like **DMI’s Open Data API** for fetching real-time data.

This project is a part of my coursework, and it will contribute to my final exam. The app is designed to be functional, scalable, and follow the best practices taught during the course.
