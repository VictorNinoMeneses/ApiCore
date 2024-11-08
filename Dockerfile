# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy the project files and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the entire project and build it
COPY . ./
RUN dotnet publish -c Release -o out

# Use the runtime image for the final container
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose the port your app runs on (default is 80)
EXPOSE 80
EXPOSE 5000
ENV ASPNETCORE_HTTP_PORTS=5000
ENV ASPNETCORE_ENVIRONMENT=Development

# Start the application
ENTRYPOINT ["dotnet", "ApiCore.dll"]