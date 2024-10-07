using Microsoft.EntityFrameworkCore;

namespace RoomReservationBackend.Data // Make sure this matches your project's namespace
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Room> Rooms { get; set; }
        public DbSet<Reservation> Reservations { get; set; }

        // You can override OnModelCreating if needed to customize the model
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            // Customize your model here if needed
        }
    }
}
