using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using RoomReservationBackend.Data;
using RoomReservationBackend.Services;
using RoomReservationBackend.Utilities;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Load configuration settings
var configuration = builder.Configuration;

// Add services to the container
builder.Services.AddDbContext<RoomReservationContext>(options =>
    options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));

// Register application services
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<UserRepository>();

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
var jwtSecretKey = "Saidia12!";
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
