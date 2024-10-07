using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using RoomReservationBackend.Data;
using RoomReservationBackend.Services;
using RoomReservationBackend.Utilities;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container

// Register the DbContext with SQL Server
builder.Services.AddDbContext<RoomReservationContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Register application services
builder.Services.AddScoped<RoomService>();
builder.Services.AddScoped<ReservationService>();
builder.Services.AddScoped<UserService>();

// Register repository classes
builder.Services.AddScoped<RoomRepository>();
builder.Services.AddScoped<ReservationRepository>();
builder.Services.AddScoped<UserRepository>();

// Add JWT Authentication
builder.Services.AddSingleton(new JwtAuthenticationManager("YourSecretKey"));

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("YourSecretKey")),
        ValidateIssuer = false,
        ValidateAudience = false
    };
});

// Register controllers
builder.Services.AddControllers();

builder.Services.AddSingleton(new EmailService("smtp.example.com", 587, "noreply@example.com", "your_smtp_password"));

// Swagger for API documentation
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
