FROM mcr.microsoft.com/mssql/server:2017-latest as base
EXPOSE 1433

# Install Unzip
RUN apt-get update && apt-get install unzip -y

# Install SQLPackage for Linux and make it executable
RUN wget -progress=bar:force -q -O sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2143497 \
    && unzip -qq sqlpackage.zip -d /opt/sqlpackage \
    && chmod +x /opt/sqlpackage/sqlpackage

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
ARG Configuration=Release

WORKDIR /
COPY . .

RUN dotnet build "./TargetDatabase.Build/TargetDatabase.Build.csproj" -c $Configuration -o /app/build

FROM base as final
# Add the DACPACs to the image
COPY --from=build "/app/build/*.dacpac" /tmp/

# Configure external build arguments to allow configurability.
ARG PASSWORD="Password"

# Configure the required environmental variables
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=$PASSWORD

# Launch SQL Server, confirm startup is complete, deploy the DACPAC, then terminate SQL Server.
# See https://stackoverflow.com/a/51589787/488695
RUN ( /opt/mssql/bin/sqlservr & ) | grep -q "Service Broker manager has started" \
    && /opt/sqlpackage/sqlpackage /a:Publish /tsn:. /tdn:TargetDatabase /tu:sa /tp:$SA_PASSWORD /sf:/tmp/TargetDatabase.Build.dacpac \
    && pkill sqlservr