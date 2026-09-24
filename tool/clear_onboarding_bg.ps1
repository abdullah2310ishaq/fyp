# Flood-fill near-black from corners so dark chrome on the art stays intact.
Add-Type -AssemblyName System.Drawing

$files = @(
  'd:\expense_manager\expense_manager\assets\images\onboarding_one.png',
  'd:\expense_manager\expense_manager\assets\images\onboarding_two.png',
  'd:\expense_manager\expense_manager\assets\images\onboarding_three.png'
)

function Clear-NearBlackBg([string]$path) {
  $src = [System.Drawing.Image]::FromFile($path)
  $bmp = New-Object System.Drawing.Bitmap $src.Width, $src.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.Clear([System.Drawing.Color]::Transparent)
  $g.DrawImage($src, 0, 0, $src.Width, $src.Height)
  $g.Dispose()
  $src.Dispose()

  $w = $bmp.Width
  $h = $bmp.Height
  $visited = New-Object 'bool[,]' $w, $h
  $queue = New-Object System.Collections.Generic.Queue[System.Drawing.Point]
  $threshold = 28

  function IsBg([System.Drawing.Color]$c) {
    return ($c.A -gt 0) -and ($c.R -le $threshold) -and ($c.G -le $threshold) -and ($c.B -le $threshold)
  }

  $seeds = @(
    (New-Object System.Drawing.Point 0, 0),
    (New-Object System.Drawing.Point ($w - 1), 0),
    (New-Object System.Drawing.Point 0, ($h - 1)),
    (New-Object System.Drawing.Point ($w - 1), ($h - 1)),
    (New-Object System.Drawing.Point ([int]($w / 2)), 0),
    (New-Object System.Drawing.Point ([int]($w / 2)), ($h - 1))
  )
  foreach ($p in $seeds) {
    if (IsBg ($bmp.GetPixel($p.X, $p.Y))) { $queue.Enqueue($p) }
  }

  $cleared = 0
  $transparent = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
  while ($queue.Count -gt 0) {
    $p = $queue.Dequeue()
    $x = $p.X; $y = $p.Y
    if ($x -lt 0 -or $y -lt 0 -or $x -ge $w -or $y -ge $h) { continue }
    if ($visited[$x, $y]) { continue }
    $visited[$x, $y] = $true
    $c = $bmp.GetPixel($x, $y)
    if (-not (IsBg $c)) { continue }
    $bmp.SetPixel($x, $y, $transparent)
    $cleared++
    $queue.Enqueue((New-Object System.Drawing.Point ($x + 1), $y))
    $queue.Enqueue((New-Object System.Drawing.Point ($x - 1), $y))
    $queue.Enqueue((New-Object System.Drawing.Point $x, ($y + 1)))
    $queue.Enqueue((New-Object System.Drawing.Point $x, ($y - 1)))
  }

  $tmp = "$path.__clean.png"
  $bmp.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  Copy-Item -Force $tmp $path
  Remove-Item $tmp
  Write-Output "$(Split-Path $path -Leaf): cleared=$cleared"
}

foreach ($f in $files) { Clear-NearBlackBg $f }
