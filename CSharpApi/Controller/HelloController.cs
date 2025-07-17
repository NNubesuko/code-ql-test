namespace CSharpApi.Controllers;
using Microsoft.AspNetCore.Mvc;

public class HelloController : ControllerBase
{
    [HttpGet]
    [Route("hello")]
    public IActionResult GetHello()
    {
        return Ok("Hello, World!");
    }
}