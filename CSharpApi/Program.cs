using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using CSharpApi.Data;

var builder = WebApplication.CreateBuilder(args);

// ロギング設定
builder.Logging.ClearProviders();
builder.Logging.AddConsole();
builder.Logging.AddDebug();

// データベース接続設定
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// CORSの設定
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

builder.Services.AddControllers();

var app = builder.Build();

// データベース初期化
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    var logger = scope.ServiceProvider.GetRequiredService<ILogger<Program>>();
    
    try
    {
        logger.LogInformation("データベース接続を確認しています...");
        await context.Database.EnsureCreatedAsync();
        logger.LogInformation("データベース接続が確立されました");
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "データベース初期化中にエラーが発生しました");
        throw;
    }
}

app.UseCors("AllowAll");
app.UseRouting();
app.MapControllers();

app.MapGet("/", () => "PostgreSQL API サーバーが実行中です！");

app.Run();