using System.Threading.Tasks;
using RoomReservationBackend.Data;
using RoomReservationBackend.Models;
using BCrypt.Net;

namespace RoomReservationBackend.Services
{
    public class UserService
    {
        private readonly UserRepository _userRepository;

        public UserService(UserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public async Task<User> RegisterUserAsync(UserDto userDto)
        {
            if (await _userRepository.GetUserByEmailAsync(userDto.Email) != null)
            {
                return null; // User already exists
            }

            var user = new User
            {
                Name = userDto.Name,
                Email = userDto.Email,
                Role = userDto.Role,
                PasswordHash = BCrypt.HashPassword(userDto.Password)
            };
            await _userRepository.CreateUserAsync(user);
            return user;
        }

        public async Task<User> AuthenticateUserAsync(string email, string password)
        {
            var user = await _userRepository.GetUserByEmailAsync(email);
            if (user == null || !BCrypt.Verify(password, user.PasswordHash))
            {
                return null; // Invalid credentials
            }
            return user;
        }
    }
}
