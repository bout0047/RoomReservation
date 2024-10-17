namespace RoomReservationBackend.Models
{
    public class Room
    {
        public int RoomId { get; set; }
        public string Name { get; set; } = string.Empty; // Changed to match your model

        public int Capacity { get; set; }
        public string Location { get; set; } = string.Empty;
        public string Amenities { get; set; } = string.Empty;

        // Navigation property - A room can have multiple reservations
        public ICollection<Reservation> Reservations { get; set; } = new List<Reservation>(); // Add this
    }
}
