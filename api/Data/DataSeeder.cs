using DentalCore.API.Models;
using DentalCore.API.Enums;
using Microsoft.EntityFrameworkCore;

namespace DentalCore.API.Data;

public static class DataSeeder
{
    public static void Seed(AppDbContext context)
    {
        // Só executa se a tabela de Usuarios estiver vazia
        if (!context.Usuarios.Any())
        {
            context.Usuarios.Add(new Usuario
            {
                Nome = "Administrador",
                Email = "admin@dental.com",
                SenhaHash = BCrypt.Net.BCrypt.HashPassword("admin123"),
                Role = Role.Admin,
                DataCadastro = DateTime.UtcNow
            });
            context.SaveChanges();
        }

        // Só executa se a tabela de Pacientes estiver vazia
        if (context.Pacientes.Any()) return;

        var pacientes = new List<Paciente>
        {
            new Paciente 
            { 
                Nome = "João Silva", 
                Cpf = "123.456.789-01", 
                Telefone = "(11) 98888-7777",
                DataCadastro = DateTime.UtcNow
            },
            new Paciente 
            { 
                Nome = "Maria Oliveira", 
                Cpf = "234.567.890-12", 
                Telefone = "(11) 97777-6666",
                DataCadastro = DateTime.UtcNow
            },
            new Paciente 
            { 
                Nome = "Pedro Santos", 
                Cpf = "345.678.901-23", 
                Telefone = "(11) 96666-5555",
                DataCadastro = DateTime.UtcNow
            }
        };

        context.Pacientes.AddRange(pacientes);
        context.SaveChanges();

        // Adicionar algumas consultas para os pacientes
        var joao = pacientes[0];
        var maria = pacientes[1];

        var consultas = new List<Consulta>
        {
            new Consulta 
            { 
                PacienteId = joao.Id, 
                DataHora = DateTime.UtcNow.AddDays(1).Date.AddHours(9), 
                StatusConsulta = StatusConsulta.Agendada, 
                Observacao = "Limpeza de rotina",
                DataExclusao = null
            },
            new Consulta 
            { 
                PacienteId = maria.Id, 
                DataHora = DateTime.UtcNow.AddDays(2).Date.AddHours(14), 
                StatusConsulta = StatusConsulta.Agendada, 
                Observacao = "Avaliação de aparelho",
                DataExclusao = null
            },
            new Consulta 
            { 
                PacienteId = joao.Id, 
                DataHora = DateTime.UtcNow.AddDays(-1).Date.AddHours(10), 
                StatusConsulta = StatusConsulta.Realizada, 
                Observacao = "Extração de siso",
                DataExclusao = null
            }
        };

        context.Consultas.AddRange(consultas);
        context.SaveChanges();
    }
}
