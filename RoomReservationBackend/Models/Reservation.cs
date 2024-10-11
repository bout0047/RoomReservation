﻿using System;

namespace RoomReservationBackend.Models
{
    public class Reservation
    {
        public int ReservationId { get; set; }
        public int RoomId { get; set; }
        public int UserId { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public bool IsApproved { get; set; }

        public Room? Room { get; set; } // Nullable navigation property
        public User? User { get; set; } // Nullable navigation property
    }
}
