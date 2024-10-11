using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RoomReservationBackend.Services;
using System;
using System.Threading.Tasks;

namespace RoomReservationBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = "Manager, Admin, User")]
    public class ReservationsController : ControllerBase
    {
        private readonly ReservationService _reservationService;

        public ReservationsController(ReservationService reservationService)
        {
            _reservationService = reservationService;
        }

        [HttpPost("{id}/approve")]
        public async Task<IActionResult> ApproveReservation(int id)
        {
            var result = await _reservationService.ApproveReservationAsync(id);
            if (!result)
            {
                return NotFound("Reservation not found or already approved.");
            }
            return NoContent(); // 204 No Content on successful approval
        }

        [HttpPost("{id}/reject")]
        public async Task<IActionResult> RejectReservation(int id)
        {
            var result = await _reservationService.RejectReservationAsync(id);
            if (!result)
            {
                return NotFound("Reservation not found or already rejected.");
            }
            return NoContent(); // 204 No Content on successful rejection
        }

        [HttpGet("byDate")]
        public async Task<IActionResult> GetReservationsByDate([FromQuery] DateTime date)
        {
            var reservations = await _reservationService.GetReservationsByDateAsync(date);
            if (reservations == null)
            {
                return NotFound("No reservations found for the given date.");
            }
            return Ok(reservations);
        }
    }
}
