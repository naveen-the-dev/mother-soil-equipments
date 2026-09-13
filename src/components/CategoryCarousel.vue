<script setup>
import { computed, inject, onBeforeUnmount, onMounted, ref } from "vue"
import { categories } from "../data/categories"
import { products } from "../data/products"
import CategoryCard from "./CategoryCard.vue"
const { t } = inject("siteI18n")
const scroller = ref(null)
let timer
const cards = computed(() => categories.map(c => ({ ...c, count: products.filter(p => p.categoryId === c.id).length })))
function move(direction) { scroller.value?.scrollBy({ left: direction * 300, behavior: "smooth" }) }
onMounted(() => { timer = setInterval(() => { const el=scroller.value; if(!el)return; const max=el.scrollWidth-el.clientWidth; if(el.scrollLeft>=max-5)el.scrollTo({left:0,behavior:"smooth"});else el.scrollBy({left:300,behavior:"smooth"}) },4500) })
onBeforeUnmount(() => clearInterval(timer))
</script>
<template><section class="section"><div class="container"><div class="section-heading"><div><p class="eyebrow">MOTHER SOIL</p><h2>{{ t.categories.title }}</h2></div></div><div class="carousel-row"><button class="row-arrow" type="button" aria-label="Previous categories" @click="move(-1)">←</button><div ref="scroller" class="horizontal-scroll row-scroll"><CategoryCard v-for="category in cards" :key="category.id" :category="category" :count="category.count" /></div><button class="row-arrow" type="button" aria-label="Next categories" @click="move(1)">→</button></div></div></section></template>