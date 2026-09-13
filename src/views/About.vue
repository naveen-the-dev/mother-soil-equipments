<script setup>
import { inject } from "vue"
import { company } from "../data/company"
const { t } = inject("siteI18n")
</script>
<template>
  <section class="section"><div class="container split-section">
    <div><p class="eyebrow">MOTHER SOIL EQUIPMENTS</p><h1>{{ t.about.title }}</h1><p class="lead">{{ t.about.text }}</p><p>Our website is designed as a simple product catalogue so farmers can browse equipment categories, understand product information and contact us for enquiries.</p></div>
    <div class="info-card"><h3>{{ company.name }}</h3><p>{{ company.address }}</p><a :href="`tel:${company.phones[0].replace(/\s/g, '')}`">{{ company.phones[0] }}</a><a :href="`tel:${company.phones[1].replace(/\s/g, '')}`">{{ company.phones[1] }}</a><a :href="`mailto:${company.email}`">{{ company.email }}</a></div>
  </div></section>
</template>