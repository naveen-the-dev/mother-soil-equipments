import { createApp } from "vue"
import App from "./App.vue"
import router from "./router"
import "./assets/styles/main.css"
import {
  loadCachedData,
  startRemoteSync
} from "./services/googleSheet"

const app = createApp(App)

// Apply cached Google Sheets data BEFORE mounting.
// This makes repeat visits effectively instant.
loadCachedData()

app.use(router)
app.mount("#app")

// Google Sheets refresh happens AFTER the UI is visible.
startRemoteSync()
