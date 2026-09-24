Add-Type -AssemblyName System.Drawing
$path = 'd:\expense_manager\expense_manager\assets\language_top.png'
$src = [System.Drawing.Image]::FromFile($path)
$bmp = New-Object System.Drawing.Bitmap $src.Width, $src.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::Transparent)
$g.DrawImage($src, 0, 0, $src.Width, $src.Height)
$g.Dispose()
$src.Dispose()

$cleared = 0
for ($y = 0; $y -lt $bmp.Height; $y++) {
  for ($x = 0; $x -lt $bmp.Width; $x++) {
    $c = $bmp.GetPixel($x, $y)
    if ($c.R -le 45 -and $c.G -le 45 -and $c.B -le 45) {
      $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
      $cleared++
    }
  }
}
$tmp = 'd:\expense_manager\expense_manager\assets\_language_top_clean.png'
$bmp.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Copy-Item -Force $tmp $path
Remove-Item $tmp
Write-Output "cleared=$cleared pixels"
