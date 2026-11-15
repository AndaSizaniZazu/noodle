namespace Noodle.Api;

/// <summary>
/// The teacher's chosen language comes in the X-Lang header ("en" or "xh").
/// isiXhosa text is used when it exists; otherwise the English text is the fallback.
/// </summary>
public static class Lang
{
    public static bool IsXh(this HttpRequest request) =>
        string.Equals(request.Headers["X-Lang"].ToString(), "xh", StringComparison.OrdinalIgnoreCase);

    public static string Pick(bool xh, string en, string? isiXhosa) =>
        xh && !string.IsNullOrWhiteSpace(isiXhosa) ? isiXhosa : en;

    public static string? PickOptional(bool xh, string? en, string? isiXhosa) =>
        xh && !string.IsNullOrWhiteSpace(isiXhosa) ? isiXhosa : en;
}
