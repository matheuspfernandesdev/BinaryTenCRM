# Imagem base apenas para rodar o app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

# (N�o precisa do USER app porque ele n�o existe por padr�o)
WORKDIR /app

# Exp�e a porta padr�o 80 para aplica��es web
EXPOSE 80
# Se voc� tiver alguma porta espec�fica para WebSocket ou gRPC, exponha aqui (ex: 443 ou 5000)

# Fase de build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Argumento opcional para configura��o do build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copia o csproj e faz restore (evita rebuilds desnecess�rios se s� c�digo mudou)
COPY ["BinaryTenCRM.csproj", "./"]
RUN dotnet restore "./BinaryTenCRM.csproj"

# Copia todo o c�digo restante
COPY . .

# Compila a aplica��o
RUN dotnet build "./BinaryTenCRM.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Fase de publica��o
FROM build AS publish
RUN dotnet publish "./BinaryTenCRM.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Fase final: onde o app vai rodar
FROM base AS final
WORKDIR /app

# Copia os arquivos da fase de publish
COPY --from=publish /app/publish .

# Ponto de entrada da aplica��o
ENTRYPOINT ["dotnet", "BinaryTenCRM.dll"]
