using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RoomReservationBackend.Services;
using System.Threading.Tasks;

namespace RoomReservationBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = "Manager, Admin")]
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
            return NoContent();
        }

        [HttpPost("{id}/reject")]
        public async Task<IActionResult> RejectReservation(int id)
        {
            var result = await _reservationService.RejectReservationAsync(id);
            if (!result)
            {
                return NotFound("Reservation not found or already rejected.");
            }
            return NoContent();
        }
    }
}
