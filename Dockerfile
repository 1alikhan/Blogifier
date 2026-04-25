FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
RUN apk add --no-cache npm
COPY ./ /opt/blogifier
WORKDIR /opt/blogifier
RUN dotnet publish -c Release /p:RuntimeIdentifier=linux-musl-x64 ./src/Blogifier/Blogifier.csproj -o dist

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS runtime
RUN apk add --no-cache icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
ENV ASPNETCORE_URLS=http://+:8080
COPY --from=build /opt/blogifier/dist /opt/blogifier/
WORKDIR /opt/blogifier
ENTRYPOINT ["dotnet", "Blogifier.dll"]
