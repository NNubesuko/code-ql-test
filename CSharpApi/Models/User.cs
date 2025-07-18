using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSharpApi.Models
{
    [Table("users")]
    public class User
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("name")]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;

        [Column("email")]
        [StringLength(255)]
        public string Email { get; set; } = string.Empty;

        [Column("age")]
        public int Age { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
