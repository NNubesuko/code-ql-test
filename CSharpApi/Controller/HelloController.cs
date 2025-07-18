namespace CSharpApi.Controllers;

using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CSharpApi.Data;
using CSharpApi.Models;

[ApiController]
[Route("api/[controller]")]
public class HelloController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public HelloController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    [Route("hello")]
    public IActionResult GetHello()
    {
        return Ok("Hello, World!");
    }

    [HttpGet]
    [Route("users")]
    public async Task<IActionResult> GetUsers()
    {
        var users = await _context.Users.ToListAsync();
        return Ok(users);
    }

    [HttpGet]
    [Route("users/{id}")]
    public async Task<IActionResult> GetUser(int id)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null)
        {
            return NotFound();
        }
        return Ok(user);
    }

    [HttpGet]
    [Route("users/search")]
    public async Task<IActionResult> SearchUsers(string name)
    {
        if (string.IsNullOrEmpty(name))
        {
            return BadRequest("名前パラメータが必要です");
        }

        // 安全なパラメータ化クエリを使用
        var users = await _context.Users
            .Where(u => u.Name.Contains(name))
            .ToListAsync();

        return Ok(users);
    }

    [HttpPost]
    [Route("users")]
    public async Task<IActionResult> CreateUser([FromBody] User user)
    {
        if (user == null)
        {
            return BadRequest("ユーザーデータが必要です");
        }

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetUser), new { id = user.Id }, user);
    }
}