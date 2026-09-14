<script setup>
import { computed, provide, ref, watch } from "vue"
import { RouterView } from "vue-router"
import Navbar from "./components/Navbar.vue"
import SiteFooter from "./components/SiteFooter.vue"
import en from "./locales/en"
import ta from "./locales/ta"

const language = ref( "en")
// const language = ref(localStorage.getItem("mse-language") || "en")
const dictionaries = { en, ta }
const t = computed(() => dictionaries[language.value] || en)

watch(language, (value) => {
  localStorage.setItem("mse-language", value)
  document.documentElement.lang = value === "ta" ? "ta" : "en"
}, { immediate: true })

function toggleLanguage() {
  language.value = language.value === "en" ? "ta" : "en"
}

provide("siteI18n", { language, t, toggleLanguage })
</script>

<template>
  <div class="app-shell">
    <Navbar />
    <main><RouterView /></main>
    <SiteFooter />
  </div>
</template>