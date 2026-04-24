using DentalCore.API.Models;
using Microsoft.EntityFrameworkCore;

namespace DentalCore.API.Data;

/// <summary>
/// Contexto principal do banco de dados do DentalCore.
/// Configura tabelas, relacionamentos e filtros globais de Soft Delete.
/// </summary>
public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    // ── DbSets (Tabelas) ───────────────────────────────────────
    public DbSet<Paciente> Pacientes { get; set; }
    public DbSet<Consulta> Consultas { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // ── Filtro Global de Soft Delete ───────────────────────
        // Todas as queries automaticamente ignoram registros onde DataExclusao != null
        // Para ignorar o filtro pontualmente: .IgnoreQueryFilters()
        modelBuilder.Entity<Paciente>().HasQueryFilter(p => p.DataExclusao == null);
        modelBuilder.Entity<Consulta>().HasQueryFilter(c => c.DataExclusao == null);

        // ── Configuração: Paciente ─────────────────────────────
        modelBuilder.Entity<Paciente>(entity =>
        {
            entity.ToTable("Pacientes");
            entity.HasKey(p => p.Id);
            entity.Property(p => p.Nome).IsRequired().HasMaxLength(150);
            entity.Property(p => p.Telefone).HasMaxLength(20);
            entity.Property(p => p.DataCadastro).HasDefaultValueSql("GETUTCDATE()");
        });

        // ── Configuração: Consulta ─────────────────────────────
        modelBuilder.Entity<Consulta>(entity =>
        {
            entity.ToTable("Consultas");
            entity.HasKey(c => c.Id);

            // StatusConsulta salvo como int no banco (mais performático que string)
            entity.Property(c => c.StatusConsulta)
                  .HasConversion<int>()
                  .IsRequired();

            entity.Property(c => c.Observacao).HasMaxLength(500);

            // Relacionamento: Paciente 1 -> N Consultas
            entity.HasOne(c => c.Paciente)
                  .WithMany(p => p.Consultas)
                  .HasForeignKey(c => c.PacienteId)
                  .OnDelete(DeleteBehavior.Restrict); // Não apaga consultas em cascata
        });
    }
}
