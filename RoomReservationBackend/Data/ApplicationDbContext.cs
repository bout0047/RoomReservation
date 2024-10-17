using Microsoft.EntityFrameworkCore;
using RoomReservationBackend.Models;

namespace RoomReservationBackend.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        // DbSets for your models (these represent your database tables)
        public DbSet<Room> Rooms { get; set; }
        public DbSet<Reservation> Reservations { get; set; }
        public DbSet<User> Users { get; set; }

        // Optionally, override OnModelCreating if you need to configure your models further
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Example: Seed data if needed
            modelBuilder.Entity<Room>().HasData(
                new Room { RoomId = 1, Name = "Conference Room A", Capacity = 10, Location = "First Floor" },
                new Room { RoomId = 2, Name = "Conference Room B", Capacity = 20, Location = "Second Floor" }
            );
        }
    }
}
