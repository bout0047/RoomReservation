using System;
using System.ComponentModel.DataAnnotations;

namespace RoomReservationBackend.Models
{
    public class ReservationDto
    {
        [Required]
        public int RoomId { get; set; }

        [Required]
        public int UserId { get; set; }

        [Required]
        public DateTime StartTime { get; set; }

        [Required]
        public DateTime EndTime { get; set; }
    }
}
