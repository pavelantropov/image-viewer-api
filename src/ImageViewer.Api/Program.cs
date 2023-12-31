using System.Reflection;
using System.Text;
using FluentValidation;
using ImageViewer.Api.Model.ApiModels;
using ImageViewer.Api.ServiceCollectionExtensions;
using ImageViewer.AutoMapper.MappingProfiles;
using ImageViewer.UseCases.Interfaces;
using ImageViewer.Validation.Validators;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddAutoMapper(Assembly.GetAssembly(typeof(ImageMapProfile)));
builder.Services.AddValidatorsFromAssemblyContaining<ImageValidator>();
builder.Services.AddNHibernate(builder.Configuration);
builder.Services.AddFactories();
builder.Services.AddInfrastructure();
builder.Services.AddUseCases();

builder.Services.AddCors(options =>
{
	options.AddDefaultPolicy(
		b =>
		{
			b.AllowAnyOrigin()
				.AllowAnyMethod()
				.AllowAnyHeader();
		});
});

// builder.Services.AddAuthentication(options =>
// {
// 	options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
// 	options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
// })
// 	.AddJwtBearer(options =>
// 	{
// 		options.TokenValidationParameters = new TokenValidationParameters
// 		{
// 			ValidateIssuer = true,
// 			ValidateAudience = true,
// 			ValidateLifetime = true,
// 			ValidateIssuerSigningKey = true,
// 			ValidIssuer = builder.Configuration["Jwt:Issuer"],
// 			ValidAudience = builder.Configuration["Jwt:Issuer"],
// 			IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"])),
// 		};
// 	});
// builder.Services.AddAuthorization(options =>
// {
// 	options.AddPolicy("RequireAdminRole", policy => policy.RequireRole("Admin"));
// 	options.AddPolicy("RequireUserRole", policy => policy.RequireRole("User"));
// });

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
	options.SwaggerDoc("v1", new OpenApiInfo
	{
		Version = "v1",
		Title = "Image Viewer",
		Description = "Image Viewer Web Api by Pavel Antropov",
		Contact = new OpenApiContact
		{
			Name = "Pavel Antropov",
			Url = new Uri("https://www.linkedin.com/in/pavelantropov/")
		},
	});
	options.EnableAnnotations();
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
	app.UseSwagger();
	app.UseSwaggerUI(options => {
		options.SwaggerEndpoint("./swagger/v1/swagger.json", "Image Viewer Web Api");
		options.RoutePrefix = string.Empty;
	});
}

app.UseCors();
app.UseHttpsRedirection();

// app.UseAuthentication();
// app.UseAuthorization();

app.MapGet(
	"api/images",
	async ([FromQuery] string filter, IGetListOfImagesUseCase useCase, CancellationToken cancellationToken) =>
	{
		return Results.Ok(await useCase.Invoke(filter, cancellationToken));
	})
	.WithName("GetListOfImages")
	.WithOpenApi();

app.MapGet(
	"api/images/{id:int}",
	async ([FromRoute] int id, IGetImageUseCase useCase, CancellationToken cancellationToken) =>
	{
		try
		{
			return Results.Ok(await useCase.Invoke(id, cancellationToken));
		}
		catch (FileNotFoundException)
		{
			return Results.NotFound();
		}
	})
	.WithName("GetImage")
	.WithOpenApi();

app.MapPost(
	"api/images",
	// async ([FromBody] UploadImageRequestModel request, IUploadImageUseCase useCase, CancellationToken cancellationToken) =>
	async (HttpContext context, IUploadImageUseCase useCase, CancellationToken cancellationToken) =>
	{
		var form = await context.Request.ReadFormAsync(cancellationToken);

		var request = new UploadImageRequestModel
		{
			Name = form["name"],
			Description = form["description"],
			Content = form.Files.FirstOrDefault(file => file.Name == "content"),
		};

		if (request.Content == null || request.Content.Length == 0)
		{
			return Results.BadRequest("Please attach an image.");
		}

		return Results.Ok(await useCase.Invoke(request, cancellationToken));
	})
	.WithName("PostImage")
	.WithOpenApi();

app.MapDelete(
	"api/images/{id:int}",
	async ([FromRoute] int id, IDeleteImageUseCase useCase, CancellationToken cancellationToken) =>
	{
		try
		{
			await useCase.Invoke(id, cancellationToken);
			return Results.Ok();
		}
		catch (FileNotFoundException)
		{
			return Results.NotFound();
		}
	})
	.WithName("DeleteImage")
	.WithOpenApi();

app.Run();
