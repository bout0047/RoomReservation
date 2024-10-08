namespace RoomReservationBackend.Models
{
    public class User
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }

        // Add Salt field
        public string Salt { get; set; }
    }
}
