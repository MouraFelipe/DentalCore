using DentalCore.API.Data;
using DentalCore.API.DTOs.Paciente;
using DentalCore.API.Models;
using DentalCore.API.Wrappers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DentalCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
public class PacienteController : ControllerBase
{
    private readonly AppDbContext _context;

    public PacienteController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> ListarTodos()
    {
        var pacientes = await _context.Pacientes
            .Select(p => new PacienteResponseDto
            {
                Id = p.Id,
                Nome = p.Nome,
                Cpf = p.Cpf,
                Telefone = p.Telefone,
                DataCadastro = p.DataCadastro,
                TotalConsultas = p.Consultas.Count()
            })
            .ToListAsync();

        return Ok(ApiResponse<List<PacienteResponseDto>>.Ok(pacientes));
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> ObterPorId(int id)
    {
        var paciente = await _context.Pacientes
            .Include(p => p.Consultas)
            .FirstOrDefaultAsync(p => p.Id == id);

        if (paciente == null)
            return NotFound(ApiResponse<PacienteResponseDto>.Erro($"Paciente com Id {id} não encontrado."));

        var response = new PacienteResponseDto
        {
            Id = paciente.Id,
            Nome = paciente.Nome,
            Cpf = paciente.Cpf,
            Telefone = paciente.Telefone,
            DataCadastro = paciente.DataCadastro,
            TotalConsultas = paciente.Consultas.Count
        };

        return Ok(ApiResponse<PacienteResponseDto>.Ok(response));
    }

    [HttpPost]
    public async Task<IActionResult> Criar([FromBody] PacienteRequestDto dto)
    {
        if (!ModelState.IsValid)
            return BadRequest(ApiResponse<PacienteResponseDto>.Erro("Dados inválidos."));

        var cpfJaExiste = await _context.Pacientes.AnyAsync(p => p.Cpf == dto.Cpf);
        if (cpfJaExiste)
            return BadRequest(ApiResponse<PacienteResponseDto>.Erro("CPF já cadastrado."));

        var paciente = new Paciente
        {
            Nome = dto.Nome.Trim(),
            Cpf = dto.Cpf.Trim(),
            Telefone = dto.Telefone?.Trim(),
            DataCadastro = DateTime.UtcNow
        };

        _context.Pacientes.Add(paciente);
        await _context.SaveChangesAsync();

        var response = new PacienteResponseDto
        {
            Id = paciente.Id,
            Nome = paciente.Nome,
            Cpf = paciente.Cpf,
            Telefone = paciente.Telefone,
            DataCadastro = paciente.DataCadastro,
            TotalConsultas = 0
        };

        return CreatedAtAction(nameof(ObterPorId), new { id = paciente.Id }, ApiResponse<PacienteResponseDto>.Ok(response, "Paciente criado com sucesso."));
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Atualizar(int id, [FromBody] PacienteRequestDto dto)
    {
        if (!ModelState.IsValid)
            return BadRequest(ApiResponse<PacienteResponseDto>.Erro("Dados inválidos."));

        var paciente = await _context.Pacientes.FirstOrDefaultAsync(p => p.Id == id);

        if (paciente == null)
            return NotFound(ApiResponse<PacienteResponseDto>.Erro($"Paciente com Id {id} não encontrado."));

        var cpfJaExiste = await _context.Pacientes.AnyAsync(p => p.Cpf == dto.Cpf && p.Id != id);
        if (cpfJaExiste)
            return BadRequest(ApiResponse<PacienteResponseDto>.Erro("CPF já cadastrado por outro paciente."));

        paciente.Nome = dto.Nome.Trim();
        paciente.Cpf = dto.Cpf.Trim();
        paciente.Telefone = dto.Telefone?.Trim();

        _context.Pacientes.Update(paciente);
        await _context.SaveChangesAsync();

        var response = await _context.Pacientes
            .Where(p => p.Id == id)
            .Select(p => new PacienteResponseDto
            {
                Id = p.Id,
                Nome = p.Nome,
                Cpf = p.Cpf,
                Telefone = p.Telefone,
                DataCadastro = p.DataCadastro,
                TotalConsultas = p.Consultas.Count()
            })
            .FirstAsync();

        return Ok(ApiResponse<PacienteResponseDto>.Ok(response, "Paciente atualizado com sucesso."));
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Deletar(int id)
    {
        var paciente = await _context.Pacientes.FirstOrDefaultAsync(p => p.Id == id);

        if (paciente == null)
            return NotFound(ApiResponse<object>.Erro($"Paciente com Id {id} não encontrado."));

        _context.Pacientes.Remove(paciente);
        await _context.SaveChangesAsync();

        return Ok(ApiResponse<string>.Ok("", "Paciente deletado com sucesso."));
    }
}
