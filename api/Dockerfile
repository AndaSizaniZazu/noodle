# Noodle API for Render (build context: the api/ folder).
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY Noodle.Api/Noodle.Api.csproj Noodle.Api/
RUN dotnet restore Noodle.Api/Noodle.Api.csproj
COPY Noodle.Api/ Noodle.Api/
RUN dotnet publish Noodle.Api/Noodle.Api.csproj -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app .
# Render sends traffic to port 10000 by default.
ENV ASPNETCORE_HTTP_PORTS=10000 \
    ASPNETCORE_ENVIRONMENT=Production
EXPOSE 10000
USER $APP_UID
ENTRYPOINT ["dotnet", "Noodle.Api.dll"]
