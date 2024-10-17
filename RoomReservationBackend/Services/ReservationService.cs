using RoomReservationBackend.Data;
using RoomReservationBackend.Models;
using RoomReservationBackend.Repositories;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace RoomReservationBackend.Services
{
    public class ReservationService
    {
        private readonly ReservationRepository _reservationRepository;
        private readonly RoomRepository _roomRepository;
        private readonly UserRepository _userRepository;

        public ReservationService(ReservationRepository reservationRepository, RoomRepository roomRepository, UserRepository userRepository)
        {
            _reservationRepository = reservationRepository;
            _roomRepository = roomRepository;
            _userRepository = userRepository;
        }

        public async Task<IEnumerable<Reservation>> GetAllReservationsAsync(int? roomId = null, DateTime? date = null)
        {
            return await _reservationRepository.GetAllReservationsAsync(roomId, date);
        }

        public async Task<IEnumerable<Reservation>> GetReservationsByRoomAndDateAsync(int roomId, DateTime startDate, DateTime endDate)
        {
            var room = await _roomRepository.GetRoomByIdAsync(roomId);
            if (room == null)
                throw new ArgumentException($"Room with ID {roomId} does not exist");

            return await _reservationRepository.GetReservationsByRoomAndDateAsync(roomId, startDate, endDate);
        }

        public async Task<bool> CreateReservationAsync(ReservationDto reservationDto)
        {
            var room = await _roomRepository.GetRoomByIdAsync(reservationDto.RoomId);
            if (room == null)
                return false;

            var user = await _userRepository.GetUserByIdAsync(reservationDto.UserId);
            if (user == null)
                return false;

            var conflictingReservations = await _reservationRepository.GetReservationsByRoomAndDateAsync(
                reservationDto.RoomId, reservationDto.StartTime, reservationDto.EndTime);

            if (conflictingReservations != null && conflictingReservations.Any())
            {
                return false;
            }

            var reservation = new Reservation
            {
                RoomId = reservationDto.RoomId,
                UserId = reservationDto.UserId,
                StartTime = reservationDto.StartTime,
                EndTime = reservationDto.EndTime,
                IsApproved = false
            };

            await _reservationRepository.CreateReservationAsync(reservation);
            return true;
        }

        public async Task<Reservation?> GetReservationByIdAsync(int id)
        {
            return await _reservationRepository.GetReservationByIdAsync(id);
        }

        public async Task<bool> ApproveReservationAsync(int id)
        {
            var reservation = await _reservationRepository.GetReservationByIdAsync(id);
            if (reservation == null)
                return false;

            reservation.IsApproved = true;
            await _reservationRepository.UpdateReservationAsync(reservation);
            return true;
        }

        public async Task<bool> UpdateReservationAsync(int id, ReservationDto reservationDto)
        {
            var reservation = await _reservationRepository.GetReservationByIdAsync(id);
            if (reservation == null)
                return false;

            reservation.StartTime = reservationDto.StartTime;
            reservation.EndTime = reservationDto.EndTime;
            reservation.RoomId = reservationDto.RoomId;
            reservation.UserId = reservationDto.UserId;

            await _reservationRepository.UpdateReservationAsync(reservation);
            return true;
        }

        public async Task<bool> DeleteReservationAsync(int id)
        {
            return await _reservationRepository.DeleteReservationAsync(id);
        }
    }
}
