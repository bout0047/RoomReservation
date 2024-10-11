using RoomReservationBackend.Data;
using RoomReservationBackend.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace RoomReservationBackend.Services
{
    public class ReservationService
    {
        private readonly ReservationRepository _reservationRepository;

        public ReservationService(ReservationRepository reservationRepository)
        {
            _reservationRepository = reservationRepository;
        }

        public async Task<bool> ApproveReservationAsync(int id)
        {
            var reservation = await _reservationRepository.GetReservationByIdAsync(id);
            if (reservation == null || reservation.IsApproved)
            {
                return false;
            }

            reservation.IsApproved = true;
            await _reservationRepository.UpdateReservationAsync(reservation);
            return true;
        }

        public async Task<bool> RejectReservationAsync(int id)
        {
            var reservation = await _reservationRepository.GetReservationByIdAsync(id);
            if (reservation == null || !reservation.IsApproved)
            {
                return false;
            }

            reservation.IsApproved = false;
            await _reservationRepository.UpdateReservationAsync(reservation);
            return true;
        }

        // NEW: GetReservationsByDateAsync method to get reservations for a specific date
        public async Task<IEnumerable<Reservation>> GetReservationsByDateAsync(DateTime date)
        {
            return await _reservationRepository.GetReservationsByDateAsync(date);
        }
    }
}
