﻿namespace RoomReservationBackend.Models
{
    public class User
    {
        public int Id { get; set; }

        public string Name { get; set; } = string.Empty; // Provide a default value or mark as required
        public string Email { get; set; } = string.Empty; // Provide a default value or mark as required
        public string PasswordHash { get; set; } = string.Empty; // Provide a default value or mark as required
    }
}
