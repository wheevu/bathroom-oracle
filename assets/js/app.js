// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/bathroom_oracle"
import topbar from "../vendor/topbar"

const ComposerMeasure = {
  mounted() {
    this.measure = () => {
      document.documentElement.style.setProperty("--composer-height", `${this.el.offsetHeight}px`)
    }

    this.measure()
    this.resizeObserver = new ResizeObserver(() => this.measure())
    this.resizeObserver.observe(this.el)
  },

  updated() {
    this.measure()
  },

  destroyed() {
    this.resizeObserver?.disconnect()
  }
}

const RotatingPlaceholder = {
  mounted() {
    this.placeholders = JSON.parse(this.el.dataset.placeholderValues || "[]")
    this.index = 0

    if (this.placeholders.length === 0) return

    this.syncPlaceholder = () => {
      if (document.activeElement === this.el) return
      if (this.el.value.trim() !== "") return

      this.el.setAttribute("placeholder", this.placeholders[this.index])
    }

    this.advance = () => {
      if (document.activeElement === this.el) return
      if (this.el.value.trim() !== "") return

      this.index = (this.index + 1) % this.placeholders.length
      this.syncPlaceholder()
    }

    this.handleFocus = () => {
      this.el.setAttribute("placeholder", "")
    }

    this.handleBlur = () => {
      this.syncPlaceholder()
    }

    this.handleInput = () => {
      if (this.el.value.trim() === "") this.syncPlaceholder()
    }

    this.syncPlaceholder()
    this.interval = window.setInterval(this.advance, 2600)
    this.el.addEventListener("focus", this.handleFocus)
    this.el.addEventListener("blur", this.handleBlur)
    this.el.addEventListener("input", this.handleInput)
  },

  updated() {
    this.syncPlaceholder?.()
  },

  destroyed() {
    window.clearInterval(this.interval)
    this.el.removeEventListener("focus", this.handleFocus)
    this.el.removeEventListener("blur", this.handleBlur)
    this.el.removeEventListener("input", this.handleInput)
  }
}

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {...colocatedHooks, ComposerMeasure, RotatingPlaceholder},
})

topbar.config({barColors: {0: "#8f63ff"}, shadowColor: "rgba(143, 99, 255, .35)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

liveSocket.connect()
window.liveSocket = liveSocket

if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    reloader.enableServerLogs()

    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", _e => keyDown = null)
    window.addEventListener("click", e => {
      if (keyDown === "c") {
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if (keyDown === "d") {
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}
