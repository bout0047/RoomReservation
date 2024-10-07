namespace RoomReservationBackend.Models
{
    public class RoomDto
    {
        public int RoomId { get; set; }
        public string Name { get; set; } = string.Empty;
        public int Capacity { get; set; }
        public string Location { get; set; } = string.Empty;
        public string Amenities { get; set; } = string.Empty;
    }
}
