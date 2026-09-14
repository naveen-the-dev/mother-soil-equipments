import { reactive } from "vue"

const initialCompany = {
  name: "Mother Soil Equipments",
  address: "780/141 G1, P. Vangali Complex, Salem Road, Namakkal - 637 001, Tamil Nadu",
  phones: ["+91 88388 94126", "+91 95858 70654"],
  email: "mothersoilnkl@gmail.com",
  whatsapp: "918838894126",
  social: {
    facebook: "https://facebook.com",
    instagram: "https://instagram.com",
    youtube: "https://youtube.com",
  },
}

export const company = reactive(initialCompany)
