<script setup>
import { inject, ref } from "vue"
import { RouterLink, useRoute } from "vue-router"

const { language, t, toggleLanguage } = inject("siteI18n")
const route = useRoute()
const open = ref(false)

const navItems = [
  { key: "home", to: "/" },
  { key: "products", to: "/products" },
  { key: "subsidy", to: "/subsidy" },
  { key: "about", to: "/about" },
  { key: "contact", to: "/contact" },
]

function closeMenu() { open.value = false }
function isActive(to) { return to === "/" ? route.path === "/" : route.path.startsWith(to) }
</script>

<template>
  <header class="site-header">
    <div class="container nav-wrap">
      <RouterLink to="/" class="brand" @click="closeMenu">
        <img src="/images/logo.jpg" alt="Mother Soil Equipments" class="brand-logo" />
        <span class="brand-name">Mother Soil<br /><small>Equipments</small></span>
      </RouterLink>

      <button class="menu-toggle" type="button" :aria-label="t.nav.menu" @click="open = !open">
        <span></span><span></span><span></span>
      </button>

      <nav class="main-nav" :class="{ open }">
        <RouterLink v-for="item in navItems" :key="item.key" :to="item.to"
          :class="{ active: isActive(item.to) }" @click="closeMenu">
          {{ t.nav[item.key] }}
        </RouterLink>
        <!-- <button class="language-switch" type="button" @click="toggleLanguage(); closeMenu()">
          {{ language === "en" ? t.nav.language : "EN" }}
        </button> -->
      </nav>
    </div>
  </header>
</template>