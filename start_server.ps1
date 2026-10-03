$port = 8088
$root = "c:\Users\Dell\Desktop\HoneyChain\weathercast_pro"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Output "HTTP Server listening on http://localhost:$port/"

# Launch Chrome directly
Start-Process "C:\Program Files\Google\Chrome\Application\chrome.exe" "http://localhost:$port/virtual_device_simulator.html"

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    
    $urlPath = $request.Url.LocalPath.TrimStart('/')
    if ([string]::IsNullOrEmpty($urlPath)) {
        $urlPath = "virtual_device_simulator.html"
    }
    
    $filePath = Join-Path $root $urlPath
    if (Test-Path $filePath -PathType Leaf) {
        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        if ($filePath.EndsWith(".html")) {
            $response.ContentType = "text/html; charset=utf-8"
        } elseif ($filePath.EndsWith(".js")) {
            $response.ContentType = "application/javascript"
        } elseif ($filePath.EndsWith(".css")) {
            $response.ContentType = "text/css"
        }
        $response.ContentLength64 = $bytes.Length
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $response.StatusCode = 404
        $msg = [System.Text.Encoding]::UTF8.GetBytes("Not Found")
        $response.OutputStream.Write($msg, 0, $msg.Length)
    }
    $response.OutputStream.Close()
}
