FROM mcr.microsoft.com/dotnet/sdk:9.0 AS base

RUN apt update &&\
    apt install -y git &&\
    git clone https://github.com/eduardo010174/PwnedPasswordsDownloader.git

WORKDIR /PwnedPasswordsDownloader/src
RUN dotnet restore HaveIBeenPwned.PwnedPasswords.Downloader/HaveIBeenPwned.PwnedPasswords.Downloader.csproj \
    -r linux-x64 \
    /p:PublishReadyToRun=true

RUN dotnet publish HaveIBeenPwned.PwnedPasswords.Downloader/HaveIBeenPwned.PwnedPasswords.Downloader.csproj \
    -o out \
    -f net9.0 \
    --no-restore \
    -c Release \
    -r linux-x64\
    /p:PublishTrimmed=true \
    /p:PublishReadyToRun=true \
    /p:PublishSingleFile=true \
    --self-contained true

FROM mcr.microsoft.com/dotnet/runtime-deps:9.0 AS runner
WORKDIR /app
COPY --from=base /PwnedPasswordsDownloader/src/out ./
ENV PATH="$PATH:/app"
