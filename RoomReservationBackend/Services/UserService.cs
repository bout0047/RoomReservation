using System.Security.Cryptography;
using System.Text;
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

        public async Task<bool> RegisterUserAsync(User user)
        {
            var existingUser = await _userRepository.GetUserByEmailAsync(user.Email);
            if (existingUser != null)
            {
                return false;
            }

            var salt = GenerateSalt();
            user.PasswordHash = HashPassword(user.PasswordHash, salt);
            user.Salt = salt;
            await _userRepository.CreateUserAsync(user);
            return true;
        }

        public async Task<User?> AuthenticateUserAsync(string email, string password)
        {
            var user = await _userRepository.GetUserByEmailAsync(email);
            if (user != null && VerifyPassword(password, user.PasswordHash, user.Salt))
            {
                return user;
            }
            return null;
        }

        private string GenerateSalt()
        {
            var saltBytes = new byte[16];
            using var rng = RandomNumberGenerator.Create();
            rng.GetBytes(saltBytes);
            return Convert.ToBase64String(saltBytes);
        }

        private string HashPassword(string password, string salt)
        {
            using var sha256 = SHA256.Create();
            var combined = Encoding.UTF8.GetBytes(password + salt);
            var hashedBytes = sha256.ComputeHash(combined);
            return Convert.ToBase64String(hashedBytes);
        }

        private bool VerifyPassword(string inputPassword, string storedHash, string storedSalt)
        {
            var hashedInput = HashPassword(inputPassword, storedSalt);
            return hashedInput == storedHash;
        }
    }
}
