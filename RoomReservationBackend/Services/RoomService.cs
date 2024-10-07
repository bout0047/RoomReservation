using System.Collections.Generic;
using System.Threading.Tasks;
using RoomReservationBackend.Data;
using RoomReservationBackend.Models;

namespace RoomReservationBackend.Services
{
    public class RoomService
    {
        private readonly RoomRepository _roomRepository;

        // Constructor to inject the repository
        public RoomService(RoomRepository roomRepository)
        {
            _roomRepository = roomRepository;
        }

        // Method to get all rooms
        public async Task<IEnumerable<Room>> GetAllRoomsAsync()
        {
            return await _roomRepository.GetAllRoomsAsync();
        }

        // Method to get a room by ID
        public async Task<Room> GetRoomByIdAsync(int id)
        {
            return await _roomRepository.GetRoomByIdAsync(id);
        }

        // Method to create a room
        public async Task CreateRoomAsync(RoomDto roomDto)
        {
            var room = new Room
            {
                Name = roomDto.Name,
                Capacity = roomDto.Capacity,
                Location = roomDto.Location,
                Amenities = roomDto.Amenities
            };

            await _roomRepository.CreateRoomAsync(room);
        }

        // Method to update a room
        public async Task UpdateRoomAsync(int id, RoomDto roomDto)
        {
            var room = await _roomRepository.GetRoomByIdAsync(id);
            if (room != null)
            {
                room.Name = roomDto.Name;
                room.Capacity = roomDto.Capacity;
                room.Location = roomDto.Location;
                room.Amenities = roomDto.Amenities;
                await _roomRepository.UpdateRoomAsync(room);
            }
        }

        // Method to delete a room
        public async Task DeleteRoomAsync(int id)
        {
            await _roomRepository.DeleteRoomAsync(id);
        }
    }
}
