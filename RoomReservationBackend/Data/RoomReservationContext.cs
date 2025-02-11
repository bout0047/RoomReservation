﻿using Microsoft.EntityFrameworkCore;
using RoomReservationBackend.Models;

namespace RoomReservationBackend.Data
{
    public class RoomReservationContext : DbContext
    {
        public RoomReservationContext(DbContextOptions<RoomReservationContext> options)
            : base(options)
        {
        }

        public DbSet<Room> Rooms { get; set; }
        public DbSet<Reservation> Reservations { get; set; }
        public DbSet<User> Users { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Example of seeding data
            modelBuilder.Entity<Room>().HasData(
                new Room { RoomId = 1, Name = "Conference Room A", Capacity = 10, Location = "First Floor" },
                new Room { RoomId = 2, Name = "Conference Room B", Capacity = 20, Location = "Second Floor" }
            );
        }
    }
}
