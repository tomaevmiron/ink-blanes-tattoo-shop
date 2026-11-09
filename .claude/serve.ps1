param([string]$Root,[int]$Port=4173)
$l=New-Object System.Net.HttpListener
$l.Prefixes.Add("http://localhost:$Port/")
$l.Start()
Write-Host "Serving $Root on http://localhost:$Port/"
$mime=@{'.html'='text/html; charset=utf-8';'.css'='text/css';'.js'='text/javascript';'.png'='image/png';'.jpg'='image/jpeg';'.svg'='image/svg+xml';'.json'='application/json'}
while($l.IsListening){
  $c=$l.GetContext()
  try{
    $p=[Uri]::UnescapeDataString($c.Request.Url.AbsolutePath).TrimStart('/')
    if($p -eq ''){$p='index.html'}
    $f=[IO.Path]::GetFullPath((Join-Path $Root $p))
    if($f.StartsWith($Root) -and (Test-Path $f -PathType Leaf)){
      $b=[IO.File]::ReadAllBytes($f)
      $e=[IO.Path]::GetExtension($f).ToLower()
      if($mime[$e]){$c.Response.ContentType=$mime[$e]}
      $c.Response.Headers.Add('Cache-Control','no-store')
      $c.Response.OutputStream.Write($b,0,$b.Length)
    } else { $c.Response.StatusCode=404 }
  }catch{}
  $c.Response.Close()
}
