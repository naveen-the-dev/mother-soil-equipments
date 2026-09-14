<script setup>
import { inject, onBeforeUnmount, onMounted, ref } from "vue"
import { videos } from "../data/videos"
const { language, t } = inject("siteI18n")
const scroller=ref(null); let timer
function move(direction){scroller.value?.scrollBy({left:direction*330,behavior:"smooth"})}
function openVideo(v){if(v.url)window.open(v.url,"_blank","noopener,noreferrer")}
onMounted(()=>{timer=setInterval(()=>{const el=scroller.value;if(!el)return;const max=el.scrollWidth-el.clientWidth;if(el.scrollLeft>=max-5)el.scrollTo({left:0,behavior:"smooth"});else el.scrollBy({left:330,behavior:"smooth"})},5000)})
onBeforeUnmount(()=>clearInterval(timer))
</script>
<template><section class="section section-muted"><div class="container"><div class="section-heading"><div><p class="eyebrow">{{ t.videos.eyebrow }}</p><h2>{{ t.videos.title }}</h2><p>{{ t.videos.text }}</p></div></div><div class="carousel-row"><button class="row-arrow" type="button" :aria-label="t.videos.previous" @click="move(-1)">←</button><div ref="scroller" class="horizontal-scroll row-scroll video-scroll"><article v-for="video in videos" :key="video.id" class="video-card clickable" @click="openVideo(video)"><div class="video-thumb youtube-thumb"><img :src="`https://img.youtube.com/vi/${video.youtubeId}/hqdefault.jpg`" :alt="language==='ta'?video.tamil:video.title" loading="lazy"><div class="video-thumb-overlay"></div><div class="play-button">▶</div><span class="youtube-label">YouTube</span></div><div class="video-content"><h3>{{ language==="ta"?video.tamil:video.title }}</h3><p>{{ language==="ta"?video.tamilDescription:video.description }}</p><span>{{ t.videos.watch }} →</span></div></article></div><button class="row-arrow" type="button" :aria-label="t.videos.next" @click="move(1)">→</button></div></div></section></template>