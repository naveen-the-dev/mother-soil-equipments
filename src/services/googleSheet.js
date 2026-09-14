import { products, subsidyProducts } from "../data/products"
import { categories } from "../data/categories"
import { videos } from "../data/videos"
import { company } from "../data/company"

export const GOOGLE_SHEET_API_URL =
  import.meta.env.VITE_GOOGLE_SHEET_API_URL || ""

const CACHE_KEY = "mother-soil-site-data-v1"
const CACHE_TTL = 5 * 60 * 1000

const clean = (value) =>
  value == null ? "" : String(value).trim()

function toBool(value) {
  if (typeof value === "boolean") return value

  return [
    "true",
    "1",
    "yes",
    "y",
    "on"
  ].includes(clean(value).toLowerCase())
}

function normalizeProduct(row) {
  return {
    ...row,
    id: clean(row.id),
    categoryId: clean(row.categoryId || row.category),
    name: clean(row.name || row.nameEn),
    tamil: clean(row.tamil || row.nameTa),
    description: clean(row.description || row.descriptionEn),
    tamilDescription: clean(
      row.tamilDescription || row.descriptionTa
    ),
    image: clean(row.image) || "/images/logo.jpg",
    subsidy: {
      ...(row.subsidy || {}),
      applicable: toBool(
        row.subsidyApplicable ??
        row.subsidy?.applicable
      )
    },
    featured: toBool(row.featured),
    active:
      row.active === "" || row.active == null
        ? true
        : toBool(row.active)
  }
}

function normalizeCategory(row) {
  return {
    ...row,
    id: clean(row.id),
    name: clean(row.name || row.nameEn),
    tamil: clean(row.tamil || row.nameTa),
    description: clean(
      row.description || row.descriptionEn
    ),
    tamilDescription: clean(
      row.tamilDescription || row.descriptionTa
    ),
    image: clean(row.image) || "/images/logo.jpg",
    active:
      row.active === "" || row.active == null
        ? true
        : toBool(row.active)
  }
}

function normalizeVideo(row) {
  return {
    ...row,
    id: clean(row.id),
    title: clean(row.title || row.titleEn),
    tamil: clean(row.tamil || row.titleTa),
    description: clean(
      row.description || row.descriptionEn
    ),
    tamilDescription: clean(
      row.tamilDescription || row.descriptionTa
    ),
    youtubeId: clean(
      row.youtubeId || row.youtube_id
    ),
    url: clean(row.url),
    active:
      row.active === "" || row.active == null
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
    name: clean(row.name) || company.name,
    address: clean(row.address) || company.address,
    phones: phones.length ? phones : company.phones,
    email: clean(row.email) || company.email,
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
  if (!data || typeof data !== "object") {
    throw new Error("Invalid Google Sheets response")
  }

  if (Array.isArray(data.categories)) {
    const rows = data.categories
      .map(normalizeCategory)
      .filter((item) => item.id && item.active)

    if (rows.length) {
      categories.splice(
        0,
        categories.length,
        ...rows
      )
    }
  }

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

  if (
    data.company &&
    typeof data.company === "object"
  ) {
    Object.assign(
      company,
      normalizeCompany(data.company)
    )
  }
}

function saveCache(data) {
  try {
    localStorage.setItem(
      CACHE_KEY,
      JSON.stringify({
        timestamp: Date.now(),
        data
      })
    )
  } catch {
    // Ignore storage errors.
  }
}

export function loadCachedData() {
  try {
    const raw = localStorage.getItem(CACHE_KEY)

    if (!raw) {
      return false
    }

    const cached = JSON.parse(raw)

    if (!cached?.data) {
      return false
    }

    applyRemoteData(cached.data)

    return true
  } catch {
    return false
  }
}

function isCacheFresh() {
  try {
    const raw = localStorage.getItem(CACHE_KEY)

    if (!raw) {
      return false
    }

    const cached = JSON.parse(raw)

    return (
      cached?.timestamp &&
      Date.now() - cached.timestamp < CACHE_TTL
    )
  } catch {
    return false
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

  const data = await response.json()

  applyRemoteData(data)
  saveCache(data)

  return { loaded: true }
}

export function startRemoteSync() {
  if (!GOOGLE_SHEET_API_URL) {
    return
  }

  // If we already have a fresh cache, don't wait for it.
  // A background refresh still keeps the content up to date.
  if (isCacheFresh()) {
    loadRemoteData()
      .then(() => {
        console.info(
          "Mother Soil Equipments: background refresh completed."
        )
      })
      .catch((error) => {
        console.warn(
          "Mother Soil Equipments: background refresh failed.",
          error
        )
      })

    return
  }

  loadRemoteData()
    .then(() => {
      console.info(
        "Mother Soil Equipments: remote data loaded."
      )
    })
    .catch((error) => {
      console.warn(
        "Mother Soil Equipments: Google Sheets unavailable. Using cached/local data.",
        error
      )
    })
}
