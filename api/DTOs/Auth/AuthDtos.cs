using DentalCore.API.Enums;

namespace DentalCore.API.DTOs.Auth
{
    public record LoginRequestDto(string Email, string Password);

    public record AuthResponseDto(
        string Token, 
        string Nome, 
        string Email, 
        Role Role, 
        DateTime Expiration
    );
}
