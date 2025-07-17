namespace CSharpApi.Controllers;

using System;
using Microsoft.AspNetCore.Mvc;

public class HelloController : ControllerBase
{
    [HttpGet]
    [Route("hello")]
    public IActionResult GetHello(string name)
    {
        var query = @$"SELECT * FROM {name}";
        Console.WriteLine(query);
        return Ok("Hello, World!");
    }
}