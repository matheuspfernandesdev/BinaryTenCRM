# Imagem base apenas para rodar o app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

# (Não precisa do USER app porque ele não existe por padrão)
WORKDIR /app

# Expõe a porta padrão 80 para aplicações web
EXPOSE 80
# Se você tiver alguma porta específica para WebSocket ou gRPC, exponha aqui (ex: 443 ou 5000)

# Fase de build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Argumento opcional para configuração do build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copia o csproj e faz restore (evita rebuilds desnecessários se só código mudou)
COPY ["BinaryTenCRM.csproj", "./"]
RUN dotnet restore "./BinaryTenCRM.csproj"

# Copia todo o código restante
COPY . .

# Compila a aplicação
RUN dotnet build "./BinaryTenCRM.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Fase de publicação
FROM build AS publish
RUN dotnet publish "./BinaryTenCRM.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Fase final: onde o app vai rodar
FROM base AS final
WORKDIR /app

# Copia os arquivos da fase de publish
COPY --from=publish /app/publish .

# Ponto de entrada da aplicação
ENTRYPOINT ["dotnet", "BinaryTenCRM.dll"]
