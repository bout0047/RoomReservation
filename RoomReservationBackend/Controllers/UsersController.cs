using Microsoft.AspNetCore.Mvc;
using RoomReservationBackend.DTOs;
using RoomReservationBackend.Models;
using RoomReservationBackend.Services;
using RoomReservationBackend.Utilities;

namespace RoomReservationBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly UserService _userService;
        private readonly JwtAuthenticationManager _jwtAuthenticationManager;

        public UsersController(UserService userService, JwtAuthenticationManager jwtAuthenticationManager)
        {
            _userService = userService;
            _jwtAuthenticationManager = jwtAuthenticationManager;
        }

        [HttpPost("register")]
        public async Task<IActionResult> RegisterUser(UserRegistrationDto userDto)
        {
            var user = new User
            {
                Name = userDto.Name,
                Email = userDto.Email,
                PasswordHash = userDto.Password
            };

            var result = await _userService.RegisterUserAsync(user);

            if (!result)
            {
                return BadRequest("User already exists or registration failed.");
            }

            var token = _jwtAuthenticationManager.Authenticate(user.Email, "User");
            if (token == null)
            {
                return StatusCode(500, "Error generating token");
            }

            return Ok(new { token, message = "User registered successfully", redirectUrl = "/" });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] UserDto userDto)
        {
            var user = await _userService.AuthenticateUserAsync(userDto.Email, userDto.Password);
            if (user == null)
            {
                return Unauthorized("Invalid credentials.");
            }

            var token = _jwtAuthenticationManager.Authenticate(user.Email, "User");
            return Ok(new { token, redirectUrl = "/" });
        }
    }
}
