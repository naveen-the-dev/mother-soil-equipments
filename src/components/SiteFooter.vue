<script setup>
import { inject } from "vue"
import { RouterLink } from "vue-router"
import { categories } from "../data/categories"
import { company } from "../data/company"

const { t, language } = inject("siteI18n")
</script>

<template>
  <footer class="site-footer">
    <div class="container footer-grid">
      <div class="footer-brand">
        <RouterLink to="/" class="brand footer-brand-link">
          <img src="/images/logo.jpg" alt="Mother Soil Equipments" class="brand-logo" />
          <span class="brand-name">Mother Soil<br /><small>Equipments</small></span>
        </RouterLink>
        <p>Practical agricultural equipment for farmers and professional use.</p>

        <h4>{{ t.footer.follow }}</h4>
        <div class="socials footer-socials">
          <a :href="company.social.facebook" target="_blank" rel="noopener noreferrer" aria-label="Facebook">
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M14 8h3V4h-3c-3.3 0-5 1.8-5 5v3H6v4h3v4h4v-4h3.2l.8-4H13V9c0-.7.3-1 1-1Z" fill="currentColor"/></svg>
            <span>Facebook</span>
          </a>
          <a :href="company.social.instagram" target="_blank" rel="noopener noreferrer" aria-label="Instagram">
            <svg viewBox="0 0 24 24" aria-hidden="true"><rect x="4" y="4" width="16" height="16" rx="4" fill="none" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="4" fill="none" stroke="currentColor" stroke-width="2"/><circle cx="17.3" cy="6.8" r="1.1" fill="currentColor"/></svg>
            <span>Instagram</span>
          </a>
          <a :href="company.social.youtube" target="_blank" rel="noopener noreferrer" aria-label="YouTube">
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M21 8.2a3 3 0 0 0-2.1-2.1C17 5.6 12 5.6 12 5.6s-5 0-6.9.5A3 3 0 0 0 3 8.2 31 31 0 0 0 2.6 12 31 31 0 0 0 3 15.8a3 3 0 0 0 2.1 2.1c1.9.5 6.9.5 6.9.5s5 0 6.9-.5a3 3 0 0 0 2.1-2.1 31 31 0 0 0 .4-3.8 31 31 0 0 0-.4-3.8Z" fill="currentColor"/><path d="m10 9 5 3-5 3V9Z" fill="#102b19"/></svg>
            <span>YouTube</span>
          </a>
        </div>
      </div>

      <div>
        <h4>{{ t.footer.quickLinks }}</h4>
        <div class="footer-links">
          <RouterLink to="/">{{ t.nav.home }}</RouterLink>
          <RouterLink to="/products">{{ t.nav.products }}</RouterLink>
          <RouterLink to="/subsidy">{{ t.nav.subsidy }}</RouterLink>
          <RouterLink to="/about">{{ t.nav.about }}</RouterLink>
          <RouterLink to="/contact">{{ t.nav.contact }}</RouterLink>
        </div>
      </div>

      <div>
        <h4>{{ t.footer.categories }}</h4>
        <div class="footer-links">
          <RouterLink v-for="category in categories" :key="category.id" :to="`/products/category/${category.id}`">
            {{ language === "ta" ? category.tamil : category.name }}
          </RouterLink>
        </div>
      </div>

      <div class="footer-contact">
        <h4>{{ t.nav.contact }}</h4>
        <p class="footer-address">{{ company.address }}</p>
        <div class="footer-contact-links">
          <a :href="`tel:${company.phones[0].replace(/\s/g, '')}`">{{ company.phones[0] }}</a>
          <a :href="`tel:${company.phones[1].replace(/\s/g, '')}`">{{ company.phones[1] }}</a>
          <a :href="`mailto:${company.email}`">{{ company.email }}</a>
        </div>
      </div>
    </div>

    <div class="footer-bottom">
      <div class="container">© {{ new Date().getFullYear() }} {{ company.name }}. {{ t.footer.rights }}</div>
    </div>
  </footer>
</template>
