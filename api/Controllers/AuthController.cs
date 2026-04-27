using DentalCore.API.Data;
using DentalCore.API.DTOs.Auth;
using DentalCore.API.Services;
using DentalCore.API.Wrappers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DentalCore.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IAuthService _authService;

        public AuthController(AppDbContext context, IAuthService authService)
        {
            _context = context;
            _authService = authService;
        }

        [HttpPost("login")]
        [ProducesResponseType(typeof(ApiResponse<AuthResponseDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status401Unauthorized)]
        public async Task<IActionResult> Login([FromBody] LoginRequestDto dto)
        {
            var usuario = await _context.Usuarios
                .FirstOrDefaultAsync(u => u.Email == dto.Email);

            if (usuario == null || !_authService.VerifyPassword(dto.Password, usuario.SenhaHash))
            {
                return Unauthorized(ApiResponse<object>.Erro("E-mail ou senha inválidos."));
            }

            var response = _authService.GenerateJwtToken(usuario);

            return Ok(ApiResponse<AuthResponseDto>.Ok(response, "Login realizado com sucesso."));
        }
    }
}
