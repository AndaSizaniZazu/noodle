using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;

namespace Noodle.Api.Auth;

public static class SupabaseAuth
{
    /// <summary>
    /// Validates Supabase access tokens. New Supabase projects sign tokens with
    /// asymmetric keys published at {url}/auth/v1/.well-known/jwks.json; older projects
    /// use the HS256 "JWT secret". Both are supported: set Supabase:JwtSecret only for the latter.
    /// </summary>
    public static IServiceCollection AddSupabaseAuth(this IServiceCollection services, IConfiguration config)
    {
        var url = (config["Supabase:Url"] ?? throw new InvalidOperationException("Supabase:Url is not configured")).TrimEnd('/');
        var issuer = $"{url}/auth/v1";
        var jwtSecret = config["Supabase:JwtSecret"];

        services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(o =>
            {
                o.MapInboundClaims = false;
                if (string.IsNullOrWhiteSpace(jwtSecret))
                {
                    // Signing keys come straight from Supabase's JWKS endpoint.
                    o.TokenValidationParameters = Params(issuer);
                    o.TokenValidationParameters.IssuerSigningKeyResolver = (_, _, _, _) => Jwks.Get(issuer);
                }
                else
                {
                    o.TokenValidationParameters = Params(issuer);
                    o.TokenValidationParameters.IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSecret));
                }
            });
        services.AddAuthorization();
        return services;
    }

    private static TokenValidationParameters Params(string issuer) => new()
    {
        ValidateIssuer = true,
        ValidIssuer = issuer,
        ValidateAudience = true,
        ValidAudience = "authenticated",
        ValidateLifetime = true,
        ClockSkew = TimeSpan.FromMinutes(1),
        NameClaimType = "sub",
    };

    public static Guid UserId(this ClaimsPrincipal user) =>
        Guid.Parse(user.FindFirstValue("sub") ?? throw new UnauthorizedAccessException());

    public static string? Email(this ClaimsPrincipal user) => user.FindFirstValue("email");

    /// <summary>Small cached JWKS fetcher (refreshes every hour).</summary>
    private static class Jwks
    {
        private static readonly HttpClient Http = new();
        private static readonly SemaphoreSlim Lock = new(1, 1);
        private static IList<SecurityKey> _keys = [];
        private static DateTimeOffset _fetched = DateTimeOffset.MinValue;

        public static IEnumerable<SecurityKey> Get(string issuer)
        {
            if (DateTimeOffset.UtcNow - _fetched < TimeSpan.FromHours(1) && _keys.Count > 0) return _keys;
            Lock.Wait();
            try
            {
                if (DateTimeOffset.UtcNow - _fetched < TimeSpan.FromHours(1) && _keys.Count > 0) return _keys;
                var json = Http.GetStringAsync($"{issuer}/.well-known/jwks.json").GetAwaiter().GetResult();
                _keys = new JsonWebKeySet(json).GetSigningKeys();
                _fetched = DateTimeOffset.UtcNow;
                return _keys;
            }
            finally { Lock.Release(); }
        }
    }
}
