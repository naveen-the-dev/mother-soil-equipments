$ErrorActionPreference = "Stop"

$project = "C:\Users\Admin\projects\mse\mother-soil-equipments"
Set-Location $project

$cssPath = Join-Path $project "src\assets\styles\main.css"

if (-not (Test-Path $cssPath)) {
    throw "Could not find src\assets\styles\main.css. Make sure you are running this script from the Mother Soil Equipments project."
}

$marker = "/* Contact page viewport-fit refinement */"

# Avoid applying the same refinement twice.
$css = Get-Content $cssPath -Raw
if ($css -notmatch [regex]::Escape($marker)) {
    $refinement = @"
$marker
.contact-page{
  padding-top:24px;
  padding-bottom:24px;
}

.contact-page .page-hero{
  padding:24px 0 20px;
}

.contact-page .page-hero h1{
  margin-bottom:5px;
  font-size:clamp(2rem,4vw,2.8rem);
}

.contact-page .page-hero p{
  margin-bottom:0;
  font-size:.92rem;
}

.contact-page .contact-grid{
  gap:18px;
  align-items:stretch;
}

.contact-page .contact-card,
.contact-page .contact-form-card{
  padding:20px;
}

.contact-page .contact-card h2,
.contact-page .contact-form-card h2{
  margin-bottom:10px;
}

.contact-page .contact-item{
  padding:10px 0;
}

.contact-page .contact-form{
  gap:10px;
}

.contact-page .contact-form input,
.contact-page .contact-form textarea{
  padding:10px 12px;
  min-height:42px;
}

.contact-page .contact-form textarea{
  min-height:82px;
}

.contact-page .contact-form button{
  min-height:44px;
}

@media (min-width:900px){
  .contact-page{
    min-height:calc(100vh - 80px);
    display:flex;
    flex-direction:column;
    justify-content:center;
  }

  .contact-page .contact-grid{
    margin-top:8px;
  }
}

@media (max-width:680px){
  .contact-page{
    padding-top:18px;
    padding-bottom:22px;
  }

  .contact-page .page-hero{
    padding:18px 0 16px;
  }

  .contact-page .contact-card,
  .contact-page .contact-form-card{
    padding:16px;
  }
}
"@

    Add-Content -Path $cssPath -Value $refinement -Encoding UTF8
    Write-Host "Contact page viewport-fit refinement added."
}
else {
    Write-Host "Contact page refinement already exists. No duplicate changes made."
}

Write-Host ""
Write-Host "Done. Run: npm run dev"
