using DentalCore.API.Enums;
using System.ComponentModel.DataAnnotations;

namespace DentalCore.API.Models
{
    public class Usuario : BaseEntity
    {
        [Required]
        [MaxLength(100)]
        public string Nome { get; set; } = string.Empty;

        [Required]
        [EmailAddress]
        [MaxLength(100)]
        public string Email { get; set; } = string.Empty;

        [Required]
        public string SenhaHash { get; set; } = string.Empty;

        [Required]
        public Role Role { get; set; } = Role.Recepcionista;

        public DateTime DataCadastro { get; set; } = DateTime.UtcNow;
    }
}
