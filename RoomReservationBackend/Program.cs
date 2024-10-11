using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using RoomReservationBackend.Data;
using RoomReservationBackend.Repositories;
using RoomReservationBackend.Services;
using RoomReservationBackend.Utilities;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Load configuration settings
var configuration = builder.Configuration;

// Add services to the container
builder.Services.AddDbContext<RoomReservationContext>(options =>
    options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));

// Register application services and repositories
builder.Services.AddScoped<UserRepository>();
builder.Services.AddScoped<ReservationRepository>();
builder.Services.AddScoped<RoomRepository>();
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<ReservationService>();
builder.Services.AddScoped<EmailService>(sp => new EmailService(
    configuration["Email:SmtpServer"],
    int.Parse(configuration["Email:SmtpPort"]),
    configuration["Email:FromEmail"],
    configuration["Email:FromPassword"]
));
builder.Services.AddSingleton<JwtAuthenticationManager>(sp =>
    new JwtAuthenticationManager(configuration["Jwt:SecretKey"])
);

// Add CORS policy
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllOrigins", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

// Add JWT Authentication
var jwtSecretKey = configuration["Jwt:SecretKey"];
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
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSecretKey)),
        ValidateIssuer = false,
        ValidateAudience = false
    };
});

builder.Services.AddScoped<RoomService>();


// Register controllers
builder.Services.AddControllers();

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
app.UseCors("AllowAllOrigins"); // Use the CORS policy

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
