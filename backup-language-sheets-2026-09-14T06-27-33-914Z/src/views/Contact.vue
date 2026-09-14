<script setup>
import { computed, inject, ref } from "vue"
import { company } from "../data/company"

const { t } = inject("siteI18n")
const form = ref({ name: "", phone: "", message: "" })
const sent = ref(false)

const whatsappUrl = computed(() => {
  const message = `Hello Mother Soil Equipments,
Name: ${form.value.name || "-"}
Phone: ${form.value.phone || "-"}
Message: ${form.value.message || "-"}`
  return `https://wa.me/${company.whatsapp}?text=${encodeURIComponent(message)}`
})

function submit() {
  sent.value = true
  window.open(whatsappUrl.value, "_blank", "noopener,noreferrer")
}
</script>

<template>
  <div>
    <section class="page-hero compact-page-hero contact-compact-hero">
      <div class="container">
        <p class="eyebrow">MOTHER SOIL EQUIPMENTS</p>
        <h1>{{ t.nav.contact }}</h1>
        <p>{{ t.contact.text }}</p>
      </div>
    </section>

    <section class="section contact-page-section">
      <div class="container contact-grid contact-grid-compact">
        <div>
          <p class="eyebrow">MOTHER SOIL EQUIPMENTS</p>
          <h2>{{ t.contact.title }}</h2>

          <div class="contact-list contact-list-compact">
            <a :href="`tel:${company.phones[0].replace(/\s/g, '')}`">
              <strong>{{ t.contact.call }}</strong>
              <span>{{ company.phones[0] }}</span>
            </a>
            <a :href="`tel:${company.phones[1].replace(/\s/g, '')}`">
              <strong>{{ t.contact.call }}</strong>
              <span>{{ company.phones[1] }}</span>
            </a>
            <a :href="`mailto:${company.email}`">
              <strong>{{ t.contact.email }}</strong>
              <span>{{ company.email }}</span>
            </a>
            <div>
              <strong>Address</strong>
              <span>{{ company.address }}</span>
            </div>
          </div>
        </div>

        <form class="contact-form contact-form-compact" @submit.prevent="submit">
          <h2>{{ t.contact.formTitle }}</h2>
          <label>
            {{ t.contact.name }}
            <input v-model="form.name" required />
          </label>
          <label>
            {{ t.contact.phone }}
            <input v-model="form.phone" required />
          </label>
          <label>
            {{ t.contact.message }}
            <textarea v-model="form.message" rows="3" required></textarea>
          </label>
          <button class="btn btn-primary" type="submit">{{ t.contact.send }}</button>
          <p v-if="sent" class="success-message">{{ t.contact.success }}</p>
        </form>
      </div>
    </section>
  </div>
</template>
