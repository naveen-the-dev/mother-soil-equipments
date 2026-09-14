<script setup>
import { computed, inject, ref } from "vue"
import { categories } from "../data/categories"
import { subsidyProducts } from "../data/products"
import ProductCard from "../components/ProductCard.vue"
import { company } from "../data/company"

const { language, t } = inject("siteI18n")
const selected = ref("all")
const filtered = computed(() =>
  selected.value === "all"
    ? subsidyProducts
    : subsidyProducts.filter(product => product.categoryId === selected.value)
)
const whatsapp = computed(() =>
  `https://wa.me/${company.whatsapp}?text=${encodeURIComponent("Hello Mother Soil Equipments, I would like to enquire about subsidy-supported agricultural machinery.")}`
)
</script>

<template>
  <div>
    <section class="page-hero compact-page-hero products-compact-hero subsidy-compact-hero">
      <div class="container">
        <p class="eyebrow">{{ t.subsidy.badge }}</p>
        <h1>{{ t.subsidy.title }}</h1>
        <p>{{ t.subsidy.text }}</p>
      </div>
    </section>

    <section class="section subsidy-page">
      <div class="container">
        <div class="subsidy-info compact-subsidy-info">
          <div>
            <h2>{{ t.subsidy.details }}</h2>
            <p>{{ t.subsidy.note }}</p>
            <p>{{ t.subsidy.disclaimer }}</p>
          </div>
          <a class="btn btn-primary" :href="whatsapp" target="_blank" rel="noopener">{{ t.subsidy.enquiry }}</a>
        </div>

        <div class="category-selector subsidy-filter compact-category-selector">
          <button type="button" :class="{ selected: selected === 'all' }" @click="selected = 'all'">{{ t.products.all }}</button>
          <button
            v-for="category in categories"
            :key="category.id"
            type="button"
            :class="{ selected: selected === category.id }"
            @click="selected = category.id"
          >
            {{ language === "ta" ? category.tamil : category.name }}
          </button>
        </div>

        <div v-if="filtered.length" class="product-grid product-grid-wide">
          <ProductCard v-for="product in filtered" :key="`${product.categoryId}-${product.id}`" :product="product" />
        </div>

        <div v-else class="empty-panel">
          <h3>{{ t.subsidy.emptyTitle }}</h3>
          <p>{{ t.subsidy.emptyText }}</p>
        </div>
      </div>
    </section>
  </div>
</template>
