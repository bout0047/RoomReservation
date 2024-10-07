using Microsoft.AspNetCore.Mvc;
using RoomReservationBackend.Models;
using RoomReservationBackend.Services;
using RoomReservationBackend.Utilities;
using System.Threading.Tasks;

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
        public async Task<IActionResult> Register([FromBody] UserDto userDto)
        {
            var user = await _userService.RegisterUserAsync(userDto);
            if (user == null)
            {
                return BadRequest("User already exists");
            }
            return Ok(user);
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] UserDto userDto)
        {
            var user = await _userService.AuthenticateUserAsync(userDto.Email, userDto.Password);
            if (user == null)
            {
                return Unauthorized();
            }

            var token = _jwtAuthenticationManager.Authenticate(user.Email, user.Role);
            return Ok(new { Token = token });
        }
    }
}
