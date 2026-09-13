<script setup>
import { computed, inject } from "vue"
import { RouterLink } from "vue-router"

const props = defineProps({
  category: { type: Object, required: true },
  count: { type: Number, default: 0 },
})
const { language, t } = inject("siteI18n")
const title = computed(() => language.value === "ta" ? props.category.tamil : props.category.name)
const description = computed(() => language.value === "ta" ? props.category.tamil : props.category.description)
</script>

<template>
  <RouterLink :to="`/products/category/${category.id}`" class="category-card">
    <div class="category-image">
      <img :src="category.image || '/images/logo.jpg'" :alt="title" />
      <span class="category-icon">{{ category.icon }}</span>
      <span class="category-count">{{ count }} {{ t.products.results }}</span>
    </div>
    <div class="category-card-content">
      <h3>{{ title }}</h3>
      <p>{{ description }}</p>
      <span class="category-link">{{ t.categories.view }} <b>→</b></span>
    </div>
  </RouterLink>
</template>