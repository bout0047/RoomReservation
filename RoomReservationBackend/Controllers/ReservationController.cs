using Microsoft.AspNetCore.Mvc;
using RoomReservationBackend.Models;
using RoomReservationBackend.Services;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Linq; // Added for LINQ usage

namespace RoomReservationBackend.Controllers
{
    [ApiController]
    [Route("api/reservations")]
    public class ReservationController : ControllerBase
    {
        private readonly ReservationService _reservationService;

        public ReservationController(ReservationService reservationService)
        {
            _reservationService = reservationService;
        }

        // Get all reservations (optionally filtered by roomId and date)
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Reservation>>> GetAllReservations(int? roomId, DateTime? date)
        {
            var reservations = await _reservationService.GetAllReservationsAsync(roomId, date);
            return Ok(reservations);
        }

        // Get reservations by room and date (entire day)
        [HttpGet("byRoomAndDate")]
        public async Task<ActionResult<IEnumerable<Reservation>>> GetReservationsByRoomAndDate(int roomId, DateTime date)
        {
            DateTime startDate = date.Date;
            DateTime endDate = date.Date.AddDays(1).AddTicks(-1); // Entire day
            var reservations = await _reservationService.GetReservationsByRoomAndDateAsync(roomId, startDate, endDate);

            if (reservations == null || !reservations.Any())
            {
                return NotFound("No reservations found for this room and date.");
            }

            return Ok(reservations);
        }

        // Create a new reservation
        [HttpPost]
        public async Task<IActionResult> CreateReservation([FromBody] ReservationDto reservationDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            bool result = await _reservationService.CreateReservationAsync(reservationDto);
            if (!result)
            {
                return BadRequest("Failed to create reservation. Room or user may not exist or there is a conflict.");
            }

            return Ok("Reservation created successfully.");
        }

        // Get a reservation by ID
        [HttpGet("{id}")]
        public async Task<ActionResult<Reservation>> GetReservationById(int id)
        {
            var reservation = await _reservationService.GetReservationByIdAsync(id);
            if (reservation == null)
            {
                return NotFound("Reservation not found.");
            }

            return Ok(reservation);
        }

        // Approve a reservation
        [HttpPut("approve/{id}")]
        public async Task<IActionResult> ApproveReservation(int id)
        {
            bool result = await _reservationService.ApproveReservationAsync(id);
            if (!result)
            {
                return NotFound("Failed to approve the reservation. Reservation may not exist.");
            }

            return NoContent();
        }

        // Update an existing reservation
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateReservation(int id, [FromBody] ReservationDto reservationDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            bool result = await _reservationService.UpdateReservationAsync(id, reservationDto);
            if (!result)
            {
                return NotFound("Failed to update the reservation. Reservation may not exist.");
            }

            return NoContent();
        }

        // Delete a reservation by ID
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteReservation(int id)
        {
            bool result = await _reservationService.DeleteReservationAsync(id);
            if (!result)
            {
                return NotFound("Failed to delete the reservation. Reservation may not exist.");
            }

            return NoContent();
        }
    }
}
