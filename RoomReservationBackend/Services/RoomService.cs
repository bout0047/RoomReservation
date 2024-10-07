using RoomReservationBackend.Data;
using RoomReservationBackend.Utilities;

public async Task<bool> ApproveReservationAsync(int reservationId)
{
    var reservation = await _reservationRepository.GetReservationByIdAsync(reservationId);
    if (reservation == null || reservation.IsApproved)
    {
        return false; // Reservation not found or already approved
    }

    reservation.IsApproved = true;
    await _reservationRepository.UpdateReservationAsync(reservation);
    await _emailService.SendEmailAsync(reservation.User.Email, "Reservation Approved", $"Your reservation for Room {reservation.RoomId} has been approved.");
    return true;
}

public async Task<bool> RejectReservationAsync(int reservationId)
{
    var reservation = await _reservationRepository.GetReservationByIdAsync(reservationId);
    if (reservation == null || !reservation.IsApproved)
    {
        return false; // Reservation not found or already rejected
    }

    await _reservationRepository.DeleteReservationAsync(reservationId);
    await _emailService.SendEmailAsync(reservation.User.Email, "Reservation Rejected", $"Your reservation for Room {reservation.RoomId} has been rejected.");
    return true;
}
