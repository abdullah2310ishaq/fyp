Add-Type -AssemblyName System.Drawing

function New-GradientPng {
    param(
        [string]$Path,
        [int[]]$TopRgb,
        [int[]]$BottomRgb
    )

    $w = 4
    $h = 1024
    $bmp = New-Object System.Drawing.Bitmap $w, $h
    for ($y = 0; $y -lt $h; $y++) {
        $t = $y / ($h - 1)
        $r = [int]($TopRgb[0] * (1 - $t) + $BottomRgb[0] * $t)
        $g = [int]($TopRgb[1] * (1 - $t) + $BottomRgb[1] * $t)
        $b = [int]($TopRgb[2] * (1 - $t) + $BottomRgb[2] * $t)
        $color = [System.Drawing.Color]::FromArgb($r, $g, $b)
        for ($x = 0; $x -lt $w; $x++) {
            $bmp.SetPixel($x, $y, $color)
        }
    }
    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

$out = Join-Path $PSScriptRoot '..\assets\images'
New-GradientPng -Path (Join-Path $out 'native_splash_bg.png') -TopRgb @(255, 255, 255) -BottomRgb @(0xDC, 0xEB, 0xFA)
New-GradientPng -Path (Join-Path $out 'native_splash_bg_dark.png') -TopRgb @(0x12, 0x12, 0x12) -BottomRgb @(0x1E, 0x2A, 0x3A)
Write-Output 'native splash backgrounds generated'
