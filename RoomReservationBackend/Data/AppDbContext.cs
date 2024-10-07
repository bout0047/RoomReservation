using Microsoft.EntityFrameworkCore;
using RoomReservationBackend.Models;

namespace RoomReservationBackend.Data
{
    public class RoomReservationContext : DbContext
    {
        public RoomReservationContext(DbContextOptions<RoomReservationContext> options) : base(options) { }

        public DbSet<Room> Rooms { get; set; }
        public DbSet<Reservation> Reservations { get; set; }
        public DbSet<User> Users { get; set; }
    }
}
