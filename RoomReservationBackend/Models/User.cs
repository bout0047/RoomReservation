namespace RoomReservationBackend.Models
{
    public class User
    {
        public int Id { get; set; }  // Changed from 'UserId' to 'Id' to match your model
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string PasswordHash { get; set; } = string.Empty;
        public string Salt { get; set; } = string.Empty;

        // Navigation property - A user can make multiple reservations
        public ICollection<Reservation> Reservations { get; set; } = new List<Reservation>(); // Add this
    }
}
