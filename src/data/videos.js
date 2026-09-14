import { reactive } from "vue"

const initialVideos = [
  {
    id: "youtube-1",
    title: "Agricultural Equipment Demo",
    tamil: "à®µà®¿à®µà®šà®¾à®¯ à®‰à®ªà®•à®°à®£à®™à¯à®•à®³à¯ à®šà¯†à®¯à®²à¯à®µà®¿à®³à®•à¯à®•à®®à¯",
    description: "Watch an agricultural equipment demonstration.",
    tamilDescription: "à®µà®¿à®µà®šà®¾à®¯ à®‰à®ªà®•à®°à®£à®™à¯à®•à®³à®¿à®©à¯ à®šà¯†à®¯à®²à¯à®µà®¿à®³à®•à¯à®•à®¤à¯à®¤à¯ˆà®ªà¯ à®ªà®¾à®°à¯à®™à¯à®•à®³à¯",
    youtubeId: "DveckJ42NP8",
    url: "https://youtu.be/DveckJ42NP8",
  },
  {
    id: "youtube-2",
    title: "Agricultural Machinery",
    tamil: "à®µà®¿à®µà®šà®¾à®¯ à®‡à®¯à®¨à¯à®¤à®¿à®°à®™à¯à®•à®³à¯",
    description: "Explore agricultural machinery in action.",
    tamilDescription: "à®µà®¿à®µà®šà®¾à®¯ à®‡à®¯à®¨à¯à®¤à®¿à®°à®™à¯à®•à®³à¯ à®šà¯†à®¯à®²à¯à®ªà®Ÿà¯à®®à¯ à®µà®¿à®¤à®¤à¯à®¤à¯ˆà®ªà¯ à®ªà®¾à®°à¯à®™à¯à®•à®³à¯",
    youtubeId: "NVhGuiXh4uo",
    url: "https://youtu.be/NVhGuiXh4uo",
  },
  {
    id: "youtube-3",
    title: "Farm Equipment",
    tamil: "à®µà®¿à®µà®šà®¾à®¯ à®‰à®ªà®•à®°à®£à®™à¯à®•à®³à¯",
    description: "See practical equipment used for farm work.",
    tamilDescription: "à®µà®¿à®µà®šà®¾à®¯ à®ªà®£à®¿à®•à®³à®¿à®²à¯ à®ªà®¯à®©à¯à®ªà®Ÿà¯à®¤à¯à®¤à®ªà¯à®ªà®Ÿà¯à®®à¯ à®¨à®Ÿà¯ˆà®®à¯à®±à¯ˆ à®‰à®ªà®•à®°à®£à®™à¯ˆà®ªà¯ à®ªà®¾à®°à¯à®™à¯à®•à®³à¯",
    youtubeId: "Ii4CmwnMi8o",
    url: "https://youtu.be/Ii4CmwnMi8o",
  },
  {
    id: "youtube-4",
    title: "Agricultural Machinery Demo",
    tamil: "à®µà®¿à®µà®šà®¾à®¯ à®‡à®¯à®¨à¯à®¤à®¿à®° à®šà¯†à®¯à®²à¯à®µà®¿à®³à®•à¯à®•à®®à¯",
    description: "Watch another agricultural machinery demonstration.",
    tamilDescription: "à®®à®±à¯à®±à¯Šà®°à¯ à®µà®¿à®µà®šà®¾à®¯ à®‡à®¯à®¨à¯à®¤à®¿à®° à®šà¯†à®¯à®²à¯à®µà®¿à®³à®•à¯à®•à®¤à¯à®¤à¯ˆà®ªà¯ à®ªà®¾à®°à¯à®™à¯à®•à®³à¯",
    youtubeId: "LkmRBgGMPu8",
    url: "https://youtu.be/LkmRBgGMPu8",
  },
]

export const videos = reactive(initialVideos)
