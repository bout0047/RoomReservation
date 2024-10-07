using RoomReservationBackend.DTOs;
using RoomReservationBackend.Models;
using RoomReservationBackend.Repositories;
using System.Threading.Tasks;

namespace RoomReservationBackend.Services
{
    public class UserService
    {
        private readonly UserRepository _userRepository;

        public UserService(UserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public async Task<string> RegisterUserAsync(UserRegistrationDto registrationDto)
        {
            // Check if the user already exists
            var existingUser = await _userRepository.GetUserByEmailAsync(registrationDto.Email);
            if (existingUser != null)
            {
                throw new Exception("User already exists.");
            }

            // Create a new User entity
            var user = new User
            {
                Name = registrationDto.Name,
                Email = registrationDto.Email,
                PasswordHash = HashPassword(registrationDto.Password) // Implement this method to hash the password
            };

            await _userRepository.AddUserAsync(user); // Add user to the repository
            return "User registered successfully.";
        }

        private string HashPassword(string password)
        {
            // Implement your password hashing logic here
            return password; // Replace with actual hashing
        }
    }
}
