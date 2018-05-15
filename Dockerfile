FROM microsoft/aspnetcore:2.0-nanoserver-sac2016 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0-nanoserver-sac2016 AS build
WORKDIR /src
COPY AspNetCoreTest/AspNetCoreTest.csproj AspNetCoreTest/
RUN dotnet restore AspNetCoreTest/AspNetCoreTest.csproj
COPY . .
WORKDIR /src/AspNetCoreTest
RUN dotnet build AspNetCoreTest.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish AspNetCoreTest.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "AspNetCoreTest.dll"]
