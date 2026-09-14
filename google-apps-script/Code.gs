const SHEETS = {
  Products: "Products",
  Categories: "Categories",
  Videos: "Videos",
  Company: "Company"
}

function doGet() {
  return ContentService
    .createTextOutput(
      JSON.stringify({
        products: readSheet(SHEETS.Products),
        categories: readSheet(SHEETS.Categories),
        videos: readSheet(SHEETS.Videos),
        company: readSheet(SHEETS.Company)[0] || {}
      })
    )
    .setMimeType(ContentService.MimeType.JSON)
}

function readSheet(name) {
  const sheet =
    SpreadsheetApp
      .getActiveSpreadsheet()
      .getSheetByName(name)

  if (!sheet) return []

  const values =
    sheet
      .getDataRange()
      .getDisplayValues()

  if (values.length < 2) return []

  const headers =
    values[0].map(normalizeHeader)

  return values
    .slice(1)
    .filter((row) =>
      row.some(
        (cell) =>
          String(cell).trim() !== ""
      )
    )
    .map((row) => {
      const item = {}

      headers.forEach(
        (header, index) => {
          if (header) {
            item[header] =
              row[index] || ""
          }
        }
      )

      return item
    })
}

function normalizeHeader(value) {
  const raw =
    String(value)
      .trim()
      .replace(/s+/g, "")

  const key =
    raw
      .replace(/[-_]/g, "")
      .toLowerCase()

  const aliases = {
    nameen: "nameEn",
    nameta: "nameTa",
    descriptionen: "descriptionEn",
    descriptionta: "descriptionTa",
    tamildescription: "tamilDescription",
    categoryid: "categoryId",
    youtubeid: "youtubeId",
    subsidyapplicable: "subsidyApplicable",
    phone1: "phone1",
    phone2: "phone2"
  }

  return aliases[key] || raw
}
