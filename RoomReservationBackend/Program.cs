using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using RoomReservationBackend.Data;
using RoomReservationBackend.Repositories;
using RoomReservationBackend.Services;
using RoomReservationBackend.Utilities;
using System.Text;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Load configuration settings
var configuration = builder.Configuration;

// Add services to the container
builder.Services.AddDbContext<RoomReservationContext>(options =>
    options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")
    ?? throw new ArgumentNullException("DefaultConnection string is required")));

// Register application services and repositories
builder.Services.AddScoped<UserRepository>();
builder.Services.AddScoped<ReservationRepository>();
builder.Services.AddScoped<RoomRepository>();
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<ReservationService>();
builder.Services.AddScoped<RoomService>();

builder.Services.AddScoped<EmailService>(sp => new EmailService(
    configuration["Email:SmtpServer"] ?? throw new ArgumentNullException("SmtpServer is required"),
    int.TryParse(configuration["Email:SmtpPort"], out int smtpPort) ? smtpPort : throw new ArgumentNullException("SmtpPort is required"),
    configuration["Email:FromEmail"] ?? throw new ArgumentNullException("FromEmail is required"),
    configuration["Email:FromPassword"] ?? throw new ArgumentNullException("FromPassword is required")
));
builder.Services.AddSingleton<JwtAuthenticationManager>(sp =>
    new JwtAuthenticationManager(configuration["Jwt:SecretKey"] ?? throw new ArgumentNullException("Jwt:SecretKey is required")));

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
if (string.IsNullOrWhiteSpace(jwtSecretKey))
{
    throw new ArgumentNullException("Jwt:SecretKey is required");
}

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

// Swagger for API documentation with JWT authentication
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Please insert JWT token",
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        BearerFormat = "JWT",
        Scheme = "bearer"
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

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
