namespace RoomReservationBackend.DTOs
{
    public class UserRegistrationDto
    {
        public string Name { get; set; } = string.Empty; // Provide a default value or mark as required
        public string Email { get; set; } = string.Empty; // Provide a default value or mark as required
        public string Password { get; set; } = string.Empty; // Provide a default value or mark as required
    }
}
