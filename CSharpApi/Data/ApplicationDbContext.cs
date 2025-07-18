using Microsoft.EntityFrameworkCore;
using CSharpApi.Models;
using System;

namespace CSharpApi.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // シードデータ
            modelBuilder.Entity<User>().HasData(
                new User
                {
                    Id = 1,
                    Name = "田中太郎",
                    Email = "tanaka@example.com",
                    Age = 30,
                    CreatedAt = DateTime.UtcNow
                },
                new User
                {
                    Id = 2,
                    Name = "佐藤花子",
                    Email = "sato@example.com",
                    Age = 25,
                    CreatedAt = DateTime.UtcNow
                },
                new User
                {
                    Id = 3,
                    Name = "鈴木次郎",
                    Email = "suzuki@example.com",
                    Age = 35,
                    CreatedAt = DateTime.UtcNow
                }
            );
        }
    }
}
