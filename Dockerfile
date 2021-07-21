#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src

COPY ["GoogleSheetI18n.Api/GoogleSheetI18n.Api.csproj", "GoogleSheetI18n.Api/"]
COPY ["GoogleSheetI18n.Common/GoogleSheetI18n.Common.csproj", "GoogleSheetI18n.Common/"]
COPY ["GoogleSheetI18n.Infrastructure/GoogleSheetI18n.Infrastructure.csproj", "GoogleSheetI18n.Infrastructure/"]

RUN dotnet restore "GoogleSheetI18n.Api/GoogleSheetI18n.Api.csproj"
COPY . .
WORKDIR "/src/GoogleSheetI18n.Api"
RUN dotnet build "GoogleSheetI18n.Api.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "GoogleSheetI18n.Api.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "GoogleSheetI18n.Api.dll"]
