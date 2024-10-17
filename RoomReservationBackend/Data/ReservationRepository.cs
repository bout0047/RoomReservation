using RoomReservationBackend.Data;
using RoomReservationBackend.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace RoomReservationBackend.Repositories
{
    public class ReservationRepository
    {
        private readonly RoomReservationContext _context;

        public ReservationRepository(RoomReservationContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Reservation>> GetAllReservationsAsync(int? roomId = null, DateTime? date = null)
        {
            var query = _context.Reservations.AsQueryable();

            if (roomId.HasValue)
            {
                query = query.Where(r => r.RoomId == roomId.Value);
            }

            if (date.HasValue)
            {
                query = query.Where(r => r.StartTime.Date == date.Value.Date);
            }

            return await query.ToListAsync();
        }

        public async Task<IEnumerable<Reservation>> GetReservationsByRoomAndDateAsync(int roomId, DateTime startDate, DateTime endDate)
        {
            return await _context.Reservations
                .Where(r => r.RoomId == roomId && r.StartTime >= startDate && r.EndTime <= endDate)
                .ToListAsync();
        }

        public async Task<Reservation?> GetReservationByIdAsync(int id)
        {
            return await _context.Reservations.FindAsync(id);
        }

        public async Task CreateReservationAsync(Reservation reservation)
        {
            await _context.Reservations.AddAsync(reservation);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateReservationAsync(Reservation reservation)
        {
            _context.Reservations.Update(reservation);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteReservationAsync(int id)
        {
            var reservation = await GetReservationByIdAsync(id);
            if (reservation == null)
                return false;

            _context.Reservations.Remove(reservation);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
