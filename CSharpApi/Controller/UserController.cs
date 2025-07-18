using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using CSharpApi.Data;
using CSharpApi.Models;

namespace CSharpApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<UserController> _logger;

        public UserController(ApplicationDbContext context, ILogger<UserController> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// すべてのユーザーを取得
        /// </summary>
        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> GetAllUsers()
        {
            try
            {
                var users = await _context.Users
                    .FromSqlRaw("SELECT * FROM users ORDER BY id")
                    .ToListAsync();
                
                _logger.LogInformation("取得されたユーザー数: {Count}", users.Count);
                return Ok(users);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ユーザー取得中にエラーが発生しました");
                return StatusCode(500, "サーバーエラーが発生しました");
            }
        }

        /// <summary>
        /// 指定されたIDのユーザーを取得
        /// </summary>
        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(int id)
        {
            try
            {
                // SQLインジェクション脆弱性のあるクエリ（検証用）
                var users = await _context.Users
                    .FromSqlRaw($"SELECT * FROM users WHERE id = {id}")
                    .ToListAsync();
                
                var user = users.FirstOrDefault();
                
                if (user == null)
                {
                    _logger.LogWarning("ユーザーが見つかりません: ID {Id}", id);
                    return NotFound($"ID {id} のユーザーが見つかりません");
                }

                return Ok(user);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ユーザー取得中にエラーが発生しました: ID {Id}", id);
                return StatusCode(500, "サーバーエラーが発生しました");
            }
        }

        /// <summary>
        /// 名前でユーザーを検索
        /// </summary>
        [HttpGet("search")]
        public async Task<ActionResult<IEnumerable<User>>> SearchUsersByName([FromQuery] string name)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(name))
                {
                    return BadRequest("検索する名前を入力してください");
                }

                var users = await _context.Users
                    .FromSqlRaw($"SELECT * FROM users WHERE name = '{name}'")
                    .ToListAsync();

                _logger.LogInformation("名前 '{Name}' で検索されたユーザー数: {Count}", name, users.Count);
                return Ok(users);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ユーザー検索中にエラーが発生しました: 名前 '{Name}'", name);
                return StatusCode(500, "サーバーエラーが発生しました");
            }
        }

        /// <summary>
        /// 年齢範囲でユーザーを検索
        /// </summary>
        [HttpGet("age-range")]
        public async Task<ActionResult<IEnumerable<User>>> GetUsersByAgeRange([FromQuery] int minAge, [FromQuery] int maxAge)
        {
            try
            {
                if (minAge < 0 || maxAge < 0 || minAge > maxAge)
                {
                    return BadRequest("有効な年齢範囲を入力してください");
                }

                var users = await _context.Users
                    .Where(u => u.Age >= minAge && u.Age <= maxAge)
                    .OrderBy(u => u.Age)
                    .ToListAsync();

                _logger.LogInformation("年齢範囲 {MinAge}-{MaxAge} で検索されたユーザー数: {Count}", minAge, maxAge, users.Count);
                return Ok(users);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "年齢範囲検索中にエラーが発生しました: {MinAge}-{MaxAge}", minAge, maxAge);
                return StatusCode(500, "サーバーエラーが発生しました");
            }
        }

        /// <summary>
        /// 新しいユーザーを作成
        /// </summary>
        [HttpPost]
        public async Task<ActionResult<User>> CreateUser([FromBody] User user)
        {
            try
            {
                if (user == null)
                {
                    return BadRequest("ユーザーデータが必要です");
                }

                // メールアドレスの重複チェック
                var existingUser = await _context.Users
                    .FirstOrDefaultAsync(u => u.Email == user.Email);
                
                if (existingUser != null)
                {
                    return Conflict("このメールアドレスは既に使用されています");
                }

                user.CreatedAt = DateTime.UtcNow;
                _context.Users.Add(user);
                await _context.SaveChangesAsync();

                _logger.LogInformation("新しいユーザーが作成されました: ID {Id}, 名前 '{Name}'", user.Id, user.Name);
                return CreatedAtAction(nameof(GetUser), new { id = user.Id }, user);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ユーザー作成中にエラーが発生しました");
                return StatusCode(500, "サーバーエラーが発生しました");
            }
        }

        /// <summary>
        /// ユーザー情報を更新
        /// </summary>
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(int id, [FromBody] User user)
        {
            try
            {
                if (id != user.Id)
                {
                    return BadRequest("IDが一致しません");
                }

                var existingUser = await _context.Users.FindAsync(id);
                if (existingUser == null)
                {
                    return NotFound($"ID {id} のユーザーが見つかりません");
                }

                existingUser.Name = user.Name;
                existingUser.Email = user.Email;
                existingUser.Age = user.Age;

                await _context.SaveChangesAsync();

                _logger.LogInformation("ユーザーが更新されました: ID {Id}", id);
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ユーザー更新中にエラーが発生しました: ID {Id}", id);
                return StatusCode(500, "サーバーエラーが発生しました");
            }
        }

        /// <summary>
        /// ユーザーを削除
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            try
            {
                var user = await _context.Users.FindAsync(id);
                if (user == null)
                {
                    return NotFound($"ID {id} のユーザーが見つかりません");
                }

                _context.Users.Remove(user);
                await _context.SaveChangesAsync();

                _logger.LogInformation("ユーザーが削除されました: ID {Id}, 名前 '{Name}'", id, user.Name);
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ユーザー削除中にエラーが発生しました: ID {Id}", id);
                return StatusCode(500, "サーバーエラーが発生しました");
            }
        }

        /// <summary>
        /// データベース接続テスト
        /// </summary>
        [HttpGet("connection-test")]
        public async Task<ActionResult> TestDatabaseConnection()
        {
            try
            {
                var canConnect = await _context.Database.CanConnectAsync();
                if (canConnect)
                {
                    var userCount = await _context.Users.CountAsync();
                    return Ok(new { 
                        Status = "Connected", 
                        UserCount = userCount,
                        Timestamp = DateTime.UtcNow 
                    });
                }
                else
                {
                    return StatusCode(500, "データベースに接続できません");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "データベース接続テスト中にエラーが発生しました");
                return StatusCode(500, $"データベース接続エラー: {ex.Message}");
            }
        }
    }
}
