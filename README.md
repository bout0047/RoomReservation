# Room Reservation Application

## Overview
The **Room Reservation Application** is a robust and user-friendly platform designed to streamline room booking processes. Built with modern technologies, it offers seamless integration between a .NET backend, a Flutter mobile app, and a React.js web frontend. The project supports various features such as authentication, real-time updates, and efficient database management.

---

## Features

- **User Authentication**: Secure login and registration using OAuth.
- **Real-Time Updates**: Leveraging WebSockets for instant updates.
- **Responsive Design**: A Flutter mobile app and React.js web app for an optimal user experience across devices.
- **Efficient Backend**: Powered by a .NET backend with structured services and repositories.
- **Database Management**: Integration with SQL Server for reliable data handling.
- **Scalable Architecture**: Built to support future enhancements and integrations.

---

## Tech Stack

### Frontend
- **React.js**: For a dynamic and responsive web interface.
- **Flutter**: For a cross-platform mobile application.

### Backend
- **.NET Core**: A powerful backend for handling business logic and APIs.
- **SQL Server**: For reliable and efficient data storage.

### Other Tools
- **OAuth**: Secure authentication and authorization.
- **WebSockets**: Real-time communication.
- **AWS**: Hosting and deployment.

---

## Installation

### Prerequisites

1. **.NET SDK 8.0 or higher**
2. **Node.js** (for React.js)
3. **Flutter SDK**
4. **SQL Server**

### Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/bout0047/RoomReservation.git
   cd RoomReservation
   ```

2. **Setup Backend**:
   - Navigate to the backend folder:
     ```bash
     cd RoomRes
     ```
   - Restore dependencies:
     ```bash
     dotnet restore
     ```
   - Update `appsettings.json` with your SQL Server connection string.
   - Run migrations:
     ```bash
     dotnet ef database update
     ```
   - Start the backend:
     ```bash
     dotnet run
     ```

3. **Setup Frontend**:
   - For React.js:
     ```bash
     cd frontend
     npm install
     npm start
     ```
   - For Flutter:
     ```bash
     cd mobile_app
     flutter pub get
     flutter run
     ```

---

## Usage

1. **Run the backend**:
   ```bash
   dotnet run
   ```

2. **Run the React.js app**:
   ```bash
   npm start
   ```

3. **Run the Flutter app**:
   ```bash
   flutter run
   ```

4. Access the application:
   - **Web App**: `http://localhost:3000`
   - **Mobile App**: Directly on your connected device or emulator.

---

## Folder Structure

- `RoomRes`: .NET backend for APIs and business logic.
- `frontend`: React.js project for the web interface.
- `mobile_app`: Flutter project for the mobile app.
- `database`: SQL scripts and migrations.

---

## Contributing

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m 'Add feature-name'
   ```
4. Push to the branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request.

