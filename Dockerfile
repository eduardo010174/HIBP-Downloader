FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS base

RUN apk add git &&\
    git clone https://github.com/eduardo010174/PwnedPasswordsDownloader.git

WORKDIR /PwnedPasswordsDownloader/src
RUN dotnet restore HaveIBeenPwned.PwnedPasswords.Downloader/HaveIBeenPwned.PwnedPasswords.Downloader.csproj \
    -r linux-musl-x64 \
    /p:PublishReadyToRun=true

RUN dotnet publish HaveIBeenPwned.PwnedPasswords.Downloader/HaveIBeenPwned.PwnedPasswords.Downloader.csproj \
    -o out \
    -f net8.0 \
    --no-restore \
    -c Release \
    -r linux-musl-x64\
    /p:PublishTrimmed=true \
    /p:PublishReadyToRun=true \
    /p:PublishSingleFile=true \
    --self-contained true

FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-alpine AS runner
WORKDIR /app
COPY --from=base /PwnedPasswordsDownloader/src/out ./
ENV PATH="$PATH:/app"
