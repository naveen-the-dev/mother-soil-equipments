import { reactive } from "vue"

const initialCategories = [
  {
    id: "sprayers",
    name: "Sprayers",
    tamil: "à®¤à¯†à®³à®¿à®ªà¯à®ªà®¾à®©à¯à®•à®³à¯",
    description: "Practical spraying equipment for agricultural applications.",
    icon: "ðŸ’§",
    image: "/images/battery sprayer.png",
  },
  {
    id: "brush-cutters",
    name: "Brush Cutters",
    tamil: "à®ªà¯à®²à¯ à®µà¯†à®Ÿà¯à®Ÿà¯à®®à¯ à®‡à®¯à®¨à¯à®¤à®¿à®°à®™à¯à®•à®³à¯",
    description: "Equipment for grass, weeds and vegetation cutting.",
    icon: "ðŸŒ¿",
    image: "/images/brush cutter.png",
  },
  {
    id: "weeders",
    name: "Weeders",
    tamil: "à®•à®³à¯ˆ à®Žà®Ÿà¯à®•à¯à®•à¯®à¯ à®‡à®¯à®¨à¯à®¤à®¿à®°à®™à¯à®•à®³à¯",
    description: "Useful equipment for weed management and field work.",
    icon: "ðŸŒ±",
    image: "/images/Power weeder.png",
  },
  {
    id: "milking-machines",
    name: "Milking Machines",
    tamil: "à®ªà®µà®°à¯ à®•à®°à¯à®µà®¿à®•à®³à¯",
    description: "Milking machines for agricultural and general work.",
    icon: "âš™ï¸",
    image: "/images/Milking Machine.png",
  },
  {
    id: "accessories",
    name: "Accessories",
    tamil: "à®¤à¯à®£à¯ˆà®•à¯à®•à®°à¯à®µà®¿à®•à®³à¯",
    description: "Useful accessories and supporting equipment.",
    icon: "ðŸ”§",
    image: "/images/logo.jpg",
  },
  {
    id: "other-equipment",
    name: "Other Equipment",
    tamil: "à®ªà®¿à®± à®‰à®ªà®•à®°à®£à®™à¯à®•à®³à¯",
    description: "Other agricultural equipment for different requirements.",
    icon: "ðŸšœ",
    image: "/images/logo.jpg",
  },
]

export const categories = reactive(initialCategories)
