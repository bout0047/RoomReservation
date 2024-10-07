using System.Collections.Generic;
using System.Threading.Tasks;
using RoomReservationBackend.Data;
using RoomReservationBackend.Models;
using RoomReservationBackend.Utilities;

namespace RoomReservationBackend.Services
{
    public class ReservationService
    {
        private readonly ReservationRepository _reservationRepository;
        private readonly RoomRepository _roomRepository;
        private readonly UserRepository _userRepository;
        private readonly EmailService _emailService;

        public ReservationService(
            ReservationRepository reservationRepository,
            RoomRepository roomRepository,
            UserRepository userRepository,
            EmailService emailService)
        {
            _reservationRepository = reservationRepository;
            _roomRepository = roomRepository;
            _userRepository = userRepository;
            _emailService = emailService;
        }

        // Create a new reservation
        public async Task<bool> CreateReservationAsync(ReservationDto reservationDto)
        {
            // Check if the room is available for the specified time
            bool isAvailable = await IsRoomAvailableAsync(reservationDto.RoomId, reservationDto.StartTime, reservationDto.EndTime);
            if (!isAvailable)
            {
                return false; // Room is not available
            }

            var reservation = new Reservation
            {
                RoomId = reservationDto.RoomId,
                UserId = reservationDto.UserId,
                StartTime = reservationDto.StartTime,
                EndTime = reservationDto.EndTime,
                IsApproved = false // Default to false, waiting for approval
            };

            await _reservationRepository.CreateReservationAsync(reservation);

            // Notify the manager for approval
            var room = await _roomRepository.GetRoomByIdAsync(reservationDto.RoomId);
            var user = await _userRepository.GetUserByIdAsync(reservationDto.UserId);
            await _emailService.SendEmailAsync("manager@example.com", "New Reservation Request",
                $"User {user.Name} has requested Room '{room.Name}' from {reservationDto.StartTime} to {reservationDto.EndTime}.");

            return true;
        }

        // Approve a reservation
        public async Task<bool> ApproveReservationAsync(int reservationId)
        {
            var reservation = await _reservationRepository.GetReservationByIdAsync(reservationId);
            if (reservation == null || reservation.IsApproved)
            {
                return false; // Reservation not found or already approved
            }

            reservation.IsApproved = true;
            await _reservationRepository.UpdateReservationAsync(reservation);

            // Notify the user about approval
            var user = await _userRepository.GetUserByIdAsync(reservation.UserId);
            await _emailService.SendEmailAsync(user.Email, "Reservation Approved",
                $"Your reservation for Room {reservation.RoomId} has been approved.");

            return true;
        }

        // Reject a reservation
        public async Task<bool> RejectReservationAsync(int reservationId)
        {
            var reservation = await _reservationRepository.GetReservationByIdAsync(reservationId);
            if (reservation == null || reservation.IsApproved)
            {
                return false; // Reservation not found or already rejected
            }

            await _reservationRepository.DeleteReservationAsync(reservationId);

            // Notify the user about rejection
            var user = await _userRepository.GetUserByIdAsync(reservation.UserId);
            await _emailService.SendEmailAsync(user.Email, "Reservation Rejected",
                $"Your reservation for Room {reservation.RoomId} has been rejected.");

            return true;
        }

        // Get all reservations
        public async Task<IEnumerable<Reservation>> GetAllReservationsAsync()
        {
            return await _reservationRepository.GetAllReservationsAsync();
        }

        // Get reservation by ID
        public async Task<Reservation> GetReservationByIdAsync(int reservationId)
        {
            return await _reservationRepository.GetReservationByIdAsync(reservationId);
        }

        // Cancel a reservation
        public async Task<bool> CancelReservationAsync(int reservationId)
        {
            var reservation = await _reservationRepository.GetReservationByIdAsync(reservationId);
            if (reservation == null)
            {
                return false; // Reservation not found
            }

            await _reservationRepository.DeleteReservationAsync(reservationId);

            // Notify the user about the cancellation
            var user = await _userRepository.GetUserByIdAsync(reservation.UserId);
            await _emailService.SendEmailAsync(user.Email, "Reservation Cancelled",
                $"Your reservation for Room {reservation.RoomId} has been cancelled.");

            return true;
        }

        // Check room availability for a specified period
        public async Task<bool> IsRoomAvailableAsync(int roomId, System.DateTime startTime, System.DateTime endTime)
        {
            var reservations = await _reservationRepository.GetReservationsByRoomIdAsync(roomId);

            foreach (var reservation in reservations)
            {
                if (reservation.IsApproved && (
                    (startTime >= reservation.StartTime && startTime < reservation.EndTime) ||
                    (endTime > reservation.StartTime && endTime <= reservation.EndTime) ||
                    (startTime <= reservation.StartTime && endTime >= reservation.EndTime)))
                {
                    return false; // Room is not available
                }
            }

            return true; // Room is available
        }

        // Update a reservation
        public async Task<bool> UpdateReservationAsync(int reservationId, ReservationDto reservationDto)
        {
            var reservation = await _reservationRepository.GetReservationByIdAsync(reservationId);
            if (reservation == null)
            {
                return false; // Reservation not found
            }

            // Check if the updated timeslot is available
            bool isAvailable = await IsRoomAvailableAsync(reservationDto.RoomId, reservationDto.StartTime, reservationDto.EndTime);
            if (!isAvailable)
            {
                return false; // Room is not available for the new timeslot
            }

            reservation.StartTime = reservationDto.StartTime;
            reservation.EndTime = reservationDto.EndTime;
            reservation.RoomId = reservationDto.RoomId;

            await _reservationRepository.UpdateReservationAsync(reservation);

            // Notify user about reservation change
            var user = await _userRepository.GetUserByIdAsync(reservation.UserId);
            await _emailService.SendEmailAsync(user.Email, "Reservation Updated",
                $"Your reservation for Room {reservation.RoomId} has been updated to {reservationDto.StartTime} - {reservationDto.EndTime}.");

            return true;
        }
    }
}
