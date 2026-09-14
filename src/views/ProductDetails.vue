<script setup>
import { computed, inject } from "vue"
import { RouterLink, useRoute } from "vue-router"
import { categories } from "../data/categories"
import { products } from "../data/products"
import { company } from "../data/company"
import ProductCard from "../components/ProductCard.vue"

const { language, t } = inject("siteI18n")
const route = useRoute()
const product = computed(() => products.find((item) => item.id === route.params.productId))
const category = computed(() => categories.find((item) => item.id === route.params.categoryId))
const title = computed(() => product.value ? (language.value === "ta" ? product.value.tamil : product.value.name) : "")
const description = computed(() => product.value ? (language.value === "ta" ? product.value.tamilDescription : product.value.description) : "")
const related = computed(() => products.filter((item) => item.categoryId === route.params.categoryId && item.id !== route.params.productId))
const whatsappUrl = computed(() => product.value ? `https://wa.me/${company.whatsapp}?text=${encodeURIComponent(`Hello Mother Soil Equipments, I am interested in ${product.value.name}.`)}` : "#")
</script>

<template>
  <div v-if="product" class="section product-details">
    <div class="container">
      <div class="breadcrumbs"><RouterLink to="/">{{ t.nav.home }}</RouterLink> / <RouterLink to="/products">{{ t.nav.products }}</RouterLink> / <RouterLink :to="`/products/category/${product.categoryId}`">{{ language === "ta" ? category?.tamil : category?.name }}</RouterLink> / <span>{{ title }}</span></div>
      <div class="detail-grid">
        <div class="detail-image"><img :src="product.image" :alt="title" /></div>
        <div class="detail-copy">
          <span class="pill">{{ language === "ta" ? category?.tamil : category?.name }}</span>
          <span v-if="product.subsidy?.applicable" class="pill subsidy-pill">{{ t.subsidy.badge }}</span>
          <h1>{{ title }}</h1><p>{{ description }}</p>
          <p class="contact-note">{{ t.messages.productContact }}</p>
          <div class="hero-actions"><a class="btn btn-primary" :href="whatsappUrl" target="_blank" rel="noopener">{{ t.products.enquire }} · {{ t.common.whatsapp }}</a><RouterLink to="/contact" class="btn btn-secondary">{{ t.nav.contact }}</RouterLink></div>
        </div>
      </div>
      <div v-if="related.length" class="related-section"><div class="section-heading"><h2>{{ t.products.related }}</h2></div><div class="product-grid"><ProductCard v-for="item in related" :key="item.id" :product="item" /></div></div>
    </div>
  </div>
  <div v-else class="section"><div class="container empty-panel"><h2>{{ t.products.noResults }}</h2><RouterLink to="/products" class="btn btn-primary">{{ t.products.viewAll }}</RouterLink></div></div>
</template>