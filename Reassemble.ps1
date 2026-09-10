# Rebuild the finished TorchUMM ZIP using built-in Windows PowerShell.
param([string]$OutputPath = (Join-Path $PSScriptRoot 'TorchUMM-main.zip'))

$ErrorActionPreference = 'Stop'
$expectedSize = 35263131L
$expectedHash = 'C25670A6D46D184C3CE9FC93629454A20AB0D5612CE56004C261FA4B3ECE29BF'
$parts = @(
    @{
        Name = 'TorchUMM-main.zip.001'
        Size = 17631566L
        Hash = 'C6A0A059AB53E98274C36868AFF5E28E10E0070063CCD8B8A2F9BCCFEEAB3526'
    },
    @{
        Name = 'TorchUMM-main.zip.002'
        Size = 17631565L
        Hash = '534D2611908DA7661252BDF08157F746590FB6CE2EE7ADA0A447A987510038B3'
    }
)
$temporaryPath = $null
$temporaryCreated = $false

try {
    $OutputPath = [System.IO.Path]::GetFullPath($OutputPath)
    $outputDirectory = [System.IO.Path]::GetDirectoryName($OutputPath)
    if (-not (Test-Path -LiteralPath $outputDirectory -PathType Container)) {
        throw "Output directory does not exist: $outputDirectory"
    }
    if (Test-Path -LiteralPath $OutputPath) {
        if ((Test-Path -LiteralPath $OutputPath -PathType Leaf) -and
            (Get-Item -LiteralPath $OutputPath).Length -eq $expectedSize -and
            (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash -eq $expectedHash) {
            Write-Host "Already rebuilt and verified: $OutputPath"
            exit 0
        }
        throw "A different file or directory already exists at $OutputPath. Move it or choose another output path."
    }

    foreach ($part in $parts) {
        $partPath = Join-Path $PSScriptRoot $part.Name
        Write-Host "Checking $($part.Name)..."
        if (-not (Test-Path -LiteralPath $partPath -PathType Leaf)) {
            throw "Missing $($part.Name). Put both parts next to Reassemble.ps1 and try again."
        }
        if ((Get-Item -LiteralPath $partPath).Length -ne $part.Size -or
            (Get-FileHash -LiteralPath $partPath -Algorithm SHA256).Hash -ne $part.Hash) {
            throw "$($part.Name) is incomplete or changed. Copy that part again."
        }
    }

    $temporaryPath = Join-Path $outputDirectory ('TorchUMM-' + [guid]::NewGuid().ToString('N') + '.partial')
    $outputStream = [System.IO.File]::Open($temporaryPath, [System.IO.FileMode]::CreateNew)
    $temporaryCreated = $true
    try {
        foreach ($part in $parts) {
            Write-Host "Joining $($part.Name)..."
            $inputStream = [System.IO.File]::OpenRead((Join-Path $PSScriptRoot $part.Name))
            try { $inputStream.CopyTo($outputStream) }
            finally { $inputStream.Dispose() }
        }
    } finally {
        $outputStream.Dispose()
    }

    if ((Get-Item -LiteralPath $temporaryPath).Length -ne $expectedSize -or
        (Get-FileHash -LiteralPath $temporaryPath -Algorithm SHA256).Hash -ne $expectedHash) {
        throw 'The rebuilt ZIP did not match the original. No finished ZIP was created.'
    }
    [System.IO.File]::Move($temporaryPath, $OutputPath)
    $temporaryCreated = $false
    Write-Host ''
    Write-Host "Success! Rebuilt and verified: $OutputPath"
    Write-Host 'Right-click the ZIP and choose Extract All to unpack your project.'
    exit 0
} catch {
    [Console]::Error.WriteLine('Reassembly failed: ' + $_.Exception.Message)
    exit 1
} finally {
    if ($temporaryCreated -and (Test-Path -LiteralPath $temporaryPath -PathType Leaf)) {
        [System.IO.File]::Delete($temporaryPath)
    }
}
