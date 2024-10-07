namespace RoomReservationBackend.Models
{
    public class User
    {
        public int UserId { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Role { get; set; } // Admin, Manager, Employee
        public string PasswordHash { get; set; } // Password hashed for security
    }
}
