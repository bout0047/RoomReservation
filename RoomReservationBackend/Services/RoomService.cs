using RoomReservationBackend.Data;
using RoomReservationBackend.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace RoomReservationBackend.Services
{
    public class RoomService
    {
        private readonly RoomRepository _roomRepository;

        public RoomService(RoomRepository roomRepository)
        {
            _roomRepository = roomRepository;
        }

        public async Task<IEnumerable<Room>> GetAllRoomsAsync()
        {
            return await _roomRepository.GetAllRoomsAsync();
        }

        public async Task<Room?> GetRoomByIdAsync(int id)
        {
            return await _roomRepository.GetRoomByIdAsync(id);
        }

        public async Task CreateRoomAsync(Room room)
        {
            await _roomRepository.CreateRoomAsync(room);
        }

        public async Task<bool> UpdateRoomAsync(Room room)
        {
            var existingRoom = await _roomRepository.GetRoomByIdAsync(room.RoomId);
            if (existingRoom == null)
            {
                return false;
            }

            await _roomRepository.UpdateRoomAsync(room);
            return true;
        }

        public async Task<bool> DeleteRoomAsync(int roomId)
        {
            var existingRoom = await _roomRepository.GetRoomByIdAsync(roomId);
            if (existingRoom == null)
            {
                return false;
            }

            await _roomRepository.DeleteRoomAsync(roomId);
            return true;
        }
    }
}
