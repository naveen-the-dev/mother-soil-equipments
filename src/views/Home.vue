<script setup>
import { computed, inject, ref } from "vue"
import { RouterLink } from "vue-router"
import CategoryCarousel from "../components/CategoryCarousel.vue"
import ProductCard from "../components/ProductCard.vue"
import VideoCarousel from "../components/VideoCarousel.vue"
import { products } from "../data/products"
import { company } from "../data/company"

const { t } = inject("siteI18n")
const openFaq = ref(0)
const subsidyScroller = ref(null)
const subsidyProducts = computed(() => products.filter((product) => product.subsidy?.applicable).slice(0, 6))
const whatsapp = computed(() => `https://wa.me/${company.whatsapp}?text=${encodeURIComponent("Hello Mother Soil Equipments, I would like to enquire about agricultural equipment.")}`)
function toggleFaq(index) { openFaq.value = openFaq.value === index ? -1 : index }
function moveSubsidy(direction) { subsidyScroller.value?.scrollBy({ left: direction * 285, behavior: "smooth" }) }
</script>

<template>
  <div>
    <section class="hero">
      <div class="hero-overlay"></div>
      <div class="container hero-grid">
        <div class="hero-copy">
          <p class="eyebrow">{{ t.hero.eyebrow }}</p><h1>{{ t.hero.title }}</h1><p class="hero-text">{{ t.hero.text }}</p>
          <div class="hero-actions"><RouterLink to="/products" class="btn btn-primary">{{ t.hero.products }}</RouterLink><RouterLink to="/contact" class="btn btn-secondary">{{ t.hero.contact }}</RouterLink></div>
        </div>
        <div class="hero-video"><video src="/videos/hero-video.mp4" poster="/images/hero-bg.jpg" autoplay muted loop playsinline controls preload="metadata"></video><div class="hero-video-caption">Agricultural Equipment</div></div>
      </div>
    </section>

    <CategoryCarousel />
    <VideoCarousel />

    <section class="section subsidy-home">
      <div class="container">
        <div class="subsidy-banner">
          <div><p class="eyebrow">{{ t.subsidy.badge }}</p><h2>{{ t.subsidy.title }}</h2><p>{{ t.subsidy.text }}</p><small>{{ t.subsidy.note }}</small></div>
          <RouterLink to="/subsidy" class="btn btn-primary">{{ t.subsidy.details }}</RouterLink>
        </div>
        <div v-if="subsidyProducts.length" class="subsidy-row-wrap">
          <button class="row-arrow" type="button" aria-label="Previous subsidy products" @click="moveSubsidy(-1)">←</button>
          <div ref="subsidyScroller" class="horizontal-scroll row-scroll subsidy-scroll">
            <ProductCard v-for="product in subsidyProducts" :key="product.id" :product="product" />
          </div>
          <button class="row-arrow" type="button" aria-label="Next subsidy products" @click="moveSubsidy(1)">→</button>
        </div>
        <div v-else class="empty-panel"><p>No subsidy-supported products have been published yet.</p><RouterLink to="/subsidy" class="text-link">{{ t.subsidy.view }} →</RouterLink></div>
      </div>
    </section>

    <section class="section"><div class="container">
      <div class="section-heading centered"><p class="eyebrow">OUR PROMISE</p><h2>{{ t.why.title }}</h2></div>
      <div class="why-grid">
        <div class="why-card"><span>✓</span><h3>{{ t.why.quality }}</h3><p>Practical equipment selected for agricultural requirements.</p></div>
        <div class="why-card"><span>▦</span><h3>{{ t.why.range }}</h3><p>Multiple categories for different farm and field needs.</p></div>
        <div class="why-card"><span>?</span><h3>{{ t.why.guidance }}</h3><p>Get help understanding products before you enquire.</p></div>
        <div class="why-card"><span>☎</span><h3>{{ t.why.support }}</h3><p>Reach our team through phone, email or WhatsApp.</p></div>
      </div>
    </div></section>

    <section class="section section-muted"><div class="container split-section"><div><p class="eyebrow">ABOUT US</p><h2>{{ t.about.title }}</h2><p>{{ t.about.text }}</p><RouterLink to="/about" class="text-link">{{ t.about.more }} →</RouterLink></div><div class="info-card"><strong>Mother Soil Equipments</strong><p>{{ company.address }}</p><a :href="`tel:${company.phones[0].replace(/\s/g, '')}`">{{ company.phones[0] }}</a><a :href="`mailto:${company.email}`">{{ company.email }}</a></div></div></section>

    <section class="section"><div class="container narrow"><div class="section-heading centered"><p class="eyebrow">FAQ</p><h2>{{ t.faq.title }}</h2></div><div class="faq-list">
      <div v-for="(item, index) in [[t.faq.q1,t.faq.a1],[t.faq.q2,t.faq.a2],[t.faq.q3,t.faq.a3],[t.faq.q4,t.faq.a4]]" :key="index" class="faq-item"><button type="button" @click="toggleFaq(index)"><span>{{ item[0] }}</span><b>{{ openFaq === index ? "−" : "+" }}</b></button><p v-if="openFaq === index">{{ item[1] }}</p></div>
    </div></div></section>

    <section class="cta-section"><div class="container cta-inner"><div><p class="eyebrow">LET'S TALK</p><h2>{{ t.contact.title }}</h2><p>{{ t.contact.text }}</p></div><div class="cta-actions"><a class="btn btn-primary" :href="whatsapp" target="_blank" rel="noopener">{{ t.contact.whatsapp }}</a><RouterLink to="/contact" class="btn btn-light">{{ t.nav.contact }}</RouterLink></div></div></section>
  </div>
</template>