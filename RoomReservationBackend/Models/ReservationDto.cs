using System;

namespace RoomReservationBackend.Models
{
    public class ReservationDto
    {
        public int RoomId { get; set; }
        public int UserId { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
    }
}
