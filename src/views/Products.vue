<script setup>
import { computed, inject, ref } from "vue"
import { useRoute, useRouter } from "vue-router"
import { categories } from "../data/categories"
import { products } from "../data/products"
import ProductCard from "../components/ProductCard.vue"

const { language, t } = inject("siteI18n")
const route = useRoute()
const router = useRouter()
const search = ref("")

const selectedId = computed(() => route.params.categoryId || null)
const selectedCategory = computed(() => categories.find(c => c.id === selectedId.value))

const filteredProducts = computed(() => {
  const q = search.value.trim().toLowerCase()
  return products.filter(p => {
    const categoryMatch = !selectedId.value || p.categoryId === selectedId.value
    const haystack = [p.name, p.tamil, p.description, p.tamilDescription].join(" ").toLowerCase()
    return categoryMatch && (!q || haystack.includes(q))
  })
})

function selectCategory(id) {
  router.push(id ? `/products/category/${id}` : "/products")
}
</script>

<template>
  <div>
    <section class="page-hero compact-page-hero products-compact-hero">
      <div class="container">
        <p class="eyebrow">MOTHER SOIL EQUIPMENTS</p>
        <h1>{{ t.products.title }}</h1>
        <p>{{ t.products.subtitle }}</p>
      </div>
    </section>

    <section class="section products-page">
      <div class="container">
        <div class="search-row compact-search">
          <input v-model="search" type="search" :placeholder="t.products.search" />
          <button v-if="search" type="button" class="clear-btn" @click="search = ''">{{ t.products.clear }}</button>
        </div>

        <div class="category-selector compact-category-selector" role="tablist">
          <button type="button" :class="{ selected: !selectedId }" @click="selectCategory(null)">
            {{ t.products.all }}
          </button>
          <button
            v-for="category in categories"
            :key="category.id"
            type="button"
            :class="{ selected: category.id === selectedId }"
            @click="selectCategory(category.id)"
          >
            <span>{{ category.icon }}</span>{{ language === "ta" ? category.tamil : category.name }}
          </button>
        </div>

        <div class="selected-heading compact-selected-heading">
          <div>
            <p class="eyebrow">{{ selectedCategory ? (language === "ta" ? selectedCategory.tamil : selectedCategory.name) : t.products.all }}</p>
            <h2>{{ filteredProducts.length }} {{ t.products.results }}</h2>
          </div>
        </div>

        <div v-if="filteredProducts.length" class="product-grid product-grid-wide">
          <ProductCard v-for="product in filteredProducts" :key="`${product.categoryId}-${product.id}`" :product="product" />
        </div>

        <div v-else class="empty-panel">
          <h3>{{ t.products.noResults }}</h3>
          <button type="button" class="btn btn-primary" @click="search = ''; selectCategory(null)">{{ t.products.clear }}</button>
        </div>
      </div>
    </section>
  </div>
</template>
