<script setup>
import { computed, inject } from "vue"
import { RouterLink } from "vue-router"
import { categories } from "../data/categories"
import { company } from "../data/company"

const props = defineProps({ product: { type: Object, required: true } })
const { language, t } = inject("siteI18n")
const category = computed(() => categories.find((item) => item.id === props.product.categoryId))
const title = computed(() => language.value === "ta" ? props.product.tamil : props.product.name)
const description = computed(() => language.value === "ta" ? props.product.tamilDescription : props.product.description)
const whatsappUrl = computed(() => {
  const productName =
    language.value === "ta"
      ? props.product.tamil || props.product.name
      : props.product.name

  const message = `${t.value.messages.whatsappProduct} ${productName}.`

  return `https://wa.me/${company.whatsapp}?text=${encodeURIComponent(message)}`
})
</script>

<template>
  <article class="product-card">
    <RouterLink :to="`/products/${product.categoryId}/${product.id}`" class="product-image">
      <img :src="product.image" :alt="title" />
      <span v-if="product.subsidy?.applicable" class="badge">{{ t.subsidy.badge }}</span>
    </RouterLink>
    <div class="product-body">
      <small>{{ language === "ta" ? category?.tamil : category?.name }}</small>
      <h3>{{ title }}</h3>
      <p>{{ description }}</p>
      <div class="product-actions">
        <RouterLink :to="`/products/${product.categoryId}/${product.id}`" class="text-link">{{ t.products.details }} {{ t.common.arrow }}</RouterLink>
        <a class="whatsapp-mini" :href="whatsappUrl" target="_blank" rel="noopener noreferrer">{{ t.common.whatsapp }}</a>
      </div>
    </div>
  </article>
</template>