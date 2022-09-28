#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["ApiHeroku.csproj", "."]
RUN dotnet restore "./ApiHeroku.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ApiHeroku.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ApiHeroku.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "ApiHeroku.dll"]


## ADICIONAR LINHAS ABAIXO
RUN useradd -m myappuser
USER myappuser
CMD ASPNETCORE_URLS="http://*:$PORT" dotnet ApiHeroku.dll


##COMANDOS PARA ENVIAR
# heroku container:login
# heroku container:push web -a asp-net-ewerton
# heroku container:release web -a asp-net-ewerton

