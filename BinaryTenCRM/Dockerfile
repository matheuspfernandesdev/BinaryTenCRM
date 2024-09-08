FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 4022 

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# O caminho correto para o arquivo .csproj diretamente no diretório atual
COPY ["BinaryTenCRM.csproj", "./"]

# Restaura os pacotes de dependência
RUN dotnet restore "./BinaryTenCRM.csproj"

# Copia todo o código-fonte para o contêiner
COPY . .

WORKDIR "/src"
RUN dotnet build "./BinaryTenCRM.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./BinaryTenCRM.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BinaryTenCRM.dll"]
