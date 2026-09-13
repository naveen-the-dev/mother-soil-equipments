import { createRouter, createWebHistory } from "vue-router"
import Home from "../views/Home.vue"
import Products from "../views/Products.vue"
import ProductDetails from "../views/ProductDetails.vue"
import Subsidy from "../views/Subsidy.vue"
import About from "../views/About.vue"
import Contact from "../views/Contact.vue"

export default createRouter({
  history: createWebHistory(),
  scrollBehavior() { return { top: 0 } },
  routes: [
    { path: "/", name: "home", component: Home },
    { path: "/products", name: "products", component: Products },
    { path: "/products/category/:categoryId", name: "category", component: Products },
    { path: "/products/:categoryId/:productId", name: "product-details", component: ProductDetails },
    { path: "/subsidy", name: "subsidy", component: Subsidy },
    { path: "/about", name: "about", component: About },
    { path: "/contact", name: "contact", component: Contact },
  ],
})