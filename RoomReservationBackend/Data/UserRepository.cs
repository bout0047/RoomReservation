using Microsoft.EntityFrameworkCore;
using RoomReservationBackend.Data;
using RoomReservationBackend.Models;

namespace RoomReservationBackend.Repositories
{
    public class UserRepository
    {
        private readonly RoomReservationContext _context;

        public UserRepository(RoomReservationContext context)
        {
            _context = context;
        }

        public async Task<User?> GetUserByEmailAsync(string email)
        {
            return await _context.Users.SingleOrDefaultAsync(u => u.Email == email);
        }

        public async Task<User?> GetUserByIdAsync(int userId)
        {
            return await _context.Users.FindAsync(userId);
        }

        public async Task CreateUserAsync(User user)
        {
            await _context.Users.AddAsync(user);
            await _context.SaveChangesAsync();
        }
    }
}
