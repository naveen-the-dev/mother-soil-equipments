# ============================================================
# Mother Soil Equipments
# Language Fix + Google Sheets Integration
#
# IMPORTANT:
# - NO UI / CSS / layout redesign
# - Existing product/category data is preserved
# - Creates a backup before making changes
# ============================================================

$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# PROJECT PATH
# ------------------------------------------------------------

$ProjectPath = "C:\Users\Admin\projects\mse\mother-soil-equipments"

if (-not (Test-Path $ProjectPath)) {
    Write-Host "Project folder not found:" -ForegroundColor Red
    Write-Host $ProjectPath
    exit 1
}

Set-Location $ProjectPath

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host " Mother Soil Equipments" -ForegroundColor Green
Write-Host " Language + Google Sheets Fix" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

# ------------------------------------------------------------
# BACKUP
# ------------------------------------------------------------

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupPath = Join-Path $ProjectPath "backup-before-language-sheets-$timestamp"

Write-Host "Creating backup..." -ForegroundColor Cyan

New-Item -ItemType Directory -Path $backupPath -Force | Out-Null

if (Test-Path ".\src") {
    Copy-Item ".\src" (Join-Path $backupPath "src") -Recurse -Force
}

if (Test-Path ".\public") {
    Copy-Item ".\public" (Join-Path $backupPath "public") -Recurse -Force
}

if (Test-Path ".\.env") {
    Copy-Item ".\.env" (Join-Path $backupPath ".env") -Force
}

if (Test-Path ".\package.json") {
    Copy-Item ".\package.json" (Join-Path $backupPath "package.json") -Force
}

Write-Host "Backup created:" -ForegroundColor Green
Write-Host $backupPath
Write-Host ""

# ------------------------------------------------------------
# SAFE UTF-8 WRITER
# ------------------------------------------------------------

function Write-Utf8File {
    param(
        [string]$Path,
        [string]$Content
    )

    $directory = Split-Path -Parent $Path

    if ($directory -and -not (Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
}

# ------------------------------------------------------------
# READ UTF-8
# ------------------------------------------------------------

function Read-Utf8File {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return ""
    }

    return [System.IO.File]::ReadAllText(
        $Path,
        [System.Text.UTF8Encoding]::new($false)
    )
}

# ------------------------------------------------------------
# PATCH FILE HELPER
# ------------------------------------------------------------

function Replace-Text {
    param(
        [string]$Path,
        [string]$Old,
        [string]$New,
        [string]$Description
    )

    $content = Read-Utf8File $Path

    if ($content -eq "") {
        Write-Host "SKIP: $Path not found" -ForegroundColor Yellow
        return
    }

    if (-not $content.Contains($Old)) {
        Write-Host "SKIP: Pattern not found - $Description" -ForegroundColor Yellow
        return
    }

    $content = $content.Replace($Old, $New)
    Write-Utf8File $Path $content

    Write-Host "PATCHED: $Description" -ForegroundColor Green
}

# ============================================================
# 1. LOCALIZATION
# ============================================================

Write-Host ""
Write-Host "Fixing language system..." -ForegroundColor Cyan

# ------------------------------------------------------------
# App.vue
#
# Keep current architecture.
# Expose toggleLanguage because Navbar expects it.
# Also maintain document language.
# ------------------------------------------------------------

$appPath = ".\src\App.vue"

$appContent = @'
<script setup>
import { computed, provide, ref, watch } from "vue"
import Navbar from "./components/Navbar.vue"
import SiteFooter from "./components/SiteFooter.vue"
import en from "./locales/en"
import ta from "./locales/ta"

const dictionaries = { en, ta }

const savedLanguage = localStorage.getItem("mse-language") || "en"

const language = ref(
  savedLanguage === "ta" || savedLanguage === "en"
    ? savedLanguage
    : "en"
)

const t = computed(() => dictionaries[language.value] || en)

watch(
  language,
  (value) => {
    localStorage.setItem("mse-language", value)
    document.documentElement.lang = value === "ta" ? "ta" : "en"
  },
  { immediate: true }
)

function toggleLanguage() {
  language.value = language.value === "en" ? "ta" : "en"
}

provide("siteI18n", {
  language,
  t,
  toggleLanguage
})
</script>

<template>
  <div class="app-shell">
    <Navbar />
    <main>
      <RouterView />
    </main>
    <SiteFooter />
  </div>
</template>
'@

Write-Utf8File $appPath $appContent

Write-Host "UPDATED: App.vue language provider" -ForegroundColor Green

# ------------------------------------------------------------
# Navbar.vue
#
# No layout changes.
# Only fix language switch text and translation usage.
# ------------------------------------------------------------

$navbarPath = ".\src\components\Navbar.vue"

$navbarContent = Read-Utf8File $navbarPath

if ($navbarContent -ne "") {

    # Repair the known corrupted Tamil switch text.
    $navbarContent = $navbarContent -replace 'à®¤à®®à®¿à®´à¯', 'தமிழ்'

    # If the exact corrupted arrow/menu text exists, repair it.
    $navbarContent = $navbarContent -replace 'â†', '←'
    $navbarContent = $navbarContent -replace 'â†’', '→'

    # Make sure the language switch uses the actual provider function.
    # Current App.vue exposes toggleLanguage.
    $navbarContent = $navbarContent -replace 'toggleLanguage\(\);\s*closeMenu\(\)', 'toggleLanguage(); closeMenu()'

    Write-Utf8File $navbarPath $navbarContent

    Write-Host "UPDATED: Navbar.vue language switch" -ForegroundColor Green
}

# ============================================================
# 2. ENGLISH TRANSLATION FILE
# ============================================================

Write-Host ""
Write-Host "Updating English translation dictionary..." -ForegroundColor Cyan

$enPath = ".\src\locales\en.js"

$enContent = @'
export default {
  nav: {
    home: "Home",
    products: "Products",
    subsidy: "Subsidy",
    about: "About Us",
    contact: "Contact",
    menu: "Toggle navigation menu",
    language: "Tamil"
  },

  common: {
    viewProducts: "View Products",
    viewDetails: "View Details",
    previous: "Previous",
    next: "Next",
    whatsapp: "WhatsApp",
    arrow: "→"
  },

  hero: {
    eyebrow: "MOTHER SOIL EQUIPMENTS",
    title: "Agricultural Equipment for Better Farming",
    text: "Explore practical agricultural equipment for farmers and professional use.",
    products: "Explore Products",
    contact: "Contact Us"
  },

  categories: {
    title: "Explore Our Categories",
    view: "View Products",
    previous: "Previous categories",
    next: "Next categories"
  },

  videos: {
    title: "Agricultural Videos",
    text: "See agricultural equipment in action and learn about practical applications.",
    watch: "Watch Video",
    previous: "Previous videos",
    next: "Next videos"
  },

  subsidy: {
    title: "Subsidy-Supported Machinery",
    text: "Explore agricultural machinery that may be covered under applicable government subsidy schemes.",
    badge: "Subsidy",
    view: "View Subsidy Machinery",
    details: "Subsidy Details",
    note: "Subsidy availability, eligibility and amount depend on the applicable government scheme.",
    enquiry: "Enquire About Subsidy",
    disclaimer: "Government schemes, eligibility, approved machinery and subsidy amounts can change. Please verify the current scheme and eligibility with the relevant government department before making a purchase decision.",
    emptyTitle: "No subsidy-supported products have been published yet.",
    emptyText: "Add applicable products in the product data when their subsidy information is confirmed."
  },

  products: {
    title: "Our Products",
    subtitle: "Agricultural equipment for different farming needs",
    description: "Explore agricultural equipment and tools for different farming requirements.",
    search: "Search products...",
    all: "All",
    results: "Products",
    noResults: "No products found.",
    clear: "Clear Search",
    details: "View Details",
    enquire: "Enquire",
    related: "Related Products",
    category: "Category",
    viewAll: "View All",
    notFound: "Product Not Found",
    notFoundDescription: "The requested product could not be found.",
    back: "Back to Products",
    backToCategory: "Back to Category",
    filterLabel: "Filter products"
  },

  why: {
    title: "Why Mother Soil",
    quality: "Quality Equipment",
    range: "Wide Product Range",
    guidance: "Product Guidance",
    support: "Customer Support"
  },

  about: {
    title: "About Mother Soil",
    text: "Mother Soil Equipments is based in Namakkal, Tamil Nadu, providing agricultural equipment and related products.",
    more: "Learn More",
    websiteDescription: "Our website is designed as a simple product catalogue so farmers can browse equipment categories, understand product information and contact us for enquiries."
  },

  faq: {
    title: "Frequently Asked Questions",
    q1: "What agricultural equipment do you provide?",
    a1: "We have products across sprayers, brush cutters, weeders, power tools, accessories and other agricultural equipment.",
    q2: "Do you provide subsidy guidance?",
    a2: "We can help you understand subsidy-related information for applicable agricultural machinery. Scheme rules and eligibility depend on the government programme.",
    q3: "How can I enquire about a product?",
    a3: "Use the Enquire or WhatsApp option on a product, or contact Mother Soil Equipments directly.",
    q4: "Where are you located?",
    a4: "Mother Soil Equipments is located on Salem Road, Namakkal, Tamil Nadu."
  },

  contact: {
    title: "Need Agricultural Equipment?",
    text: "Contact Mother Soil Equipments for your agricultural equipment requirements.",
    whatsapp: "WhatsApp",
    call: "Call",
    email: "Email",
    formTitle: "Send an Enquiry",
    name: "Your Name",
    phone: "Phone Number",
    message: "Your Message",
    send: "Send Enquiry",
    success: "Thank you. Your enquiry is ready to be sent.",
    address: "Address",
    phoneLabel: "Phone",
    emailLabel: "Email"
  },

  footer: {
    follow: "Follow Mother Soil",
    quickLinks: "Quick Links",
    categories: "Categories",
    rights: "All rights reserved."
  },

  messages: {
    productContact: "Contact us for current availability, specifications and quotation.",
    whatsappProduct: "Hello Mother Soil Equipments, I am interested in",
    whatsappSubsidy: "Hello Mother Soil Equipments, I would like to enquire about subsidy-supported agricultural machinery."
  }
}
'@

Write-Utf8File $enPath $enContent

Write-Host "UPDATED: locales/en.js" -ForegroundColor Green

# ============================================================
# 3. TAMIL TRANSLATION FILE
# ============================================================

Write-Host ""
Write-Host "Restoring Tamil translation dictionary..." -ForegroundColor Cyan

$taPath = ".\src\locales\ta.js"

$taContent = @'
export default {
  nav: {
    home: "முகப்பு",
    products: "தயாரிப்புகள்",
    subsidy: "மானியம்",
    about: "எங்களைப் பற்றி",
    contact: "தொடர்பு",
    menu: "வழிசெலுத்தல் மெனுவைத் திறக்கவும்",
    language: "தமிழ்"
  },

  common: {
    viewProducts: "தயாரிப்புகளைப் பார்க்கவும்",
    viewDetails: "விவரங்களைப் பார்க்கவும்",
    previous: "முந்தையது",
    next: "அடுத்தது",
    whatsapp: "WhatsApp",
    arrow: "→"
  },

  hero: {
    eyebrow: "MOTHER SOIL EQUIPMENTS",
    title: "சிறந்த விவசாயத்திற்கான விவசாய உபகரணங்கள்",
    text: "விவசாயிகள் மற்றும் தொழில்முறை பயன்பாட்டிற்கான பயனுள்ள விவசாய உபகரணங்களைப் பாருங்கள்.",
    products: "தயாரிப்புகளைப் பார்க்கவும்",
    contact: "எங்களைத் தொடர்புகொள்ளவும்"
  },

  categories: {
    title: "எங்கள் வகைகளைப் பார்க்கவும்",
    view: "தயாரிப்புகளைப் பார்க்கவும்",
    previous: "முந்தைய வகைகள்",
    next: "அடுத்த வகைகள்"
  },

  videos: {
    title: "விவசாய வீடியோக்கள்",
    text: "விவசாய உபகரணங்களின் செயல்பாட்டைப் பார்த்து அவற்றின் பயன்பாடுகளை அறிந்துகொள்ளுங்கள்.",
    watch: "வீடியோவைப் பார்க்கவும்",
    previous: "முந்தைய வீடியோக்கள்",
    next: "அடுத்த வீடியோக்கள்"
  },

  subsidy: {
    title: "மானியம் பெறக்கூடிய விவசாய இயந்திரங்கள்",
    text: "பொருந்தக்கூடிய அரசு மானியத் திட்டங்களின் கீழ் பயன்பெறக்கூடிய விவசாய இயந்திரங்களைப் பார்க்கவும்.",
    badge: "மானியம்",
    view: "மானியம் பெறக்கூடிய இயந்திரங்களைப் பார்க்கவும்",
    details: "மானிய விவரங்கள்",
    note: "மானியத்தின் கிடைக்கும் தன்மை, தகுதி மற்றும் தொகை பொருந்தக்கூடிய அரசு திட்டத்தைப் பொறுத்தது.",
    enquiry: "மானியம் குறித்து விசாரிக்கவும்",
    disclaimer: "அரசுத் திட்டங்கள், தகுதி விதிமுறைகள், அங்கீகரிக்கப்பட்ட இயந்திரங்கள் மற்றும் மானியத் தொகைகள் மாறக்கூடும். வாங்கும் முடிவை எடுப்பதற்கு முன் சம்பந்தப்பட்ட அரசு துறையிடம் தற்போதைய திட்டம் மற்றும் தகுதியைச் சரிபார்க்கவும்.",
    emptyTitle: "மானியம் பெறக்கூடிய தயாரிப்புகள் இதுவரை வெளியிடப்படவில்லை.",
    emptyText: "மானியத் தகவல் உறுதிசெய்யப்பட்ட தயாரிப்புகளை தயாரிப்பு தரவுகளில் சேர்க்கவும்."
  },

  products: {
    title: "எங்கள் தயாரிப்புகள்",
    subtitle: "பல்வேறு விவசாயத் தேவைகளுக்கான விவசாய உபகரணங்கள்",
    description: "பல்வேறு விவசாயத் தேவைகளுக்கான விவசாய உபகரணங்கள் மற்றும் கருவிகளைப் பார்க்கவும்.",
    search: "தயாரிப்புகளைத் தேடவும்...",
    all: "அனைத்தும்",
    results: "தயாரிப்புகள்",
    noResults: "தயாரிப்புகள் எதுவும் கிடைக்கவில்லை.",
    clear: "தேடலை அழிக்கவும்",
    details: "விவரங்களைப் பார்க்கவும்",
    enquire: "விசாரிக்கவும்",
    related: "தொடர்புடைய தயாரிப்புகள்",
    category: "வகை",
    viewAll: "அனைத்தையும் பார்க்கவும்",
    notFound: "தயாரிப்பு கிடைக்கவில்லை",
    notFoundDescription: "நீங்கள் கேட்ட தயாரிப்பைக் கண்டறிய முடியவில்லை.",
    back: "தயாரிப்புகளுக்குத் திரும்பவும்",
    backToCategory: "வகைக்குத் திரும்பவும்",
    filterLabel: "தயாரிப்புகளை வடிகட்டவும்"
  },

  why: {
    title: "Mother Soil ஏன்?",
    quality: "தரமான உபகரணங்கள்",
    range: "பரந்த தயாரிப்பு வரம்பு",
    guidance: "தயாரிப்பு வழிகாட்டுதல்",
    support: "வாடிக்கையாளர் ஆதரவு"
  },

  about: {
    title: "Mother Soil பற்றி",
    text: "Mother Soil Equipments தமிழ்நாட்டின் நாமக்கல்லைத் தளமாகக் கொண்டு விவசாய உபகரணங்கள் மற்றும் தொடர்புடைய தயாரிப்புகளை வழங்குகிறது.",
    more: "மேலும் அறியவும்",
    websiteDescription: "விவசாயிகள் உபகரண வகைகளைப் பார்த்து, தயாரிப்பு தகவல்களைப் புரிந்துகொண்டு, விசாரணைகளுக்காக எங்களைத் தொடர்புகொள்ளும் வகையில் எங்கள் இணையதளம் எளிய தயாரிப்பு பட்டியலாக வடிவமைக்கப்பட்டுள்ளது."
  },

  faq: {
    title: "அடிக்கடி கேட்கப்படும் கேள்விகள்",
    q1: "எந்த விவசாய உபகரணங்களை வழங்குகிறீர்கள்?",
    a1: "தெளிப்பான்கள், புல் வெட்டும் கருவிகள், களையெடுக்கும் கருவிகள், பவர் டூல்கள், உதிரிப்பாகங்கள் மற்றும் பிற விவசாய உபகரணங்கள் உள்ளிட்ட பல்வேறு தயாரிப்புகள் எங்களிடம் உள்ளன.",
    q2: "மானியம் தொடர்பான வழிகாட்டுதலை வழங்குகிறீர்களா?",
    a2: "பொருந்தக்கூடிய விவசாய இயந்திரங்களுக்கான மானியம் தொடர்பான தகவல்களைப் புரிந்துகொள்ள நாங்கள் உதவலாம். திட்ட விதிமுறைகள் மற்றும் தகுதி அரசு திட்டத்தைப் பொறுத்தது.",
    q3: "ஒரு தயாரிப்பு குறித்து எப்படி விசாரிப்பது?",
    a3: "தயாரிப்பில் உள்ள விசாரிக்கவும் அல்லது WhatsApp விருப்பத்தைப் பயன்படுத்தலாம். அல்லது Mother Soil Equipments-ஐ நேரடியாகத் தொடர்புகொள்ளலாம்.",
    q4: "நீங்கள் எங்கு அமைந்துள்ளீர்கள்?",
    a4: "Mother Soil Equipments தமிழ்நாடு, நாமக்கல், சேலம் சாலையில் அமைந்துள்ளது."
  },

  contact: {
    title: "விவசாய உபகரணங்கள் தேவையா?",
    text: "உங்கள் விவசாய உபகரணத் தேவைகளுக்காக Mother Soil Equipments-ஐத் தொடர்புகொள்ளவும்.",
    whatsapp: "WhatsApp",
    call: "அழைக்கவும்",
    email: "மின்னஞ்சல்",
    formTitle: "விசாரணையை அனுப்பவும்",
    name: "உங்கள் பெயர்",
    phone: "தொலைபேசி எண்",
    message: "உங்கள் செய்தி",
    send: "விசாரணையை அனுப்பவும்",
    success: "நன்றி. உங்கள் விசாரணை அனுப்பத் தயாராக உள்ளது.",
    address: "முகவரி",
    phoneLabel: "தொலைபேசி",
    emailLabel: "மின்னஞ்சல்"
  },

  footer: {
    follow: "Mother Soil-ஐப் பின்தொடரவும்",
    quickLinks: "விரைவு இணைப்புகள்",
    categories: "வகைகள்",
    rights: "அனைத்து உரிமைகளும் பாதுகாக்கப்பட்டவை."
  },

  messages: {
    productContact: "தற்போதைய இருப்பு, விவரக்குறிப்புகள் மற்றும் விலைப்பற்றி அறிய எங்களைத் தொடர்புகொள்ளவும்.",
    whatsappProduct: "வணக்கம் Mother Soil Equipments, எனக்கு இந்த தயாரிப்பில் ஆர்வம் உள்ளது:",
    whatsappSubsidy: "வணக்கம் Mother Soil Equipments, மானியம் பெறக்கூடிய விவசாய இயந்திரங்கள் குறித்து விசாரிக்க விரும்புகிறேன்."
  }
}
'@

Write-Utf8File $taPath $taContent

Write-Host "UPDATED: locales/ta.js" -ForegroundColor Green

# ============================================================
# 4. CATEGORY CARD
# ============================================================

Write-Host ""
Write-Host "Fixing category language mapping..." -ForegroundColor Cyan

$categoryCardPath = ".\src\components\CategoryCard.vue"

$categoryCard = Read-Utf8File $categoryCardPath

if ($categoryCard -ne "") {

    # Current data model:
    # name = English
    # tamil = Tamil name
    # description = English
    # tamilDescription = Tamil description

    $categoryCard = $categoryCard.Replace(
        'props.category.tamil : props.category.description',
        'props.category.tamilDescription || props.category.description'
    )

    Write-Utf8File $categoryCardPath $categoryCard

    Write-Host "UPDATED: CategoryCard.vue" -ForegroundColor Green
}

# ============================================================
# 5. PRODUCT CARD
# ============================================================

Write-Host ""
Write-Host "Fixing product language handling..." -ForegroundColor Cyan

$productCardPath = ".\src\components\ProductCard.vue"

$productCard = Read-Utf8File $productCardPath

if ($productCard -ne "") {

    # Repair known mojibake arrow.
    $productCard = $productCard.Replace("â†’", "→")

    # Replace hardcoded WhatsApp message with translation-aware message.
    $oldWhatsapp = 'const whatsappUrl = computed(() => `https://wa.me/${company.whatsapp}?text=${encodeURIComponent(`Hello Mother Soil Equipments, I am interested in ${props.product.name}.`)}`)'

    $newWhatsapp = @'
const whatsappUrl = computed(() => {
  const productName =
    language.value === "ta"
      ? props.product.tamil || props.product.name
      : props.product.name

  const message = `${t.messages.whatsappProduct} ${productName}.`

  return `https://wa.me/${company.whatsapp}?text=${encodeURIComponent(message)}`
})
'@

    if ($productCard.Contains($oldWhatsapp)) {
        $productCard = $productCard.Replace($oldWhatsapp, $newWhatsapp)
    }

    # Replace visible hardcoded WhatsApp label.
    $productCard = $productCard.Replace(
        '>WhatsApp</a>',
        '>{{ t.common.whatsapp }}</a>'
    )

    Write-Utf8File $productCardPath $productCard

    Write-Host "UPDATED: ProductCard.vue" -ForegroundColor Green
}

# ============================================================
# 6. PRODUCT DETAIL
# ============================================================

Write-Host ""
Write-Host "Fixing product detail language..." -ForegroundColor Cyan

$detailFiles = Get-ChildItem ".\src\views" -Filter "*.vue" -File

foreach ($file in $detailFiles) {

    $content = Read-Utf8File $file.FullName

    if ($content -eq "") {
        continue
    }

    # Known mojibake arrow / middle-dot.
    $content = $content.Replace("â†’", "→")
    $content = $content.Replace("Â·", "·")

    Write-Utf8File $file.FullName $content
}

Write-Host "Checked view files for known encoding corruption." -ForegroundColor Green

# ============================================================
# 7. SUBSIDY VIEW
# ============================================================

Write-Host ""
Write-Host "Fixing subsidy translation usage..." -ForegroundColor Cyan

$subsidyPath = ".\src\views\Subsidy.vue"

$subsidy = Read-Utf8File $subsidyPath

if ($subsidy -ne "") {

    # Replace hardcoded disclaimer.
    $subsidy = [regex]::Replace(
        $subsidy,
        '<p>Government schemes, eligibility, approved machinery and subsidy amounts can change\.\s*Please verify the current scheme and eligibility with the relevant government department before making a purchase decision\.</p>',
        '<p>{{ t.subsidy.disclaimer }}</p>'
    )

    # Replace hardcoded empty state.
    $subsidy = [regex]::Replace(
        $subsidy,
        '<h3>No subsidy-supported products have been published yet\.</h3>\s*<p>Add applicable products in <code>src/data/products\.js</code> when their subsidy information is confirmed\.</p>',
        '<h3>{{ t.subsidy.emptyTitle }}</h3><p>{{ t.subsidy.emptyText }}</p>'
    )

    # Replace hardcoded WhatsApp message.
    $old = 'encodeURIComponent("Hello Mother Soil Equipments, I would like to enquire about subsidy-supported agricultural machinery.")'

    $new = 'encodeURIComponent(t.messages.whatsappSubsidy)'

    $subsidy = $subsidy.Replace($old, $new)

    Write-Utf8File $subsidyPath $subsidy

    Write-Host "UPDATED: Subsidy.vue" -ForegroundColor Green
}

# ============================================================
# 8. ABOUT VIEW
# ============================================================

Write-Host ""
Write-Host "Fixing About page translation usage..." -ForegroundColor Cyan

$aboutPath = ".\src\views\About.vue"

if (Test-Path $aboutPath) {

    $about = Read-Utf8File $aboutPath

    $about = [regex]::Replace(
        $about,
        '<p>Our website is designed as a simple product catalogue so farmers can browse equipment categories, understand product information and contact us for enquiries\.</p>',
        '<p>{{ t.about.websiteDescription }}</p>'
    )

    Write-Utf8File $aboutPath $about

    Write-Host "UPDATED: About.vue" -ForegroundColor Green
}

# ============================================================
# 9. CATEGORY CAROUSEL
# ============================================================

Write-Host ""
Write-Host "Fixing category carousel translations..." -ForegroundColor Cyan

$categoryCarouselPath = ".\src\components\CategoryCarousel.vue"

if (Test-Path $categoryCarouselPath) {

    $carousel = Read-Utf8File $categoryCarouselPath

    $carousel = $carousel.Replace(
        'aria-label="Previous categories"',
        ':aria-label="t.categories.previous"'
    )

    $carousel = $carousel.Replace(
        'aria-label="Next categories"',
        ':aria-label="t.categories.next"'
    )

    $carousel = $carousel.Replace("â†", "←")
    $carousel = $carousel.Replace("â†’", "→")

    Write-Utf8File $categoryCarouselPath $carousel

    Write-Host "UPDATED: CategoryCarousel.vue" -ForegroundColor Green
}

# ============================================================
# 10. VIDEO CAROUSEL
# ============================================================

Write-Host ""
Write-Host "Fixing video carousel translations..." -ForegroundColor Cyan

$videoCarouselPath = ".\src\components\VideoCarousel.vue"

if (Test-Path $videoCarouselPath) {

    $videoCarousel = Read-Utf8File $videoCarouselPath

    $videoCarousel = $videoCarousel.Replace(
        'aria-label="Previous videos"',
        ':aria-label="t.videos.previous"'
    )

    $videoCarousel = $videoCarousel.Replace(
        'aria-label="Next videos"',
        ':aria-label="t.videos.next"'
    )

    $videoCarousel = $videoCarousel.Replace("â†", "←")
    $videoCarousel = $videoCarousel.Replace("â†’", "→")

    Write-Utf8File $videoCarouselPath $videoCarousel

    Write-Host "UPDATED: VideoCarousel.vue" -ForegroundColor Green
}

# ============================================================
# GOOGLE SHEETS INTEGRATION
# ============================================================

Write-Host ""
Write-Host "Adding Google Sheets integration..." -ForegroundColor Cyan

$serviceDir = ".\src\services"

if (-not (Test-Path $serviceDir)) {
    New-Item -ItemType Directory -Path $serviceDir -Force | Out-Null
}

# ------------------------------------------------------------
# googleSheet.js
#
# Important:
# NO syncSubsidyProducts import.
# Existing subsidyProducts array is updated directly.
# ------------------------------------------------------------

$googleSheetPath = ".\src\services\googleSheet.js"

$googleSheetContent = @'
import {
  products,
  subsidyProducts
} from "../data/products"

import { categories } from "../data/categories"
import { videos } from "../data/videos"
import { company } from "../data/company"

export const GOOGLE_SHEET_API_URL =
  import.meta.env.VITE_GOOGLE_SHEET_API_URL || ""

const clean = (value) => {
  if (value == null) return ""
  return String(value).trim()
}

function toBool(value) {
  if (typeof value === "boolean") {
    return value
  }

  return [
    "true",
    "1",
    "yes",
    "y",
    "on"
  ].includes(clean(value).toLowerCase())
}

function normalizeProduct(row) {
  const applicable =
    row.subsidyApplicable !== undefined
      ? toBool(row.subsidyApplicable)
      : toBool(row.subsidy?.applicable)

  return {
    ...row,

    id: clean(row.id),

    categoryId: clean(
      row.categoryId || row.category
    ),

    name: clean(
      row.name || row.nameEn
    ),

    tamil: clean(
      row.tamil || row.nameTa
    ),

    description: clean(
      row.description || row.descriptionEn
    ),

    tamilDescription: clean(
      row.tamilDescription || row.descriptionTa
    ),

    image:
      clean(row.image) ||
      "/images/logo.jpg",

    subsidy: {
      ...(row.subsidy || {}),
      applicable
    },

    featured: toBool(row.featured),

    active:
      row.active === "" ||
      row.active == null
        ? true
        : toBool(row.active)
  }
}

function normalizeCategory(row) {
  return {
    ...row,

    id: clean(row.id),

    name: clean(
      row.name || row.nameEn
    ),

    tamil: clean(
      row.tamil || row.nameTa
    ),

    description: clean(
      row.description || row.descriptionEn
    ),

    tamilDescription: clean(
      row.tamilDescription
    ),

    image:
      clean(row.image) ||
      "/images/logo.jpg",

    active:
      row.active === "" ||
      row.active == null
        ? true
        : toBool(row.active)
  }
}

function normalizeVideo(row) {
  return {
    ...row,

    id: clean(row.id),

    title: clean(
      row.title || row.titleEn
    ),

    tamil: clean(
      row.tamil || row.titleTa
    ),

    description: clean(
      row.description || row.descriptionEn
    ),

    tamilDescription: clean(
      row.tamilDescription ||
      row.descriptionTa
    ),

    youtubeId: clean(
      row.youtubeId ||
      row.youtube_id
    ),

    url: clean(row.url),

    active:
      row.active === "" ||
      row.active == null
        ? true
        : toBool(row.active)
  }
}

function normalizeCompany(row) {
  const phones = row.phones
    ? String(row.phones)
        .split("|")
        .map((value) => value.trim())
        .filter(Boolean)
    : [
        clean(row.phone1),
        clean(row.phone2)
      ].filter(Boolean)

  return {
    ...company,

    name:
      clean(row.name) ||
      company.name,

    address:
      clean(row.address) ||
      company.address,

    phones:
      phones.length
        ? phones
        : company.phones,

    email:
      clean(row.email) ||
      company.email,

    whatsapp:
      clean(row.whatsapp).replace(/\D/g, "") ||
      company.whatsapp,

    social: {
      ...(company.social || {}),

      facebook:
        clean(row.facebook) ||
        company.social?.facebook ||
        "",

      instagram:
        clean(row.instagram) ||
        company.social?.instagram ||
        "",

      youtube:
        clean(row.youtube) ||
        company.social?.youtube ||
        ""
    }
  }
}

export function applyRemoteData(data) {
  if (
    !data ||
    typeof data !== "object"
  ) {
    throw new Error(
      "Invalid Google Sheets response"
    )
  }

  // ----------------------------------------------------------
  // Categories
  // ----------------------------------------------------------

  if (Array.isArray(data.categories)) {

    const rows = data.categories
      .map(normalizeCategory)
      .filter(
        (item) =>
          item.id &&
          item.active
      )

    if (rows.length) {
      categories.splice(
        0,
        categories.length,
        ...rows
      )
    }
  }

  // ----------------------------------------------------------
  // Products
  // ----------------------------------------------------------

  if (Array.isArray(data.products)) {

    const rows = data.products
      .map(normalizeProduct)
      .filter(
        (item) =>
          item.id &&
          item.categoryId &&
          item.name &&
          item.active
      )

    if (rows.length) {

      products.splice(
        0,
        products.length,
        ...rows
      )

      // IMPORTANT:
      // Do not import syncSubsidyProducts.
      // Rebuild the exported subsidyProducts array directly.
      subsidyProducts.splice(
        0,
        subsidyProducts.length,
        ...products.filter(
          (product) =>
            product.subsidy?.applicable
        )
      )
    }
  }

  // ----------------------------------------------------------
  // Videos
  // ----------------------------------------------------------

  if (Array.isArray(data.videos)) {

    const rows = data.videos
      .map(normalizeVideo)
      .filter(
        (item) =>
          item.id &&
          item.youtubeId &&
          item.active
      )

    if (rows.length) {

      videos.splice(
        0,
        videos.length,
        ...rows
      )
    }
  }

  // ----------------------------------------------------------
  // Company
  // ----------------------------------------------------------

  if (
    data.company &&
    typeof data.company === "object"
  ) {
    Object.assign(
      company,
      normalizeCompany(
        data.company
      )
    )
  }
}

export async function loadRemoteData() {

  if (!GOOGLE_SHEET_API_URL) {
    return {
      loaded: false,
      reason: "not-configured"
    }
  }

  const separator =
    GOOGLE_SHEET_API_URL.includes("?")
      ? "&"
      : "?"

  const response = await fetch(
    `${GOOGLE_SHEET_API_URL}${separator}_=${Date.now()}`,
    {
      headers: {
        Accept: "application/json"
      },
      cache: "no-store"
    }
  )

  if (!response.ok) {
    throw new Error(
      `Google Sheets API returned ${response.status}`
    )
  }

  const data =
    await response.json()

  applyRemoteData(data)

  return {
    loaded: true
  }
}
'@

Write-Utf8File $googleSheetPath $googleSheetContent

Write-Host "CREATED: src/services/googleSheet.js" -ForegroundColor Green

# ============================================================
# 11. MAIN.JS
#
# Load Google Sheets BEFORE Vue mount.
#
# This preserves the existing local data as fallback.
# ============================================================

Write-Host ""
Write-Host "Connecting Google Sheets loader to application startup..." -ForegroundColor Cyan

$mainPath = ".\src\main.js"

$mainContent = @'
import { createApp } from "vue"
import App from "./App.vue"
import router from "./router"
import "./assets/styles/main.css"
import { loadRemoteData } from "./services/googleSheet"

async function bootstrap() {
  try {
    await loadRemoteData()
    console.info("Mother Soil Equipments: remote data loaded.")
  } catch (error) {
    console.warn(
      "Mother Soil Equipments: Google Sheets unavailable. Using local data.",
      error
    )
  }

  createApp(App)
    .use(router)
    .mount("#app")
}

bootstrap()
'@

Write-Utf8File $mainPath $mainContent

Write-Host "UPDATED: src/main.js" -ForegroundColor Green

# ============================================================
# 12. ENV FILE
# ============================================================

Write-Host ""
Write-Host "Preparing Google Sheets environment variable..." -ForegroundColor Cyan

$envPath = ".\.env"

if (Test-Path $envPath) {

    $envContent = Read-Utf8File $envPath

    if ($envContent -notmatch 'VITE_GOOGLE_SHEET_API_URL\s*=') {

        if (-not $envContent.EndsWith("`n")) {
            $envContent += "`r`n"
        }

        $envContent += @"
# Google Sheets Web API
# Paste your deployed Google Apps Script Web App URL here.
VITE_GOOGLE_SHEET_API_URL=
"@

        Write-Utf8File $envPath $envContent

        Write-Host "UPDATED: .env" -ForegroundColor Green
    }
    else {
        Write-Host "Existing VITE_GOOGLE_SHEET_API_URL preserved." -ForegroundColor Green
    }

}
else {

    $envContent = @"
# Google Sheets Web API
# Paste your deployed Google Apps Script Web App URL here.
VITE_GOOGLE_SHEET_API_URL=
"@

    Write-Utf8File $envPath $envContent

    Write-Host "CREATED: .env" -ForegroundColor Green
}

# ============================================================
# 13. ENV EXAMPLE
# ============================================================

$envExamplePath = ".\.env.example"

$envExample = @'
# Google Sheets Web API
VITE_GOOGLE_SHEET_API_URL=
'@

Write-Utf8File $envExamplePath $envExample

Write-Host "CREATED: .env.example" -ForegroundColor Green

# ============================================================
# 14. NETLIFY SPA REDIRECT
#
# This is NOT a UI change.
# It prevents Page Not Found on refresh of Vue routes.
# ============================================================

Write-Host ""
Write-Host "Checking Netlify SPA redirect..." -ForegroundColor Cyan

$redirectPath = ".\public\_redirects"

if (-not (Test-Path ".\public")) {
    New-Item -ItemType Directory -Path ".\public" -Force | Out-Null
}

if (-not (Test-Path $redirectPath)) {

    Write-Utf8File $redirectPath "/*    /index.html   200`r`n"

    Write-Host "CREATED: public/_redirects" -ForegroundColor Green

}
else {

    $redirectContent = Read-Utf8File $redirectPath

    if ($redirectContent -notmatch '\*/\s+/index\.html\s+200') {

        if (-not $redirectContent.EndsWith("`n")) {
            $redirectContent += "`r`n"
        }

        $redirectContent += "/*    /index.html   200`r`n"

        Write-Utf8File $redirectPath $redirectContent

        Write-Host "UPDATED: public/_redirects" -ForegroundColor Green

    }
    else {

        Write-Host "Netlify redirect already exists." -ForegroundColor Green
    }
}

# ============================================================
# 15. BASIC VALIDATION
# ============================================================

Write-Host ""
Write-Host "Running source validation..." -ForegroundColor Cyan

$requiredFiles = @(
    ".\src\App.vue",
    ".\src\main.js",
    ".\src\locales\en.js",
    ".\src\locales\ta.js",
    ".\src\services\googleSheet.js",
    ".\src\components\Navbar.vue",
    ".\src\components\ProductCard.vue",
    ".\src\views\Products.vue",
    ".\src\views\Subsidy.vue"
)

$allPresent = $true

foreach ($file in $requiredFiles) {

    if (Test-Path $file) {
        Write-Host "OK   $file" -ForegroundColor Green
    }
    else {
        Write-Host "MISS $file" -ForegroundColor Red
        $allPresent = $false
    }
}

# ------------------------------------------------------------
# Check forbidden broken import
# ------------------------------------------------------------

$googleContent = Read-Utf8File $googleSheetPath

if ($googleContent -match 'syncSubsidyProducts') {

    Write-Host ""
    Write-Host "ERROR: syncSubsidyProducts reference still exists." -ForegroundColor Red
    $allPresent = $false

}
else {

    Write-Host "OK   No syncSubsidyProducts dependency" -ForegroundColor Green
}

# ------------------------------------------------------------
# Check Tamil dictionary
# ------------------------------------------------------------

$taCheck = Read-Utf8File $taPath

if ($taCheck -match 'தமிழ்' -and $taCheck -match 'முகப்பு') {

    Write-Host "OK   Tamil dictionary contains proper UTF-8 Tamil" -ForegroundColor Green

}
else {

    Write-Host "WARNING: Tamil dictionary validation failed." -ForegroundColor Yellow
}

# ------------------------------------------------------------
# Check Navbar provider compatibility
# ------------------------------------------------------------

$appCheck = Read-Utf8File $appPath
$navbarCheck = Read-Utf8File $navbarPath

if (
    $appCheck -match 'toggleLanguage' -and
    $navbarCheck -match 'toggleLanguage'
) {

    Write-Host "OK   Navbar/App language function compatible" -ForegroundColor Green

}
else {

    Write-Host "WARNING: Navbar/App language function mismatch detected." -ForegroundColor Yellow
}

# ============================================================
# FINISHED
# ============================================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Green

if ($allPresent) {
    Write-Host " COMPLETED SUCCESSFULLY" -ForegroundColor Green
}
else {
    Write-Host " COMPLETED WITH WARNINGS" -ForegroundColor Yellow
}

Write-Host "============================================" -ForegroundColor Green

Write-Host ""
Write-Host "Backup:" -ForegroundColor Cyan
Write-Host $backupPath

Write-Host ""
Write-Host "NEXT STEPS:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Put your Google Apps Script Web App URL in:"
Write-Host "   .env"
Write-Host ""
Write-Host "   VITE_GOOGLE_SHEET_API_URL=https://script.google.com/macros/s/XXXXX/exec"
Write-Host ""
Write-Host "2. Restart Vite after changing .env:"
Write-Host ""
Write-Host "   npm run dev"
Write-Host ""
Write-Host "3. Test:"
Write-Host "   - English -> Tamil"
Write-Host "   - Tamil -> English"
Write-Host "   - Products"
Write-Host "   - Product details"
Write-Host "   - Subsidy"
Write-Host "   - About"
Write-Host "   - Contact"
Write-Host "   - Google Sheet data"
Write-Host ""
Write-Host "4. Build:"
Write-Host ""
Write-Host "   npm run build"
Write-Host ""

Write-Host "NO UI/CSS redesign was performed by this script." -ForegroundColor Green
Write-Host ""